classdef visualization2_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        GridLayout                     matlab.ui.container.GridLayout
        LeftPanel                      matlab.ui.container.Panel
        GModellSimulationLabel         matlab.ui.control.Label
        TestSceneDropDownLabel         matlab.ui.control.Label
        TestSceneDropDown              matlab.ui.control.DropDown
        StopResumeSimulationSwitchLabel  matlab.ui.control.Label
        Image                          matlab.ui.control.Image
        Label                          matlab.ui.control.Label
        Label2                         matlab.ui.control.Label
        StartTestAppButton             matlab.ui.control.Button
        ShowTestsCheckBox              matlab.ui.control.CheckBox
        ONButton                       matlab.ui.control.StateButton
        StartselectedSimulationButton  matlab.ui.control.Button
        ChooseSimulationDropDownLabel  matlab.ui.control.Label
        ChooseSimulationDropDown       matlab.ui.control.DropDown
        HilfeButton                    matlab.ui.control.Button
        epsilonSlider                  matlab.ui.control.Slider
        EpsilonGreedyLabel             matlab.ui.control.Label
        epsilonedit                    matlab.ui.control.NumericEditField
        rewardedit                     matlab.ui.control.NumericEditField
        rewardslider                   matlab.ui.control.Slider
        RewardLabel                    matlab.ui.control.Label
        discountedit                   matlab.ui.control.NumericEditField
        discountslider                 matlab.ui.control.Slider
        DiscountLabel                  matlab.ui.control.Label
        learningedit                   matlab.ui.control.NumericEditField
        learningslider                 matlab.ui.control.Slider
        LearningrateLabel              matlab.ui.control.Label
        RightPanel                     matlab.ui.container.Panel
        SimulatedtimeLabel             matlab.ui.control.Label
        LastactionTextAreaLabel        matlab.ui.control.Label
        LastactionTextArea             matlab.ui.control.TextArea
        EditField                      matlab.ui.control.NumericEditField
        placeholderLabel               matlab.ui.control.Label
        KartePanel                     matlab.ui.container.Panel
        UIAxes                         matlab.ui.control.UIAxes
    end

    % Properties that correspond to apps with auto-reflow
    properties (Access = private)
        onePanelWidth = 576;
    end

    
    properties (Access = public)
        gx;
        map;
        text;
        plotTest;
        countStart = 0;
        plottedBSs = 0;
        plottedCUs = 0;
        plottedCUList;
        plottedBSList;
    end
    
    %% Funktionen zum Plotten aller BaseStations und Consumer
    methods (Access = public)
        function plotBSs(app)
            for i = 1:app.map.BS_List.size
            app.plottedBSs = app.plottedBSs + 1;
            app.plottedBSList = [app.plottedBSList app.map.BS_List(i).plotBS(app.UIAxes)];
            end         
        end
        function plotCSs(app)
            for i = 1:app.map.CS_List.size
            app.plottedCUs = app.plottedCUs + 1;
            app.plottedCUList = [app.plottedCUList app.map.CS_List(i).plotCS(app.UIAxes)];
            end
        end
    %% Funktionen zum Deplotten und l�schen aller BaseStations und Consumer
        function deplotBSs(app)
            for i = 1:app.map.BS_List.size
            delete(app.plottedBSList(app.plottedCUs));
            app.plottedBSList = app.plottedBSList([1:app.plottedBSs-1, app.plottedBSs+1:end]);
            app.map.BS_List = app.map.BS_List([1:app.plottedBSs-1, app.plottedBSs+1:end]);
            app.plottedBSs = app.plottedBSs - 1;
            end         
        end
        function deplotCSs(app)
            for i = 1:app.map.CS_List.size
            delete(app.plottedCUList(app.plottedCUs));
            app.plottedCUList = app.plottedCUList([1:app.plottedCUs-1, app.plottedCUs+1:end]);
            app.map.CS_List = app.map.CS_List([1:app.plottedCUs-1, app.plottedCUs+1:end]);
            app.plottedCUs = app.plottedCUs - 1;
            end
        end
        function runconf(app)
            config;
            epsilon = conf.eps;
            app.epsilonedit.Value = epsilon;
            app.epsilonSlider.Value = epsilon;
            
            reward = conf.eta;
            app.rewardedit.Value = reward;
            app.rewardslider.Value = reward;
            
            discount = conf.gamma;
            app.discountedit.Value = discount;
            app.discountslider.Value = discount;
            
            learning = conf.alpha;
            app.learningedit.Value = learning;
            app.learningslider.Value = learning;
            
        end
    end
