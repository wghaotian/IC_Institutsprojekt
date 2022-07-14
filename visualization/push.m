function [heap] = push(heap,x)
    x.last_evnt=[];
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

