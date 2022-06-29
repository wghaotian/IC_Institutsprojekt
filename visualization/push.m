function [heap] = push(heap,x)
    global conf;
    if (~isempty(heap))
        if (heap(1).type(1)=='M' && x.type(1)=='M' && abs(heap(1).time-x.time)<conf.eps)
            return;
        end
    end
    heap=[heap,x];
    cur=size(heap,2);
    fa=floor((cur)/2);
    if cur~=1
        while smaller(heap(cur),heap(fa))
            tmp=heap(fa);
            heap(fa)=heap(cur);
            heap(cur)=tmp;
            cur=fa;
            fa=floor(fa/2);
            if (fa==0)
                break;
            end
        end
    end
end

