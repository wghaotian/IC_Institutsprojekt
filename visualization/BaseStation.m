classdef BaseStation < SimulationsObject
   properties
       sleepMode
       serveList
       bufferList
   end
   methods
       %% Constructor
       function BS=BaseStation(x,y,name,Mode)
           BS@SimulationsObject(x,y,name);
           BS.sleepMode=Mode;
       end
       %% Set Sleep
       function BS=setSleep(BS,SM)
           BS.sleepMode=SM;
       end
       %% Serve
       function BS=serveCS(BS,CS_ind)
           if (BS.sleepMode==0||BS.sleepMode==1)
               BS.serveList=[BS.serveList,CS_ind];
               BS.sleepMode=0;
           else
               BS.bufferList=[BS.bufferList,CS_ind];            
               
           end
       end
       %% Plotting function    
        function plotBS(obj,axis)
            xy = obj.pos;
            plot(axis,xy(1), xy(2), 'rx','MarkerSize',10);
        end
        
   end
end

