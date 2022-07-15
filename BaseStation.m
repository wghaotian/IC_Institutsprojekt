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
        prev_SM;
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
            BS.prev_SM=Mode;
            BS.log.SM_time=[0,0,0,0]; % idle, SM1, SM2, SM3
            BS.log.start_time=[0,0,0,0];
            BS.log.SM_num=[0,0,0,0];
            BS.log.Energy=0;
            BS.log.Delay=0;
            BS.log.num_nxt_action=0;
            global conf;
            BS.Q=zeros(4,length(conf.num_act));
%             if conf.action_space=='s'
%                 BS.Q=zeros(4,10);
%             end
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
            map.unservedList=pop(map.unservedList);
        end
        %% Simulate function
        function [obj,map]=simulate(obj,evnt,map)
            global time conf
            new_evnt=evnt;
            switch evnt.name
                
                case 'deact'
                    %% Deactivation
                    
                    if (obj.prev_SM<=1||obj.sleepMode<=1) %to decide next sleep mode
                        nxt_SM=4;
                        if (obj.prev_SM==1)
                            obj.log.SM_time(1)=obj.log.SM_time(1)+time-obj.log.start_time(1);
                        end
                        obj.prev_SM=1;
                    else
                        nxt_SM=obj.sleepMode-1;
                    end
                    %			nxt_SM>=1 is then garanted
                    obj.chosen_numSleep(nxt_SM)=next_action(obj.Q, obj.prev_SM);
                    obj.log.num_nxt_action=obj.log.num_nxt_action+1;
                    obj.log.num_nxt_action=obj.log.num_nxt_action+1;
                    obj.numSleep(nxt_SM)=act2num(obj.chosen_numSleep(nxt_SM),nxt_SM);
                    
                    
                    if (obj.numSleep(nxt_SM)) % Next sleep mode determined
                        new_evnt.time=time+conf.deact_dur(nxt_SM);
                        
                        if (nxt_SM==1)
                            new_evnt.name='idle';
                        elseif (nxt_SM>=2)
                            new_evnt.name='sleep';
                        else
                            new_evnt.name='deact';
                        end
                        
                        obj.log.start_time(nxt_SM)=time;
                        if time && obj.Delay<conf.time_eps
                            obj.Q=Q_update(obj.Q,obj.prev_SM,obj.chosen_numSleep(obj.prev_SM),nxt_SM,0);% Total energy and delay caculated into reward or just in this period?
                        end
                        
                        obj.log.start_time(nxt_SM)=time;
                        
                    else % Next sleep mode undetermined
                        new_evnt.name='deact';
                    end
                    
                    obj.sleepMode=nxt_SM;
                    
                    map.eventList=push(map.eventList,new_evnt);
                    
                    new_obs_evnt=struct('type','Map','name','Obs','time',time,'ind',0);
                    map.eventList=push(map.eventList,new_obs_evnt);
                    
                    obj.Delay=-1;
                    obj.Energy=0;
                case 'sleep'
                    %% Sleep
                    if ~obj.sleepMode
                        return;
                    end
                    obj.prev_SM=obj.sleepMode;
                    if (~isempty(obj.bufferList)) || obj.numSleep(obj.sleepMode)==0 % break the sleep cycle
                        new_evnt.time=time;
                        new_evnt.name='act';
                        map.eventList=push(map.eventList,new_evnt);
                    else % continue to sleep
                        if ~isempty(map.unservedList)
                            available_SM=floor((map.unservedList(1).time-time)/conf.sleep_dur(obj.sleepMode));
                        else
                            available_SM=obj.numSleep(obj.sleepMode);
                        end
                        available_SM=min(available_SM,obj.numSleep(obj.sleepMode));
                        if (~available_SM)
                            available_SM=1;
                        end
                        obj.log.SM_num(obj.sleepMode)=obj.log.SM_num(obj.sleepMode)+available_SM;
                        obj.numSleep(obj.sleepMode)=obj.numSleep(obj.sleepMode)-available_SM;
                        new_evnt.time=time+conf.sleep_dur(obj.sleepMode)*available_SM;
                        new_evnt.name='sleep';
                        map.eventList=push(map.eventList,new_evnt);
                    end
                    
                    
                case 'act'
                    %% Activation
                    % 			Decide next sleep mode
                    if (~isempty(obj.bufferList))
                        nxt_SM=0;
                    else
                        nxt_SM=max(1,obj.sleepMode-1);
                    end
                    %			Choose next action based on nxt_SM
                    if (nxt_SM)% if not active
                        obj.chosen_numSleep(nxt_SM)=next_action(obj.Q,obj.sleepMode);
                        obj.log.num_nxt_action=obj.log.num_nxt_action+1;
                        obj.numSleep(nxt_SM)=act2num(obj.chosen_numSleep(nxt_SM),nxt_SM);
                        
                        if (obj.numSleep(nxt_SM))% if chosen~=0
                            
                            new_evnt.time=time+conf.act_dur(obj.prev_SM);
                            obj.log.SM_time(obj.prev_SM)=obj.log.SM_time(obj.prev_SM)+new_evnt.time-obj.log.start_time(obj.prev_SM);
                            if (nxt_SM==1)
                                new_evnt.name='idle';
                            else
                                new_evnt.name='sleep';
                            end
                            obj.Energy=(new_evnt.time-obj.log.start_time(obj.prev_SM))*(conf.pow_cons(1)-conf.pow_cons(obj.sleepMode));
                            obj.log.Energy=obj.log.Energy+obj.Energy;
                            R=Reward(obj.Energy,0);
                            obj.Q=Q_update(obj.Q,obj.prev_SM,obj.chosen_numSleep(obj.prev_SM),nxt_SM,R);
                            if (obj.prev_SM~=obj.sleepMode) % Last chosen is 0
                                obj.Q=Q_update(obj.Q,obj.sleepMode,obj.chosen_numSleep(obj.sleepMode),nxt_SM,0);
                            end
                        else % chosen = 0
                            new_evnt.name='act';
                            obj.Q=Q_update(obj.Q,obj.prev_SM,obj.chosen_numSleep(obj.prev_SM),nxt_SM,0);
                        end
                        
                    else
                        new_evnt.name='active';
                        new_evnt.time=time+conf.act_dur(obj.prev_SM);
                    end
                    
                    obj.sleepMode=nxt_SM;
                    map.eventList=push(map.eventList,new_evnt);
                    
                    
                case 'idle'
                    %% Idle
                    if (obj.sleepMode~=1)
                        return;
                    end
                    obj.prev_SM=1;
                    if (~isempty(obj.bufferList))
                        new_evnt.name='active';
                        map.eventList=push(map.eventList,new_evnt);
                        return;
                    end
                    if ~isempty(map.unservedList)
                        available_SM=floor((map.unservedList(1).time-time)/conf.sleep_dur(1));
                    else
                        available_SM=obj.numSleep(1);
                    end
                    available_SM=min(available_SM,obj.numSleep(1));
                    available_SM=max(available_SM,1);
                    obj.numSleep(1)=obj.numSleep(1)-available_SM;
                    obj.log.SM_num(1)=obj.log.SM_num(1)+available_SM;
                    if (obj.numSleep(1)<=0)
                        new_evnt.name='deact';
                        %                        obj.Q=Q_update(obj.Q,1,obj.chosen_numSleep(1),4,0);
                        obj.prev_SM=1;
                    else
                        new_evnt.name='idle';
                        new_evnt.time=time+conf.sleep_dur(1);
                    end
                    map.eventList=push(map.eventList,new_evnt);
                    
                case 'active'
                    
                    %% Active working state
                    
                    obj.Delay=0;
                    for I=obj.bufferList
                        obj.Delay=obj.Delay+time-map.CS_List(I).spawn_time;
                    end
                    obj.serveList=[obj.serveList,obj.bufferList];
                    obj.bufferList=[];
                    obj.log.Delay=obj.log.Delay+obj.Delay;
                    if (obj.prev_SM==1)
                        %obj.Energy=0;
                        obj.log.SM_time(1)=obj.log.SM_time(1)+time-obj.log.start_time(1);
                    end

                    R=Reward(obj.Energy,obj.Delay);
                    obj.Q=Q_update(obj.Q,obj.prev_SM,obj.chosen_numSleep(max(1,obj.prev_SM)),1,R);
                    obj.sleepMode=0;
                    
                    obj.prev_SM=0;
                    new_evnt.type='Map';
                    new_evnt.time=time;
                    new_evnt.name='Obs';
                    new_evnt.ind=0;
                    map.eventList=push(map.eventList,new_evnt);
                    
                    
            end
        end
        
        %% Observation Function
        function [obj,map]=observe(obj,map,time)
            served=[];
            flag=false;
            for I=1:length(obj.serveList)
                ind=obj.serveList(I);
                [map.CS_List(ind),map,flag1]=map.CS_List(ind).observe(map,time);
                flag=flag||flag1;
                if map.CS_List(ind).data_demand<0
                    served=[served,I];
                end
            end
            map.flag=map.flag||flag;
            %% TODO
            obj.serveList(served)=[];
            if isempty(obj.serveList) && (obj.sleepMode==0)
                new_evnt.name='deact';
                new_evnt.time=time;
                new_evnt.type='BS';
                new_evnt.ind=obj.ind;
                obj.sleepMode=4;
                map.eventList=push(map.eventList,new_evnt);
            end
            
            
        end
        
        
    end
end

