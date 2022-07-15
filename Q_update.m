function [Q] = Q_update(Q,cur_s,cur_a,nxt_s,R)
    global conf;
    if (conf.action_space=='s')
        cur_a=cur_a+1;
    end
    Q(cur_s,cur_a)=Q(cur_s,cur_a)+conf.alpha*(R+conf.gamma*max(Q(nxt_s,:))-Q(cur_s,cur_a));
end

