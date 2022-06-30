function main(app)
    clearvars;
    run('config.m');
    global conf;
    app.map=Map(500,500,conf.total_Time);
    for I=(1:conf.num_Cos)
        app.map=app.map.add_CS();
    end
    app.map=app.map.add_BS(conf.Base_Station_pos);

    CS_spawn_List=app.map.sort_CS_spawn();


    global time;
    time=0;
    while ~(isempty(app.map.eventList))
        min_evnt=app.map.eventList(1);
        app.map.eventList=pop(app.map.eventList);
        time=min_evnt.time;
        app.map=app.map.simulate(min_evnt);
        app.EditField.Value = time;

        %% Zu Testzwecken werden (erstmal alle Plots entfernt und neu erstellt)
        deplotBSs(app);
        deplotCSs(app);
        plotBSs(app,app.map);
        plotCSs(app,app.map);


        value = app.ONButton.Value;
            if (value == 0)
                disp("Simulation temporär pausiert");
                app.LastactionTextArea.Value = "Simulation temporär pausiert";
                while (value == 0)
                    pause(1);
                end
                disp("Simulation fortgesetzt.");
                app.LastactionTextArea.Value = "Simulation fortgesetzt.";
            end

    end
    disp("Simulation nach " + time + "ms beendet.");
    app.LastactionTextArea.Value = "Simulation nach " + time + "ms beendet.";
end