%     % Value changed function: DropDown
%     function DropDownValueChanged(app, event)
%         value = app.ChooseSimulationDropDown.Value;
%         %If Panel 1 is selected, show panel 1
%         if strcmp(value,'Plotting Test')
%             %% Map initialization
%             karte = Map(500,500,1000,100);
%             
%             %% Start App
%             visualization;
%             
%             app.UIAxes.XLimMode = 'manual';
%             app.UIAxes.XLim = [0,karte.map_size(1)];
%             app.UIAxes.YLim = [0,karte.map_size(2)];
%             
%             %% Plotting-Test
%             plotCU(Cu1,app.UIAxes);
%             %Bs1 = BaseStation(100,300,'BS1',mode);
% 
%         elseif strcmp(value,'Panel 2')
%             app.Panel2.Visible = 'on';
%         elseif strcmp(value,'Panel 3')
%             app.Panel3.Visible = 'on';
%         end
%     end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: StartTestAppButton
        function StartTestAppButtonPushed(app, event)
            if (app.countStart ~= 0)
                cla(app.UIAxes);
                app.countStart = 0;
                disp("Panel cleared");
                app.LastactionTextArea.Value = "Panel cleared";
            elseif (app.countStart == 0)
                config;
                disp("Config geladen");
                app.LastactionTextArea.Value = "Config geladen";
            end
%             app.gx = geoaxes(app.KartePanel);
%             geobasemap(app.gx,'streets-light')
%             hold(app.gx,'on')
            app.countStart = app.countStart +1 ;
            hold(app.UIAxes,'on');
        end

        % Value changed function: TestSceneDropDown
        function TestSceneDropDownValueChanged(app, event)
            value = app.TestSceneDropDown.Value;
            config;
            if (app.countStart == 0)
                app.text = "Dr�cke zuerst auf den Start Knopf!";
            elseif (value == '2' )
                % Add background
                imshow('map_background.png','Parent',app.UIAxes);
                app.text = "Background added.";
            elseif (value == '3' )
                % Add map
                app.map = Map(1200,750,10000);
                app.UIAxes.XLimMode = 'manual';
                app.UIAxes.XLim = [0,app.map.map_size(1)];
                app.UIAxes.YLim = [0,app.map.map_size(2)];
                app.text = "Map with the size: [" + app.map.map_size(1) + "," + app.map.map_size(2) + "] has been created.";
            elseif (value == '4' )
                % Add BS
                app.map = app.map.add_BS([400,250]);
                app.map.BS_List(1).plotBS(app.UIAxes);
%                plot(app.UIAxes,400, 250, 'rx','MarkerSize',10);
                app.text = "Basestation at the position [400,250] has been created.";
            elseif (value == '8' )
                % Add BS
                app.map = app.map.add_BS([250,400]);
                app.map.BS_List(2).setSleep(0);
                app.map.BS_List(2).plotBS(app.UIAxes);
                app.text = "Basestation at the position [250,400] has been created.";
            elseif (value == '5' )
                % Add CU
                app.map = app.map.add_CS;
                app.plottedCUs = app.plottedCUs + 1;
