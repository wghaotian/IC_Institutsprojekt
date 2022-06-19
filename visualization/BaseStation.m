classdef BaseStation < SimulationsObject
   properties
       sleepMode
       serveList
       bufferList
       chosen_numSleep=zeros(1,4);
       numSleep=zeros(1,4);
       Q=zeros(4,10); % Index starts from 0!!!!!!
       Delay=-1;
       Energy=0;
       time_idle_start;
       log;
   end
   methods
       %% Constructor
       function BS=BaseStation(x,y,name,Mode,id)
           BS@SimulationsObject(x,y,name,id);
           BS.sleepMode=Mode;
           BS.log.SM_time=[0,0,0,0]; % idle, SM1, SM2, SM3
           BS.log.start_time=[0,0,0,0];
       end
       %% Set Sleep
       function BS=setSleep(BS,SM)
           BS.sleepMode=SM;
       end
       %% Serve
       function [map,BS]=serveCS(BS,CS_ind,map)
           if (BS.sleepMode==0)
               BS.serveList=[BS.serveList,CS_ind];
           
           elseif (BS.sleepMode==1)
               BS.serveList=[BS.serveList,CS_ind];
               global time;
               evnt.time=time;
               evnt.name='active';
               evnt.type='BS';
               evnt.ind=BS.ind;
               map.eventList=push(map.eventList,evnt);

               
           else
               BS.bufferList=[BS.bufferList,CS_ind];
               
           end
       end
       %% Simulate function
       function [obj,map]=simulate(obj,evnt,map)
           global time conf
           new_evnt=evnt;
           switch evnt.name

               case 'deact'
             %% Deactivation
                   obj.Delay=-1;
                   obj.Energy=0;
                   
                   sleepM=4;
                   obj.numSleep(sleepM)=0;
                   obj.sleepMode=4;
                   obj.numSleep(sleepM)=next_action(obj.Q,4);
                   obj.chosen_numSleep(sleepM)=obj.numSleep(sleepM);
                   obj.log.start_time(sleepM)=time;
                   new_evnt.name='sleep';
                   new_evnt.time=time+conf.deact_dur(sleepM);

                   map.eventList=push(map.eventList,new_evnt);
  
               case 'sleep'
             %% Sleep 
                   if ~isempty(obj.bufferList) || obj.numSleep(obj.sleepMode)==0 % break the sleep cycle
                       new_evnt.time=time;
                       new_evnt.name='act';
                       map.eventList=push(map.eventList,new_evnt);
                   else % continue to sleep
                       obj.numSleep(obj.sleepMode)=obj.numSleep(obj.sleepMode)-1;
                       new_evnt.time=time+conf.sleep_dur(obj.sleepMode);
                       new_evnt.name='sleep';
                       map.eventList=push(map.eventList,new_evnt);
                   end
                   
 
               case 'act'
         %% Activation                   
                   prev_SM=obj.sleepMode;
                   sleepM=obj.sleepMode-1;%next sleepM
                   new_evnt.time=time+conf.act_dur(obj.sleepMode);
            % Judge: next sleep mode =?= active/idle/sleep        
                   if (~isempty(obj.bufferList))
                       sleepM=0;
                       
                   else
                       if (sleepM>=2)
                           obj.chosen_numSleep(sleepM)=next_action(obj.Q,prev_SM);
                           obj.numSleep(sleepM)=obj.chosen_numSleep(sleepM);
                       end
                   end
                   
                   % Judge type of next event
                   if (sleepM<=1)
                       if ~isempty(obj.bufferList)
                           sleepM=0;
                           new_evnt.name='active';
                           obj.serveList=obj.bufferList;
                           obj.bufferList=[];
                       else
                           sleepM=1;
                           new_evnt.name='idle';
                       end
                   else
                       new_evnt.name='sleep';
                   end
                   

                   obj.log.SM_time(prev_SM)=obj.log.SM_time(prev_SM)+new_evnt.time-obj.log.start_time(prev_SM);
                   obj.Energy=(new_evnt.time-obj.log.start_time(prev_SM))*(conf.pow_cons(1)-conf.pow_cons(prev_SM));
                   % Update Q Matrix 
                   if (sleepM)
                       R=Reward(obj.Energy,0);
                       obj.Q=Q_update(obj.Q,prev_SM,obj.chosen_numSleep(prev_SM),sleepM,R);
                       obj.log.start_time(sleepM)=new_evnt.time;
                   end
                   
                   map.eventList=push(map.eventList,new_evnt);
                   if (sleepM~=0)% If BS goes to active, leave the SM here in order to update 
                       obj.sleepMode=sleepM;
                   end
                   
               case 'idle'
                   %% Idle
                   obj.time_idle_start=time;
                   obj.log.start_time(1)=time;
                   if (~isempty(obj.bufferList))
                       new_evnt.name='active';
                       map.eventList=push(map.eventList,new_evnt);
                   end
               case 'active'
                   
                   %% Active working state
                   
                   if (obj.Delay==-1)
                       obj.Delay=0;
                       for I=obj.serveList
                           obj.Delay=obj.Delay+time-map.CS_List(I).spawn_time;
                       end
                       if (obj.sleepMode==1)
 %                          obj.Energy=obj.Energy+(time-obj.time_idle_start)*conf.pow_cons(2);
                           obj.Energy=0;
                           obj.log.SM_time(1)=obj.log.SM_time(1)+time-obj.time_idle_start;                           
                       end
                       
                       R=Reward(obj.Energy,obj.Delay);
                       obj.Q=Q_update(obj.Q,obj.sleepMode,obj.chosen_numSleep(max(2,obj.sleepMode)),1,R);
                       obj.sleepMode=0;
                   end
                   
                   for I=obj.serveList
                       map.CS_List(I).data_demand=map.CS_List(I).data_demand-conf.time_eps*map.data_rate(obj.ind,I);
                   end
                   
 %                 obj.serveList(map.CS_List(obj.serveList).data_demand<=0)=[];
                   ind_deact=zeros(conf.num_Cos);
                   tot=0;
                   for I=(1:size(obj.serveList,2))
                       if (map.CS_List(obj.serveList(I)).data_demand<=0)
                           tot=tot+1;
                           ind_deact(tot)=I;
                       end
                   end
                   obj.serveList(ind_deact(1:tot))=[];
                   new_evnt.time=time+conf.time_eps;
                   new_evnt.name='active';
                   if (isempty(obj.serveList))
                       new_evnt.name='deact';
                   end
                   map.eventList=push(map.eventList,new_evnt);
                   
           end
       end
       
      %% Plotting function    
        function plotted = plotBS(obj,axis)
            xy = obj.pos;
            plotted = plot(axis,xy(1), xy(2), 'rx','MarkerSize',10);
        end
       
   end
end

