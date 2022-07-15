
global conf %Sleep Mode:
    % 0:active    1:idle    2: SM1,    3: SM2,     4: SM3
conf.sleep_dur=[0.1,71e-6,1e-3,1e-2]; % Sleep Duration for each sleep mode
conf.deact_dur=[0,35.5e-6,.5e-3,5e-3];% Deactivation Duration for each sleep mode
conf.act_dur=[0,35.5e-6,.5e-3,5e-3,.5]; % Activation Duration for each sleep mode
conf.pow_cons=[109,52.3,14.3,9.51]; % Power Consumption for each sleep mode

conf.num_Cos=10; % Nummer von Consumer
conf.total_Time=100; % total simulation time
conf.W_band=20E6; % Bandwidth
conf.BS_Pow=45; %BS Tx Power (dBm)
%conf.Base_Station_pos=[0,300;300,0;300,300;0,0];
conf.Base_Station_pos=[100,250;400,250];
conf.num_BS=size(conf.Base_Station_pos,1);
conf.time_eps=1e-6;
conf.sigma_noise=-174; % Thermal noise
conf.lamda_scale=441.305; % scale parameter
conf.k_shape=0.8; % shape parameter
conf.eps=0.9; % Epsilon Greedy
conf.eta=0.6; % Reward function
conf.gamma=0.9; % Discount factor
conf.alpha=0.9; %　Learning rate
conf.lamda_arr=1;
conf.nu=1/10;

conf.num_act=[0.01:0.01:0.09,0.1:0.1:0.9,1:1:10];
conf.action_space='b';%b:big, s:small(limited to 10 for each state)