%                 app.plottedCUList = [app.plottedCUList app.map.CS_List(1).plotCS(app.UIAxes)];
%                app.plottedCUList = [app.plottedCUList plot(app.UIAxes,350, 560,'bo','MarkerSize',8)];
                app.plottedCUList = [app.plottedCUList app.map.CS_List(app.plottedCUs).plotCS(app.UIAxes)];
                app.text = "Customer at the position [" + app.map.CS_List(app.plottedCUs).pos(1) + "," + app.map.CS_List(app.plottedCUs).pos(2) +"] has been created.";
            elseif (value == '6' )
                % Remove CU
                app.text = "Customer at the position [" + app.map.CS_List(app.plottedCUs).pos(1) + "," + app.map.CS_List(app.plottedCUs).pos(2) +"] has been removed.";
                delete(app.plottedCUList(app.plottedCUs));
                app.plottedCUList = app.plottedCUList([1:app.plottedCUs-1, app.plottedCUs+1:end]);
                app.map.CS_List = app.map.CS_List([1:app.plottedCUs-1, app.plottedCUs+1:end]);
                app.plottedCUs = app.plottedCUs - 1;
            elseif (value == '7' )
                % Remove Background
                axesHandlesToChildObjects = findobj(app.UIAxes, 'Type', 'image');
                if ~isempty(axesHandlesToChildObjects)
                  delete(axesHandlesToChildObjects);
                  app.text = "Background removed.";
                end
%             elseif (value == '8' )
%                 xy = [300 500];
%                 BSplot = plot(app.UIAxes,xy(1), xy(2), 'rx','MarkerSize',10);
%                 onoffplot = plot(app.UIAxes,xy(1)+16, xy(2)+8, 'g.','MarkerSize',10);
%                 statusplot = text(app.UIAxes,xy(1)+12,xy(2)-8,'SM1','Color',[.7 .7 .7],'FontSize',8); %#ok<ADPROPLC> 
%                 app.plotTest = [BSplot onoffplot statusplot];
%             elseif (value == '9' )
%                 delete(app.plotTest);
            end
            disp(app.text);
            app.LastactionTextArea.Value = app.text;
