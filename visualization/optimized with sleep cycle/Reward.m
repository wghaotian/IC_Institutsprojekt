function R = Reward(Energy,Delay)
    global conf;
    R=conf.eta*Energy-(1-conf.eta)*Delay*1000;
end

