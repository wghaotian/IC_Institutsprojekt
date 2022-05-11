classdef Map
    
    properties
        BS_List % Base Station List
        CS_List % Consumer List
    end
    
    methods
        function obj = Map()
            %Map Construct an instance of this class
            obj.BS_List=BaseStation.empty;
            obj.CS_List=Consumer.empty;
        end
        
        function obj = add_item(obj,obj1)
            n_BS=size(obj.BS_List);
            n_BS=n_BS(2);
            n_CS=size(obj.CS_List);
            n_CS=n_CS(2);
            if (isa(obj1,'BaseStation'))
                obj.BS_List(n_BS+1)=obj1;
            elseif (isa(obj1,'Consumer'))
                obj.CS_List(n_CS+1)=obj1;
            end
        end
        
    end
end

