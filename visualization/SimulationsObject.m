classdef SimulationsObject < handle
	properties
        pos=[0,0];
        name="";
        ind;
    end
    methods
        %% Calculate Length Function
        function len=CalcLength(SimuObjA, SimuObjB)
            vec=SimuObjA.pos-SimuObjB.pos;
            len=sqrt(vec*vec');
        end
        %% Constructor
        function obj=SimulationsObject(x,y,s,id)
            obj.pos=[x,y];
            obj.name=s;
            obj.ind=id;
        end

    end
end