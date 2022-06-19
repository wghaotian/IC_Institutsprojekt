function [ret] = smaller(event1,event2)
    if (event1.time~=event2.time)
        ret=event1.time<event2.time;
    elseif event2.type(1)=='C'
        ret=event1.type(1)=='C';
    elseif event1.type(1)=='C'
        ret=true;
    else
        if (strcmp(event1.name,'active'))
            ret=true;
        elseif (strcmp(event2.name,'active'))
            ret=false;
        else
            ret=rand>0.5;
        end
    end
    
end

