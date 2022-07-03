function R = Reward(Energy,Delay)
    global conf;
    R=-conf.eta*Energy-(1-conf.eta)*Delay;
end

