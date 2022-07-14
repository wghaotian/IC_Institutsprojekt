classdef Consumer < SimulationsObject
    properties
        data_demand=0;
        v=[0,0];
        spawn_time=0;
        cur_BS_ind=0;
        leave_time=inf;
        last_obs=0;
        act_time=0;
        cur_data_rate=0;
        delay=0;
    end
       
    methods
        %% Plotting function
        function plotted = plotCS(obj,axis)
            global time;
            if (time<obj.spawn_time)
                plotted=[];
  %              plotted = plot (axis, obj.pos(1), obj.pos(2), 'o', 'MarkerSize', 8);
            elseif (obj.data_demand>0)
                plotted = plot(axis,obj.pos(1), obj.pos(2),'bo','MarkerSize',8);
            else
                plotted = plot(axis, obj.pos(1), obj.pos(2), 'go', 'MarkerSize', 8);
            end
        end
  %% Constructor
        function obj=Consumer(x,y,name,dmd,vx,vy,arr_t,id)
            obj@SimulationsObject(x,y,name,id);
            obj.data_demand=dmd;
            obj.v=[vx,vy];
            obj.spawn_time=arr_t;
            obj.last_obs=0;
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
                     [map,map.BS_List(obj.cur_BS_ind)]=map.BS_List(obj.cur_BS_ind).serveCS(obj.ind, map,evnt);
                     
             end
         end
         %% Observe
         function [obj,map,flag]=observe(obj,map,time,last_evnt)
             flag=false;
             new_evnt.type='Map';
             new_evnt.name='Obs';
             new_evnt.ind=0;
             obj.data_demand=obj.data_demand-(time-obj.last_obs)*obj.cur_data_rate;
             prev_data_rate=obj.cur_data_rate;
             obj.cur_data_rate=map.data_rate(obj.cur_BS_ind, obj.ind);
             if prev_data_rate~=obj.cur_data_rate
                 flag=true;
             end
             if (obj.data_demand<0)
                 map.served_List=[map.served_List,obj.ind];
                 %map.BS_List(obj.cur_BS_ind).serveList(map.BS_List(obj.cur_BS_ind).serveList==obj.ind)=[];
                 obj.leave_time=time;
                 Broadcast_evnt.name='leave';
                 Broadcast_evnt.type='CS';
                 Broadcast_evnt.time=time;
                 Broadcast_evnt.ind=obj.ind;
                 Broadcast_evnt.last_evnt=last_evnt;
                 map.eventList=push(map.eventList,Broadcast_evnt);
                 new_evnt.time=time;
                 new_evnt.last_evnt=Broadcast_evnt;
                 map.eventList=push(map.eventList,new_evnt);
                 return;
             end
             if obj.last_obs==0
                 obj.delay=obj.act_time-obj.spawn_time;
             end
             obj.last_obs=time;
             global conf;
             obj.leave_time=time+max(conf.time_eps,obj.data_demand/obj.cur_data_rate);
             new_evnt.time=obj.leave_time;
             last_evnt_=last_evnt;
             last_evnt.name='planned leaving';
             last_evnt.type='CS';
             last_evnt.ind=obj.ind;
             last_evnt.time=obj.leave_time;
             last_evnt.prev_time=time;
             last_evnt.last_evnt=last_evnt_;
             new_evnt.last_evnt=last_evnt;
             map.eventList=push(map.eventList,new_evnt);
         end
    end
    
    
    
    
end