classdef SimulationsObject < handle
	properties (GetAccess=public)
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
%         %% Return position
%         function xy = position(obj)
%             xy= obj.pos;
%         end
    end
end