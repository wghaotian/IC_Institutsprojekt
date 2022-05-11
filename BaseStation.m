classdef BaseStation < SimulationsObject
   properties
       sleepMode
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
       
   end
end

