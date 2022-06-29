function main(app)
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
        app.EditField.Value = time;
        
        %% Zu Testzwecken werden (erstmal alle Plots entfernt und neu erstellt)
        app.deplotBSs();
        app.deplotCSs();
        app.plotBSs(karte);
        app.plotCSs(karte);
        
        
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