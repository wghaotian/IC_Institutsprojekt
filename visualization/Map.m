classdef Map
    
    properties
        BS_List % Base Station List
        CS_List % Consumer List
        map_size % [x,y] Map Size
        total_Time % total time 

    end
    
    methods
        function obj = Map(x,y,total_Time)
            %Map Construct an instance of this class
            obj.BS_List=BaseStation.empty;
            obj.CS_List=Consumer.empty;
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
                obj=obj.add_item(BaseStation(pos(I,1),pos(I,2),nameI,1));% Set each base station to active at first
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

            
            x=rand()*obj.map_size(1);
            y=rand()*obj.map_size(2);
            nameCS=['CS ',num2str(size(obj.CS_List,2)+1)];
            arr_t=rand()*obj.total_Time; % to be fixed
            global conf;
            data=wblrnd(conf.lamda_scale,conf.k_shape);
            CS=Consumer(x,y,nameCS,data,0,0,arr_t);
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
        
    end
end

