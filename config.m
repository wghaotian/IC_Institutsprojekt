%Sleep Mode:
    % 0: active, 1: idle, 2: SM1, 3: SM2, 4: SM3
deact_dur=[0,0,35.5e-6,.5e-3,5e-3,.5];% Deactivation Duration for each sleep mode
act_dur=[0,0,35.5e-6,.5e-3,5e-3,.5]; % Activation Duration for each sleep mode
pow_cons=[250,109,52.3,14.3,9.51]; % Power Consumption for each sleep mode
timestep = 35.5e-6; % Festgelegter Zeitschritt
step = 1; % Aktueller Schritt
timesteps = 1000; % Nummer an Zeitschritten die durchgeführt werden sollen.
num_Cos=5; % Nummer von Consumer
num_BS=1; % Nummer von Basisstationen
total_Time=timesteps*timestep; % total simulation time
max_Cap=1000; % Maximum Capacity of the base station channel (in Mbps)

Base_Station_pos=[0,300;300,0;300,300;0,0];
