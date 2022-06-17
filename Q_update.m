function [Q] = Q_update(Q,cur_s,cur_a,nxt_s,R)
    global conf;
    %Q(cur_s,cur_a+1)=Q(cur_s,cur_a+1)+conf.alpha*(R+conf.gamma*max(Q(nxt_s,:))-Q(cur_s,cur_a+1));
    Q(cur_s,cur_a)=Q(cur_s,cur_a)+conf.alpha*(R+conf.gamma*max(Q(nxt_s,:))-Q(cur_s,cur_a));
end

