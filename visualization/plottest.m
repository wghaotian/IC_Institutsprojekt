%% Map initialization
karte = Map(500,500,1000,100);

%% Start App
visualization;
app.UIAxes.XLimMode = 'manual';
app.UIAxes.XLim = [0,karte.map_size(1)];
app.UIAxes.YLim = [0,karte.map_size(2)];

%% Plotting-Test
Cu1 = Consumer(200,400,'CU1',10,0,0,0,1000);
plotCU(app.UIAxes,Cu1);
%Bs1 = BaseStation(100,300,'BS1',mode);


