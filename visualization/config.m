
global conf %Sleep Mode:
    % 0:active    1:idle    2: SM1,    3: SM2,     4: SM3
conf.sleep_dur=[0,71e-6,1e-3,1e-2]; % Sleep Duration for each sleep mode
conf.deact_dur=[0,35.5e-6,.5e-3,5e-3];% Deactivation Duration for each sleep mode
conf.act_dur=[0,35.5e-6,.5e-3,5e-3,.5]; % Activation Duration for each sleep mode
conf.pow_cons=[109,52.3,14.3,9.51]; % Power Consumption for each sleep mode
conf.timestep = 35.5e-6; % Festgelegter Zeitschritt
conf.step = 1; % Aktueller Schritt
conf.timesteps = 1000; % Nummer an Zeitschritten die durchgeführt werden sollen.
conf.num_Cos=5; % Nummer von Consumer
conf.num_BS=1; % Nummer von Basisstationen
conf.total_Time=conf.timesteps*conf.timestep; % total simulation time
conf.W_band=20E6; % Bandwidth
conf.BS_Pow=45; %BS Tx Power (dBm)
conf.Base_Station_pos=[0,300;300,0;300,300;0,0];

conf.sigma_noise=-174; % Thermal noise
conf.lamda_scale=441.305; % scale parameter
conf.k_shape=0.8; % shape parameter

conf.eta=0.5; % Reward function
