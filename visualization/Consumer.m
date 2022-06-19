classdef Consumer < SimulationsObject
    properties
        data_demand=0;
        v=[0,0];
        spawn_time=0;
        cur_BS_ind=0;
    end
       
    methods
  %% Constructor
        function obj=Consumer(x,y,name,dmd,vx,vy,arr_t,id)
            obj@SimulationsObject(x,y,name,id);
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
           num_BS=size(BS_List,1);
           dist=zeros(1,num_BS);
           for I=(1:num_BS)
               dist(I)=obj.CalcLength(BS_List(I));
           end
           [~,index]=min(dist);
           minBS=BS_List(index);
        end
        
 %% Simulate
         function [obj,map]=simulate(obj,evnt,map)
             switch evnt.name
                 case 'arrive'
                     [obj.cur_BS_ind,~]=nearestBS(obj,map.BS_List);
                     [map,map.BS_List(obj.cur_BS_ind)]=map.BS_List(obj.cur_BS_ind).serveCS(obj.ind, map);
                     
             end
         end
         
%% Plotting function
        function plotCS(obj,axis)
            xy = obj.pos;
            plot(axis,xy(1), xy(2),'bo','MarkerSize',8);
        end
    end
    
    
    
end