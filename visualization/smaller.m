function [ret] = smaller(event1,event2)
    if (event1.time~=event2.time)
        ret=event1.time<event2.time;
    else
        priority=zeros(1,128);
        priority('M')=3;
        priority('B')=1;
        priority('C')=2;
        if (event1.type(1)~=event2.type(1))
            ret=priority(event1.type(1))>priority(event2.type(1));
        else
            ret=event1.ind<event2.ind;
        end
    end
    
end