%             elseif (value == '2' )
%                 latAachen = 50.775555;
%                 lonAachen = 6.083611;
%                 latKoeln = 50.935173;
%                 lonKoeln = 6.953101;
%                 geoplot(app.gx,[latAachen latKoeln],[lonAachen lonKoeln],'g-*')
%             elseif (value == '3' )
%                 latAachen = 50.755555;
%                 lonAachen = 6.083611;
%                 latKoeln = 50.935173;
%                 lonKoeln = 6.953101;
%                 geoplot(app.gx,[latAachen latKoeln],[lonAachen lonKoeln],'g-*')
%             elseif (value == '4' )
%                 latAachen = 50.775555;
%                 lonAachen = 6.083611;
%                 %annotation(app.gx,'textarrow',[latAachen latAachen-0.002],[latAachen latAachen],'String','Aachen');
%                 text(app.gx,latAachen,lonAachen,'\leftarrow Aachen');
%                 latKoeln = 50.935173;
%                 lonKoeln = 6.953101;
%                 text(app.gx,latKoeln,lonKoeln,'\leftarrow Koeln');
        end

        % Callback function
        function SelectSceneDropDown_2ValueChanged(app, event)
            
        end

        % Callback function
        function StartAppButton_2Pushed(app, event)
            if (app.countStart ~= 0)
                f = cla(app.gx,'reset');
                f.Children;
                disp("Panel cleared");
                app.LastactionTextArea.Value = "Panel cleared";
            end
            app.gx = app.UIAxes;
            hold(app.gx,'on')
            app.countStart = app.countStart +1 ;
        end

        % Value changed function: ShowTestsCheckBox
        function ShowTestsCheckBoxValueChanged(app, event)
            value = app.ShowTestsCheckBox.Value;
            if (value == 1)
                app.StartTestAppButton.Visible = 1;
                app.TestSceneDropDown.Visible = 1;
                app.TestSceneDropDownLabel.Visible = 1;
                app.placeholderLabel.Visible = 1;
                app.EditField.Visible = 0;
                app.SimulatedtimeLabel.Visible = 0;
            elseif (value == 0)
                app.StartTestAppButton.Visible = 0;
                app.TestSceneDropDown.Visible = 0;
                app.TestSceneDropDownLabel.Visible = 0;
                app.placeholderLabel.Visible = 0;
                app.EditField.Visible = 1;
                app.SimulatedtimeLabel.Visible = 1;
            end
        end

        % Value changed function: ONButton
        function ONButtonValueChanged(app, event)
            value = app.ONButton.Value;
            if (value == 1)
                app.ONButton.BackgroundColor = [0.00,1.00,0.00];
                app.ONButton.Text = 'ON';
            elseif (value == 0)
                app.ONButton.BackgroundColor = [1.00,0.00,0.00];
                app.ONButton.Text = 'OFF';
            end
        end

        % Value changed function: ChooseSimulationDropDown
        function ChooseSimulationDropDownValueChanged(app, event)
            value = app.ChooseSimulationDropDown.Value;
            ausgabe = ""; %#ok<NASGU> 
            if value ~= "-----"
                ausgabe = "Simulation: '" + value + "' selected.";
            else
                ausgabe = "No Simulation selected.";
            end
            disp(ausgabe);
            app.LastactionTextArea.Value = ausgabe;
            if (app.countStart == 0)
                app.runconf();
            end
        end

        % Button pushed function: StartselectedSimulationButton
        function StartselectedSimulationButtonPushed(app, event)
            if (app.countStart ~= 0)
                f = cla(app.gx,'reset');
                f.Children;
                disp("Panel cleared");
                app.LastactionTextArea.Value = "Panel cleared";
            end
            app.gx = app.UIAxes;
            hold(app.gx,'on')
            app.countStart = app.countStart +1 ;
            %main(app);
        end

        % Button pushed function: HilfeButton
        function HilfeButtonPushed(app, event)
            helpmenu
        end

        % Value changed function: epsilonedit
        function epsiloneditValueChanged(app, event)
            value = app.epsilonedit.Value;
            app.epsilonSlider.Value = value;
            conf.eps = value;
        end

        % Value changed function: epsilonSlider
        function epsilonSliderValueChanged(app, event)
            value = app.epsilonSlider.Value;
            app.epsilonedit.Value = value;
            conf.eps = value;
        end

        % Value changed function: rewardslider
        function rewardsliderValueChanged(app, event)
            value = app.rewardslider.Value;
            app.rewardedit.Value = value;
            conf.eta = value;
        end

        % Value changed function: rewardedit
        function rewardeditValueChanged(app, event)
            value = app.rewardedit.Value;
            app.rewardslider.Value = value;
            conf.eta = value;
        end

        % Value changed function: discountslider
        function discountsliderValueChanged(app, event)
            value = app.discountslider.Value;
            app.discountedit.Value = value;
            conf.gamma = value;
        end

        % Value changed function: discountedit
        function discounteditValueChanged(app, event)
            value = app.discountedit.Value;
            app.discountslider.Value = value;
            conf.gamma = value;
        end

        % Value changed function: learningslider
        function learningsliderValueChanged(app, event)
            value = app.learningslider.Value;
            app.learningedit.Value = value;
            conf.alpha = value;
        end

        % Value changed function: learningedit
        function learningeditValueChanged(app, event)
            value = app.learningedit.Value;
            app.learningslider.Value = value;
            conf.alpha = value;
        end

        % Changes arrangement of the app based on UIFigure width
        function updateAppLayout(app, event)
            currentFigureWidth = app.UIFigure.Position(3);
            if(currentFigureWidth <= app.onePanelWidth)
                % Change to a 2x1 grid
                app.GridLayout.RowHeight = {701, 701};
                app.GridLayout.ColumnWidth = {'1x'};
                app.RightPanel.Layout.Row = 2;
                app.RightPanel.Layout.Column = 1;
            else
                % Change to a 1x2 grid
                app.GridLayout.RowHeight = {'1x'};
                app.GridLayout.ColumnWidth = {223, '1x'};
                app.RightPanel.Layout.Row = 1;
                app.RightPanel.Layout.Column = 2;
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100 100 978 701];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.SizeChangedFcn = createCallbackFcn(app, @updateAppLayout, true);

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {223, '1x'};
            app.GridLayout.RowHeight = {'1x'};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.Scrollable = 'on';

            % Create LeftPanel
            app.LeftPanel = uipanel(app.GridLayout);
            app.LeftPanel.Layout.Row = 1;
            app.LeftPanel.Layout.Column = 1;

            % Create GModellSimulationLabel
            app.GModellSimulationLabel = uilabel(app.LeftPanel);
            app.GModellSimulationLabel.FontWeight = 'bold';
            app.GModellSimulationLabel.Position = [46 665 132 22];
            app.GModellSimulationLabel.Text = '5G- Modell Simulation';

            % Create TestSceneDropDownLabel
            app.TestSceneDropDownLabel = uilabel(app.LeftPanel);
            app.TestSceneDropDownLabel.HorizontalAlignment = 'right';
            app.TestSceneDropDownLabel.Visible = 'off';
            app.TestSceneDropDownLabel.Position = [23 111 69 22];
            app.TestSceneDropDownLabel.Text = 'Test-Scene:';

            % Create TestSceneDropDown
            app.TestSceneDropDown = uidropdown(app.LeftPanel);
            app.TestSceneDropDown.Items = {'Nothing', 'Add Background', 'Add Map', 'Add BS', 'Add BS2', 'Add CU', 'Remove CU', 'Remove Background'};
            app.TestSceneDropDown.ItemsData = {'1', '2', '3', '4', '8', '5', '6', '7'};
            app.TestSceneDropDown.ValueChangedFcn = createCallbackFcn(app, @TestSceneDropDownValueChanged, true);
            app.TestSceneDropDown.Visible = 'off';
            app.TestSceneDropDown.Position = [107 111 100 22];
            app.TestSceneDropDown.Value = '1';

            % Create StopResumeSimulationSwitchLabel
            app.StopResumeSimulationSwitchLabel = uilabel(app.LeftPanel);
            app.StopResumeSimulationSwitchLabel.HorizontalAlignment = 'center';
            app.StopResumeSimulationSwitchLabel.Position = [16 627 85 28];
            app.StopResumeSimulationSwitchLabel.Text = {'Stop / Resume'; 'Simulation'};

            % Create Image
            app.Image = uiimage(app.LeftPanel);
            app.Image.Position = [10 14 95 27];
            app.Image.ImageSource = 'ic-institute.png';

            % Create Label
            app.Label = uilabel(app.LeftPanel);
            app.Label.FontSize = 7.9;
            app.Label.Position = [105 11 115 31];
            app.Label.Text = {'Andrej Fadin, Haotian Wang, '; 'Huiying Zhang, Marc Wagels, '; 'Oliver Schirrmacher, Till M�ller'};

            % Create Label2
            app.Label2 = uilabel(app.LeftPanel);
            app.Label2.FontSize = 8;
            app.Label2.FontWeight = 'bold';
            app.Label2.Position = [17 37 203 42];
            app.Label2.Text = {'Institutsprojekt: '; 'Maschinelles Lernen in der Kommunikationstechnik '; 'und Verteilte Algorithmen f�r adaptive Schlafmodi '; 'in 5G-Netzen'};

            % Create StartTestAppButton
            app.StartTestAppButton = uibutton(app.LeftPanel, 'push');
            app.StartTestAppButton.ButtonPushedFcn = createCallbackFcn(app, @StartTestAppButtonPushed, true);
            app.StartTestAppButton.Visible = 'off';
            app.StartTestAppButton.Position = [62 140 100 22];
            app.StartTestAppButton.Text = 'Start Test-App';

            % Create ShowTestsCheckBox
            app.ShowTestsCheckBox = uicheckbox(app.LeftPanel);
            app.ShowTestsCheckBox.ValueChangedFcn = createCallbackFcn(app, @ShowTestsCheckBoxValueChanged, true);
            app.ShowTestsCheckBox.Text = 'Show Tests?';
            app.ShowTestsCheckBox.Position = [16 82 90 22];

            % Create ONButton
            app.ONButton = uibutton(app.LeftPanel, 'state');
            app.ONButton.ValueChangedFcn = createCallbackFcn(app, @ONButtonValueChanged, true);
            app.ONButton.Text = 'ON';
            app.ONButton.BackgroundColor = [0 1 0];
            app.ONButton.Position = [110 630 100 22];
            app.ONButton.Value = true;

            % Create StartselectedSimulationButton
            app.StartselectedSimulationButton = uibutton(app.LeftPanel, 'push');
            app.StartselectedSimulationButton.ButtonPushedFcn = createCallbackFcn(app, @StartselectedSimulationButtonPushed, true);
            app.StartselectedSimulationButton.Position = [38 519 148 22];
            app.StartselectedSimulationButton.Text = 'Start selected Simulation';

            % Create ChooseSimulationDropDownLabel
            app.ChooseSimulationDropDownLabel = uilabel(app.LeftPanel);
            app.ChooseSimulationDropDownLabel.HorizontalAlignment = 'right';
            app.ChooseSimulationDropDownLabel.FontWeight = 'bold';
            app.ChooseSimulationDropDownLabel.Position = [49 587 118 22];
            app.ChooseSimulationDropDownLabel.Text = 'Choose Simulation:';

            % Create ChooseSimulationDropDown
            app.ChooseSimulationDropDown = uidropdown(app.LeftPanel);
            app.ChooseSimulationDropDown.Items = {'-----', 'Option 1', 'Option 2', 'Option 3', 'Option 4'};
            app.ChooseSimulationDropDown.ValueChangedFcn = createCallbackFcn(app, @ChooseSimulationDropDownValueChanged, true);
            app.ChooseSimulationDropDown.Position = [62 553 100 22];
            app.ChooseSimulationDropDown.Value = '-----';

            % Create HilfeButton
            app.HilfeButton = uibutton(app.LeftPanel, 'push');
            app.HilfeButton.ButtonPushedFcn = createCallbackFcn(app, @HilfeButtonPushed, true);
            app.HilfeButton.Icon = 'help-icon.png';
            app.HilfeButton.IconAlignment = 'right';
            app.HilfeButton.Position = [143 83 64 22];
            app.HilfeButton.Text = 'Hilfe';

            % Create epsilonSlider
            app.epsilonSlider = uislider(app.LeftPanel);
            app.epsilonSlider.Limits = [0 1];
            app.epsilonSlider.ValueChangedFcn = createCallbackFcn(app, @epsilonSliderValueChanged, true);
            app.epsilonSlider.FontSize = 8;
            app.epsilonSlider.Position = [23 482 100 3];

            % Create EpsilonGreedyLabel
            app.EpsilonGreedyLabel = uilabel(app.LeftPanel);
            app.EpsilonGreedyLabel.Position = [29 484 88 22];
            app.EpsilonGreedyLabel.Text = 'Epsilon Greedy';

            % Create epsilonedit
            app.epsilonedit = uieditfield(app.LeftPanel, 'numeric');
            app.epsilonedit.ValueChangedFcn = createCallbackFcn(app, @epsiloneditValueChanged, true);
            app.epsilonedit.Position = [143 472 61 22];

            % Create rewardedit
            app.rewardedit = uieditfield(app.LeftPanel, 'numeric');
            app.rewardedit.ValueChangedFcn = createCallbackFcn(app, @rewardeditValueChanged, true);
            app.rewardedit.Position = [144 424 61 22];

            % Create rewardslider
            app.rewardslider = uislider(app.LeftPanel);
            app.rewardslider.Limits = [0 1];
            app.rewardslider.ValueChangedFcn = createCallbackFcn(app, @rewardsliderValueChanged, true);
            app.rewardslider.FontSize = 8;
            app.rewardslider.Position = [24 434 100 3];

            % Create RewardLabel
            app.RewardLabel = uilabel(app.LeftPanel);
            app.RewardLabel.Position = [30 436 47 22];
            app.RewardLabel.Text = 'Reward';

            % Create discountedit
            app.discountedit = uieditfield(app.LeftPanel, 'numeric');
            app.discountedit.ValueChangedFcn = createCallbackFcn(app, @discounteditValueChanged, true);
            app.discountedit.Position = [144 366 61 22];

            % Create discountslider
            app.discountslider = uislider(app.LeftPanel);
            app.discountslider.Limits = [0 1];
            app.discountslider.ValueChangedFcn = createCallbackFcn(app, @discountsliderValueChanged, true);
            app.discountslider.FontSize = 8;
            app.discountslider.Position = [24 376 100 3];

            % Create DiscountLabel
            app.DiscountLabel = uilabel(app.LeftPanel);
            app.DiscountLabel.Position = [30 378 52 22];
            app.DiscountLabel.Text = 'Discount';

            % Create learningedit
            app.learningedit = uieditfield(app.LeftPanel, 'numeric');
            app.learningedit.ValueChangedFcn = createCallbackFcn(app, @learningeditValueChanged, true);
            app.learningedit.Position = [144 303 61 22];

            % Create learningslider
            app.learningslider = uislider(app.LeftPanel);
            app.learningslider.Limits = [0 1];
            app.learningslider.ValueChangedFcn = createCallbackFcn(app, @learningsliderValueChanged, true);
            app.learningslider.FontSize = 8;
            app.learningslider.Position = [24 313 100 3];

            % Create LearningrateLabel
            app.LearningrateLabel = uilabel(app.LeftPanel);
            app.LearningrateLabel.Position = [30 315 76 22];
            app.LearningrateLabel.Text = 'Learning rate';

            % Create RightPanel
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.Layout.Row = 1;
            app.RightPanel.Layout.Column = 2;

            % Create SimulatedtimeLabel
            app.SimulatedtimeLabel = uilabel(app.RightPanel);
            app.SimulatedtimeLabel.Position = [98 83 88 22];
            app.SimulatedtimeLabel.Text = 'Simulated time:';

            % Create LastactionTextAreaLabel
            app.LastactionTextAreaLabel = uilabel(app.RightPanel);
            app.LastactionTextAreaLabel.HorizontalAlignment = 'right';
            app.LastactionTextAreaLabel.Position = [320 111 67 22];
            app.LastactionTextAreaLabel.Text = 'Last action:';

            % Create LastactionTextArea
            app.LastactionTextArea = uitextarea(app.RightPanel);
            app.LastactionTextArea.Position = [317 14 419 98];

            % Create EditField
            app.EditField = uieditfield(app.RightPanel, 'numeric');
            app.EditField.ValueDisplayFormat = '%11.4g ns';
            app.EditField.Editable = 'off';
            app.EditField.Position = [98 62 88 22];

            % Create placeholderLabel
            app.placeholderLabel = uilabel(app.RightPanel);
            app.placeholderLabel.FontSize = 11;
            app.placeholderLabel.Visible = 'off';
            app.placeholderLabel.Position = [10 6 309 135];
            app.placeholderLabel.Text = {'Test-Tutorial:'; '1. Dr�cke auf Start Test-App'; '2. W�hle darunter folgende Optionen in der angezeigten '; 'Reihenfolge.'; '3. Du kannst auch nach dem Entfernen des Customers '; 'erneut auf Add Cu und Remove Cu dr�cken '; '(beim Background dasselbe)'; '4. Durch erneutes Dr�cken auf Start Test-App cleart sich '; 'das Panel'};

            % Create KartePanel
            app.KartePanel = uipanel(app.RightPanel);
            app.KartePanel.Title = 'Karte';
            app.KartePanel.Position = [10 140 726 547];

            % Create UIAxes
            app.UIAxes = uiaxes(app.KartePanel);
            title(app.UIAxes, '')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            app.UIAxes.XLim = [0 1581];
            app.UIAxes.YLim = [0 853];
            app.UIAxes.ZLim = [0 100];
            app.UIAxes.XAxisLocation = 'origin';
            app.UIAxes.XColor = [0.15 0.15 0.15];
            app.UIAxes.YColor = [0.15 0.15 0.15];
            app.UIAxes.Position = [1 0 726 525];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = visualization2_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end