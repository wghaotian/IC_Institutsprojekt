classdef BaseStation < SimulationsObject
   properties
       sleepMode
       serveList
       bufferList
       chosen_numSleep=zeros(1,4);
       numSleep=zeros(1,4);
       Q=zeros(4,100); % Index starts from 0!!!!!!
       Delay=-1;
       Energy=0;
       time_idle_start;
       log;
   end
   methods
        %% Plotting function    
        function plotted = plotBS(obj,axis,app)
            xy = obj.pos;
            BSplot = plot(axis,xy(1), xy(2), 'rx','MarkerSize',10);
            if(obj.sleepMode > 1)
%                onoffplot = plot(axis,xy(1)+(16/1200)*app.xSize, xy(2)+(8/750)*app.ySize, 'g.','MarkerSize',10);
                onoffplot = plot(axis,xy(1), xy(2), 'g.','MarkerSize',10);
            else
                onoffplot = plot(axis,xy(1), xy(2), 'r.','MarkerSize',10);
            end
            switch obj.sleepMode
                case 0
                    sleepmode='Active';
                case 1
                    sleepmode='idle';
                otherwise
                    sleepmode = ["SM " , num2str(obj.sleepMode-1) , ""];
            end
            
            statusplot = text(axis,xy(1)+(12/1200)*app.xSize,xy(2)-(8/750)*app.ySize,sleepmode,'Color',[.7 .7 .7],'FontSize',8);
            plotted = [BSplot onoffplot statusplot];
        end
       %% Constructor
       function BS=BaseStation(x,y,name,Mode,id)
           BS@SimulationsObject(x,y,name,id);
           BS.sleepMode=Mode;
           BS.log.SM_time=[0,0,0,0]; % idle, SM1, SM2, SM3
           BS.log.start_time=[0,0,0,0];
           BS.log.SM_num=[0,0,0,0];
       end
       %% Set Sleep
       function BS=setSleep(BS,SM)
           BS.sleepMode=SM;
       end
       %% Serve
       function [map,BS]=serveCS(BS,CS_ind,map)
           if (BS.sleepMode==0) % active
               BS.serveList=[BS.serveList,CS_ind];
               new_evnt.type='Map';
               new_evnt.name='Obs';
               global time;
               new_evnt.time=time;
               new_evnt.ind=0;
               map.eventList=push(map.eventList,new_evnt);
           elseif (BS.sleepMode==1) % idle
               BS.serveList=[BS.serveList,CS_ind];
               global time;
               evnt.time=time;
               evnt.name='active';
               evnt.type='BS';
               evnt.ind=BS.ind;
               map.eventList=push(map.eventList,evnt);

               
           else % sleep
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
                   if (obj.sleepMode==1)
                       obj.log.SM_time(1)=obj.log.SM_time(1)+time-obj.log.start_time(1);
                   end
                   if (obj.sleepMode~=0)
                       return;
                   end
                   obj.Delay=-1;
                   obj.Energy=0;
                   new_obs_evnt.type='Map';
                   new_obs_evnt.name='Obs';
                   new_obs_evnt.time=time;
                   new_obs_evnt.ind=0;
                   map.eventList=push(map.eventList,new_obs_evnt);
                   nxt_SM=4;
                   obj.numSleep(nxt_SM)=0;
                   obj.sleepMode=4;
                   obj.numSleep(nxt_SM)=next_action(obj.Q,4);
                   obj.chosen_numSleep(nxt_SM)=obj.numSleep(nxt_SM);
                   obj.log.start_time(nxt_SM)=time;
                   new_evnt.name='sleep';
                   new_evnt.time=time+conf.deact_dur(nxt_SM);

                   map.eventList=push(map.eventList,new_evnt);
  
               case 'sleep'
             %% Sleep 
                   if (~isempty(obj.bufferList)) || obj.numSleep(obj.sleepMode)==0 % break the sleep cycle
                       new_evnt.time=time;
                       new_evnt.name='act';
                       map.eventList=push(map.eventList,new_evnt);
                   else % continue to sleep
                       obj.log.SM_num(obj.sleepMode)=obj.log.SM_num(obj.sleepMode)+1;
                       obj.numSleep(obj.sleepMode)=obj.numSleep(obj.sleepMode)-1;
                       new_evnt.time=time+conf.sleep_dur(obj.sleepMode);
                       new_evnt.name='sleep';
                       map.eventList=push(map.eventList,new_evnt);
                   end
                   
 
               case 'act'
         %% Activation                   
                   prev_SM=obj.sleepMode;
                   nxt_SM=obj.sleepMode-1;%next sleepM
                   new_evnt.time=time+conf.act_dur(obj.sleepMode);
            % Judge: next sleep mode =?= active/idle/sleep        
                   if (~isempty(obj.bufferList))
                       nxt_SM=0;
                       
                   else
                       if (nxt_SM>=1)
                           obj.chosen_numSleep(nxt_SM)=next_action(obj.Q,prev_SM);
                           obj.numSleep(nxt_SM)=obj.chosen_numSleep(nxt_SM);
                       end
                   end
                   
                   % Decide type of next event
                   if (nxt_SM<=1)
                       if ~isempty(obj.bufferList)||nxt_SM<=0
                           nxt_SM=0;
                           new_evnt.name='active';
                           obj.serveList=obj.bufferList;
                           obj.bufferList=[];
                       else
                           nxt_SM=1;
                           new_evnt.name='idle';
                       end
                   else
                       new_evnt.name='sleep';
                   end
                   

                   obj.log.SM_time(prev_SM)=obj.log.SM_time(prev_SM)+new_evnt.time-obj.log.start_time(prev_SM);
                  % obj.Energy=(new_evnt.time-obj.log.start_time(prev_SM))*(conf.pow_cons(1)-conf.pow_cons(prev_SM));
                  obj.Energy=(new_evnt.time-obj.log.start_time(prev_SM))*(conf.pow_cons(prev_SM));

                  % Update Q Matrix 
                   if (nxt_SM)
                       R=Reward(obj.Energy,0);
                       obj.Q=Q_update(obj.Q,prev_SM,obj.chosen_numSleep(prev_SM),nxt_SM,R);
                       obj.log.start_time(nxt_SM)=new_evnt.time;
                   end
                   
                   map.eventList=push(map.eventList,new_evnt);
                   if (nxt_SM~=0)% If BS goes to active, leave the SM here in order to update 
                       obj.sleepMode=nxt_SM;
                   end
                   
               case 'idle'
                   %% Idle
                   if (obj.sleepMode~=1)
                       return;
                   end
                   if (~isempty(obj.bufferList))
                       new_evnt.name='active';
                       map.eventList=push(map.eventList,new_evnt);
                       return;
                   end
                   obj.numSleep(1)=obj.numSleep(1)-1;
                   if (obj.numSleep(1)<=0)
                       new_evnt.name='deact';
                       obj.Q=Q_update(obj.Q,1,obj.chosen_numSleep(1),4,0);
                   else
                       new_evnt.name='idle';
                       new_evnt.time=time+conf.sleep_dur(1);
                   end
                   map.eventList=push(map.eventList,new_evnt);
                   
               case 'active'
                   
                   %% Active working state
                   
                   if (obj.Delay==-1)
                       obj.Delay=0;
                       for I=obj.serveList
                           obj.Delay=obj.Delay+time-map.CS_List(I).spawn_time;
                       end
                       if (obj.sleepMode==1)
                           obj.Energy=obj.Energy+(time-obj.log.start_time(1))*conf.pow_cons(2);
                           %obj.Energy=0;
                           obj.log.SM_time(1)=obj.log.SM_time(1)+time-obj.log.start_time(1);                           
                       end
                       
                       R=Reward(obj.Energy,obj.Delay);
                       obj.Q=Q_update(obj.Q,obj.sleepMode,obj.chosen_numSleep(max(2,obj.sleepMode)),1,R);
                       obj.sleepMode=0;
                   end
                   
