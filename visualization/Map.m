classdef Map
    
    properties
        BS_List % Base Station List
        CS_List % Consumer List
        map_size % [x,y] Map Size
        total_Time% total time 
        max_Cap % maximum channel capacity in Mbps
    end
    
    methods
        function obj = Map(x,y,total_Time,max_Cap)
            %Map Construct an instance of this class
            obj.BS_List=BaseStation.empty;
            obj.CS_List=Consumer.empty;
            obj.map_size=[x,y];
            obj.total_Time=total_Time;
            obj.max_Cap=max_Cap;
        end
        
        function obj = add_item(obj,obj1)
            n_BS=size(obj.BS_List,2);
            n_CS=size(obj.CS_List,2);
            if (isa(obj1,'BaseStation'))
                obj.BS_List(n_BS+1)=obj1;
            elseif (isa(obj1,'Consumer'))
                obj.CS_List(n_CS+1)=obj1;
            end
        end
        
        function obj = add_BS(obj,pos)% Given coordinates of base stations
            numBS=size(pos,1);
            for I=(1:numBS)
                nameI=['BS ',num2str(size(obj.BS_List,2)+1)];
                obj=obj.add_item(BaseStation(pos(I,:),nameI,1));% Set each base station to active at first
            end
        end
        
        function obj = add_CS(obj)% Add 1 random consumer
            % Question: Should consumers' arrival be equally distributed or
            % otherwise (i.e. normal, lognormal, etc.) distributed???
            % Gleichverteilung finde ich ein bisschen sinnlos... 
            x=rand()*obj.map_size(1);
            y=rand()*obj.map_size(2);
            nameCS=['CS ',num2str(size(obj.CS_List,2)+1)];
            arr_t=rand()*obj.total_Time;
            leav_t=arr_t+rand()*(obj.total_Time-arr_t);
            data=rand()*obj.max_Cap;
            CS=Consumer(x,y,nameCS,data,0,0,arr_t,leav_t);
            obj=obj.add_item(CS);
        end
        
        function CS_spawn_list = sort_CS_spawn(obj)
            [~,ind]=sort([obj.CS_List.spawn_time]);
            CS_spawn_list=obj.CS_List(ind);
        end
        
        
        function CS_despawn_list = sort_CS_despawn(obj)
            [~,ind]=sort([obj.CS_List.spawn_time]);
            CS_despawn_list=obj.CS_List(ind);
        end
        
    end
end

