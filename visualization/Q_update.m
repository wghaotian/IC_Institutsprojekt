function [Q] = Q_update(Q,cur_s,cur_a,nxt_s,R)
    global conf;
    Q(cur_s,cur_a+1)=Q(cur_s,cur_a+1)+conf.alpha*(R+conf.gamma*max(Q(nxt_s,:))-Q(cur_s,cur_a+1));
%     if (~cur_a)||(~cur_s)||(~nxt_s)
%         disp('Error Detected');
%         disp([num2str(cur_s),' ',num2str(cur_a),' ',num2str(nxt_s)]);
%         return;
%     end
%    Q(cur_s,cur_a)=Q(cur_s,cur_a)+conf.alpha*(R+conf.gamma*max(Q(nxt_s,:))-Q(cur_s,cur_a));
end

