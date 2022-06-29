function [n] = next_action(Q, cur_state)
    global conf num_decision;
    num_decision=num_decision+1;
    rnd=rand;
    num_act=size(Q,2);
    if (rnd>=conf.eps)
        [mx,~]=max(Q(cur_state,:));
        ind=Q(cur_state,:)==mx;
        lst=(1:num_act);
        lst(~ind)=[];
        n=lst(randperm(size(lst,2),1));
        
    else
        n=randperm(num_act,1);
    end
    n=n-1;

    
end

