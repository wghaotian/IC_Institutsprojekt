clearvars;
run('config.m');
global conf;
karte=Map(500,500,conf.total_Time);
for I=(1:conf.num_Cos)
    karte=karte.add_CS();
end
karte=karte.add_BS(conf.Base_Station_pos);

CS_spawn_List=karte.sort_CS_spawn();


global time;
time=0;
while ~(isempty(karte.eventList))
    min_evnt=karte.eventList(1);
    karte.eventList=pop(karte.eventList);
    time=min_evnt.time;
    karte=karte.simulate(min_evnt);
end
