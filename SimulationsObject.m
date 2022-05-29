classdef SimulationsObject < handle
	properties
        pos=[0,0];
        name="";
    end
    methods
        %% Calculate Length Function
        function len=CalcLength(SimuObjA, SimuObjB)
            vec=SimuObjA.pos-SimuObjB.pos;
            len=sqrt(vec*vec');
        end
        %% Constructor
        function obj=SimulationsObject(x,y,s)
            obj.pos=[x,y];
            obj.name=s;
        end
    end
    
    methods(Static)
        %% Return position
        function xy = position()
            xy=pos;
        end
    end
end