%                    for I=obj.serveList
%                        map.CS_List(I).data_demand=map.CS_List(I).data_demand-conf.time_eps*map.data_rate(obj.ind,I);
%                    end
                   
                   new_evnt.type='Map';
                   new_evnt.time=time;
                   new_evnt.name='Obs';
                   new_evnt.ind=0;
%                    obj.serveList(map.CS_List(obj.serveList).data_demand<=0)=[];
%                    ind_deact=zeros(conf.num_Cos);
%                    tot=0;
%                    for I=(1:size(obj.serveList,2))
%                        if (map.CS_List(obj.serveList(I)).data_demand<=0)
%                            tot=tot+1;
%                            ind_deact(tot)=I;
%                            map.served_List=[map.served_List,obj.serveList(I)];
%                        end
%                    end
%                    obj.serveList(ind_deact(1:tot))=[];
%                    new_evnt.time=time+conf.time_eps;
%                    new_evnt.name='active';
%                    if (isempty(obj.serveList))
%                        new_evnt.name='deact';
%                    end
                    map.eventList=push(map.eventList,new_evnt);
                   
                   
           end
       end
       
      %% Observation Function
      function [obj,map]=observe(obj,map,time)
          
          for ind=obj.serveList
              [map.CS_List(ind),map]=map.CS_List(ind).observe(map,time);
          end
          
          if isempty(obj.serveList) && (obj.sleepMode==0)
              new_evnt.name='deact';
              new_evnt.time=time;
              new_evnt.type='BS';
              new_evnt.ind=obj.ind;
              map.eventList=push(map.eventList,new_evnt);
          end
          
          
      end
              
       
   end
end

