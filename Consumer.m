classdef Consumer < SimulationsObject
    properties
        data_demand=0;
        v=[0,0];
    end
    
    methods
  %% Constructor
        function obj=Consumer(x,y,name,dmd,vx,vy)
            obj@SimulationsObject(x,y,name);
            obj.data_demand=dmd;
            obj.v=[vx,vy];
        end
  %% set speed      
        function obj=setSpeed(obj,vx,vy)
            obj.v=[vx,vy];
        end
 %% find the nearest base station       
        function minBS=nearestBS(obj, BS_List)
           min_dist=inf;
           for BS=BS_List
               if (CalcLength(BS,obj)<min_dist)
                   minBS=BS;
                   min_dist=CalcLength(BS,obj);
               end
           end
        end
        
%         function BS_list=sort_BS(obj,BS_List)
%            %List=BaseStation.empty;
%            %BS_list=zeros(size(BS_List));
%            I=0;
%            for BS=BS_List
%                List(I).BS=BS;
%                List(I).dist=CalcLength(obj,BS);
%                I=I+1;
%            end
%            sort(List,'ComparisonMethod','dist');
%            I=0;
%            for item=List
%                BS_list(I)=item.BS;
%                I=I+1;
%            end
%         end
    end
    
end