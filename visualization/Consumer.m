classdef Consumer < SimulationsObject
    properties
        data_demand=0;
        v=[0,0];
        spawn_time=0;
    end
    
    events
        arrive
        leave
    end
    
    methods
  %% Constructor
        function obj=Consumer(x,y,name,dmd,vx,vy,arr_t)
            obj@SimulationsObject(x,y,name);
            obj.data_demand=dmd;
            obj.v=[vx,vy];
            obj.spawn_time=arr_t;
        end
  %% set speed      
        function obj=setSpeed(obj,vx,vy)
            obj.v=[vx,vy];
        end
 %% find the nearest base station  
        function [index,minBS]=nearestBS(obj, BS_List)
           num_BS=size(BS_List,2);
           dist=zeros(num_BS);
           for I=(1:num_BS)
               dist(I)=obj.CalcLength(BS_List(I));
           end
           [~,index]=min(dist);
           minBS=BS_List(index);
        end
        
  %% Plotting function    
        function plotCU(obj,axis)
            xy = obj.pos;
            plot(axis,xy(1), xy(2), 'kx');
        end
        
%% Data Request 
        function Arrive(obj,time)
            notify(obj,'arrive');
            obj.spawn_time=time;
        end
        
        function Leave(obj,time)
            notify(obj,'leave');
            obj.despawn_time=time;
        end
            

    end
    
    
    
    
end
