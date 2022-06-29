function heap = pop(heap)
    n=size(heap,2);
    if (n==0)
        exit;
    end
    heap(1)=heap(n);
    heap(n)=[];
    n=n-1;
    cur=1;
    ind=cur*2;
    while(ind<=n)
        if (ind+1<=n)
            if smaller(heap(ind+1),heap(ind))
                ind=ind+1;
            end
        end
        if (smaller(heap(cur),heap(ind)))
            break;
        end
        tmp=heap(ind);
        heap(ind)=heap(cur);
        heap(cur)=tmp;
        cur=ind;
        ind=cur*2;
    end
end

