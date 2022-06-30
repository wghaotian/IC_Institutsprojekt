classdef Map
    
    properties
        BS_List = struct;% Base Station List
        CS_List = struct; % Consumer List
        map_size % [x,y] Map Size
        total_Time % total time 
%         BS_eventList=[] % Basestation Event List
%         CS_eventList=[] % Consumer Event List
        eventList=[] % Event List
        served_List % Served Consumer List
        last_obs=0;
    end
    
    methods
        function obj = Map(x,y,total_Time)
            %Map Construct an instance of this class
            obj.BS_List=BaseStation.empty;
            obj.CS_List=Consumer.empty;
            obj.served_List=[];
            obj.map_size=[x,y];
            obj.total_Time=total_Time;
        end
        
        function obj = add_item(obj,obj1)
            if (isa(obj1,'BaseStation'))
                obj.BS_List=[obj.BS_List;obj1];
            elseif (isa(obj1,'Consumer'))
                obj.CS_List=[obj.CS_List;obj1];
            end
        end
        
        function obj = add_BS(obj,pos)% Given coordinates of base stations
            numBS=size(pos,1);
            for I=(1:numBS)
                nameI=['BS ',num2str(size(obj.BS_List,2)+1)];
                obj=obj.add_item(BaseStation(pos(I,1),pos(I,2),nameI,1,I));% Set each base station to sleep3 at first
                evnt.time=0;
                evnt.name='deact';
                evnt.ind=I;
                evnt.type='BS';
                obj.eventList=push(obj.eventList,evnt);
            end
        end
        
        function obj = add_CS(obj)% Add 1 random consumer
            % Question: Should consumers' arrival be equally distributed or
            % otherwise (i.e. normal, lognormal, etc.) distributed???
            % Gleichverteilung scheint ein bisschen sinnlos... 
            % First equally distribution to simplify the simulation process
            % and then find some distribution to it
            
            % Leave time depends on the data demand and the data rate of
            % the base station which is connected to.
            %config;
            
            x=rand()*obj.map_size(1);
            y=rand()*obj.map_size(2);
            nameCS=['CS ',num2str(size(obj.CS_List,2)+1)];
            global conf;
            %arr_t=lognrnd(conf.lamda_arr,conf.nu);
            arr_t=rand*obj.total_Time;
            data=wblrnd(conf.lamda_scale,conf.k_shape)*1048576;
            evnt.time=arr_t;
            evnt.name='arrive';
            evnt.type='CS';
            evnt.ind=size(obj.CS_List,1)+1;
            CS=Consumer(x,y,nameCS,data,0,0,arr_t,evnt.ind);
            obj.eventList=push(obj.eventList,evnt);
            obj=obj.add_item(CS);
        end
        
        function CS_spawn_list = sort_CS_spawn(obj)
            [~,ind]=sort([obj.CS_List.spawn_time]);
            CS_spawn_list=obj.CS_List(ind);
        end
        
        function cg=channel_gain(obj,BS_ind,CS_ind)
            BS=obj.BS_List(BS_ind);
            CS=obj.CS_List(CS_ind);
            cg=128.1+37.6*log10(CalcLength(BS,CS));
            cg=10^(-cg/10);
        end
        
        function snr=SINR(obj,BS_ind,CS_ind)
            n=size(obj.BS_List,2);
            global conf;
            snr=10^(2*(conf.sigma_noise/10));
            
            for I=[(1:BS_ind-1),(BS_ind+1:n)]
                if (obj.BS_List(I).sleepMode~=0) 
                    continue
                else
                    snr=snr+conf.BS_Pow*channel_gain(obj,I,CS_ind);
                end
            end
            snr=conf.BS_Pow*channel_gain(obj,BS_ind,CS_ind)/snr;
        end
        
        function rate=data_rate(obj,BS_ind,CS_ind)
            global conf;
            alpha=1/size(obj.BS_List(BS_ind).serveList,2);
            rate=alpha*conf.W_band*log2(1+SINR(obj,BS_ind ,CS_ind));
        end
        
        function obj=simulate(obj,evnt)
            global conf;
            if strcmp(evnt.type,'CS')
                [obj.CS_List(evnt.ind),obj]=obj.CS_List(evnt.ind).simulate(evnt,obj);
            elseif strcmp(evnt.type,'BS')
                [obj.BS_List(evnt.ind),obj]=obj.BS_List(evnt.ind).simulate(evnt,obj);
            else
                if (abs(obj.last_obs-evnt.time)<conf.eps)
                    return;
                end
                obj.last_obs=evnt.time;
                for I=(1:length(obj.BS_List))
                    [obj.BS_List(I),obj]=obj.BS_List(I).observe(obj,evnt.time);
                end
            end
        end
        
          %% Plotting function    
        function plotCU(obj,axis)
            xy = obj.pos;
            plot(axis,xy(1), xy(2),'bo','MarkerSize',8);
        end
        
    end
end

