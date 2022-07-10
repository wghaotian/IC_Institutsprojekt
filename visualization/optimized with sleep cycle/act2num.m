function [num] = act2num(act,cur_state)
    global conf;
    if conf.action_space=='s'
        num=act;
        return;
    end
    act_coe=conf.num_act(act);
    x=conf.tau/conf.sleep_dur(cur_state);
    num=floor(act_coe*x);
end

