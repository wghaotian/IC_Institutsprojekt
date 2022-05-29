classdef Consumer < SimulationsObject
    properties
        data_demand=0;
        v=[0,0];
        spawn_time=0;
        despawn_time=0;
    end
    
    events
        arrive
        leave
    end
    
    methods
  %% Constructor
        function obj=Consumer(x,y,name,dmd,vx,vy,arr_t,leav_t)
            obj@SimulationsObject(x,y,name);
            obj.data_demand=dmd;
            obj.v=[vx,vy];
            obj.spawn_time=arr_t;
            obj.despawn_time=leav_t;
        end
  %% set speed      
        function obj=setSpeed(obj,vx,vy)
            obj.v=[vx,vy];
        end
  %% Plotting function    
        function plotCU(obj,axis)
            xy = obj.pos;
            plot(axis,xy(1), xy(2), 'kx');
        end
 %% find the nearest base station  
 % Q: Ignore the capacity of base stations?
 % Q: Or should we also try to allocate the channel capacity?
        function [index,minBS]=nearestBS(obj, BS_List)
           min_dist=inf;
           index=1;
           I=1;
           for BS=BS_List
               if (CalcLength(BS,obj)<min_dist)
                   minBS=BS;
                   index=I;
                   min_dist=CalcLength(BS,obj);
               end
               I=I+1;
           end
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