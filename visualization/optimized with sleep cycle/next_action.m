function [n] = next_action(Q, cur_state)
    global conf num_decision;
    num_decision=num_decision+1;
    rnd=rand;
    tau=conf.total_Time/conf.num_Cos;
    x=(tau/conf.sleep_dur(cur_state));
    action_space=floor(x*conf.num_act);
    if conf.action_space=='s'
        x=10;
        action_space=0:x-1;
    end
    
    % Eliminate repeated elements
    action_space=sort(action_space);
    action_space_=[0,action_space];
    action_space=[action_space,action_space(end)];
    action_space(action_space==action_space_)=[];
    action_space=action_space+1;
    
    cur_state=max(1,cur_state);
    if (rnd>=conf.eps)
        [mx,~]=max(Q(cur_state,action_space));
        ind=Q(cur_state,action_space)==mx;
        lst=(1:x);
        lst(~ind)=[];
        n=lst(randperm(size(lst,2),1));
    else
        n=action_space(randperm(length(action_space),1));
    end
    n=n-1;


    
end

