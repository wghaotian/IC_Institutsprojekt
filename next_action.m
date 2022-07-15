function [act_num] = next_action(Q, cur_state)
    global conf num_decision;
    num_decision=num_decision+1;
    rnd=rand;
    action_space=conf.num_act;
    x=length(action_space);
    if conf.action_space=='s'
        x=10;
        action_space=0:x-1;
    end
    
    % Eliminate repeated elements
%     action_space=sort(action_space);
%     action_space_=[0,action_space];
%     action_space=[action_space,action_space(end)];
%     action_space(action_space==action_space_)=[];
%     action_space=action_space+1;
    
    cur_state=max(1,cur_state);
    if (rnd>=conf.eps)
        [mx,~]=max(Q(cur_state,:));
        ind=Q(cur_state,:)==mx;
        lst=(1:x);
        lst(~ind)=[];
        act_num=lst(randperm(size(lst,2),1));
    else
        act_num=(randperm(length(action_space),1));
    end



    
end

