function [n] = next_action(Q, cur_state)
    global conf num_decision;
    num_decision=num_decision+1;
    rnd=rand;
    tau=conf.total_Time/conf.num_Cos;
    num_act=2*floor(tau/conf.sleep_dur(cur_state));
    num_act=10;
    cur_state=max(1,cur_state);
    if (rnd>=conf.eps)
        [mx,~]=max(Q(cur_state,1:num_act));
        ind=Q(cur_state,1:num_act)==mx;
        lst=(1:num_act);
        lst(~ind)=[];
        n=lst(randperm(size(lst,2),1));
    else
        n=randperm(num_act,1);
    end
    n=n-1;


    
end

