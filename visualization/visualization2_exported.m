classdef visualization2_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                  matlab.ui.Figure
        GridLayout                matlab.ui.container.GridLayout
        LeftPanel                 matlab.ui.container.Panel
        GModellSimulationLabel    matlab.ui.control.Label
        TestSceneDropDownLabel    matlab.ui.control.Label
        TestSceneDropDown         matlab.ui.control.DropDown
        StopResumeSimulationSwitchLabel  matlab.ui.control.Label
        Image                     matlab.ui.control.Image
        Label                     matlab.ui.control.Label
        Label2                    matlab.ui.control.Label
        StartTestAppButton        matlab.ui.control.Button
        ShowTestsCheckBox         matlab.ui.control.CheckBox
        ONButton                  matlab.ui.control.StateButton
        RightPanel                matlab.ui.container.Panel
        SimulatedtimeLabel        matlab.ui.control.Label
        LastactionsTextAreaLabel  matlab.ui.control.Label
        LastactionsTextArea       matlab.ui.control.TextArea
        EditField                 matlab.ui.control.NumericEditField
        placeholderLabel          matlab.ui.control.Label
        Panel                     matlab.ui.container.Panel
        UIAxes                    matlab.ui.control.UIAxes
    end

    % Properties that correspond to apps with auto-reflow
    properties (Access = private)
        onePanelWidth = 576;
    end

    
    properties (Access = public)
        gx;
        countStart = 0;
    end
    
    methods (Access = private)
        
    % Value changed function: DropDown
    function DropDownValueChanged(app, event)
        value = app.DropDown.Value;
        %If Panel 1 is selected, show panel 1
        if strcmp(value,'Plotting Test')
            %% Map initialization
            karte = Map(500,500,1000,100);
            
            %% Start App
            visualization;
            
            app.UIAxes.XLimMode = 'manual';
            app.UIAxes.XLim = [0,karte.map_size(1)];
            app.UIAxes.YLim = [0,karte.map_size(2)];
            
            %% Plotting-Test
            plotCU(Cu1,app.UIAxes);
            %Bs1 = BaseStation(100,300,'BS1',mode);

        elseif strcmp(value,'Panel 2')
            app.Panel2.Visible = 'on';
        elseif strcmp(value,'Panel 3')
            app.Panel3.Visible = 'on';
        end
    end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: StartTestAppButton
        function StartTestAppButtonPushed(app, event)
            if (app.countStart ~= 0)
                f = cla(app.gx,'reset');
                f.Children;
                app.LastactionsTextArea.Value = "Panel cleared" + newline + app.LastactionsTextArea.Value;
            end
%             app.gx = geoaxes(app.Panel);
%             geobasemap(app.gx,'streets-light')
%             hold(app.gx,'on')
            app.countStart = app.countStart +1 ;
        end

        % Value changed function: TestSceneDropDown
        function TestSceneDropDownValueChanged(app, event)
            value = app.TestSceneDropDown.Value;
            if (app.countStart == 0)
                app.LastactionsTextArea.Value = "Dr�cke zuerst auf den Start Knopf!" + newline + app.LastactionsTextArea.Value;
            elseif (value == '2' )
                % Add background
                imshow('map_background.png','Parent',app.UIAxes);
            elseif (value == '3' )
                % Add map
                
            elseif (value == '4' )
                % Add BS
                
            elseif (value == '5' )
                % Add CU
                
            elseif (value == '6' )
                % Remove CU
                
            end
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
            value = app.SelectSceneDropDown_2.Value;
            if (app.countStart == 0)
                app.LastactionsTextArea.Value = "Dr�cke zuerst auf den Start Knopf!" + newline + app.LastactionsTextArea.Value;
            elseif (value == '2' )
                latAachen = 50.0;
                lonAachen = 6.0;
                latKoeln = 80;
                lonKoeln = 7;
                plot(app.gx,[latAachen latKoeln],[lonAachen lonKoeln],'g-*')
            end
        end

        % Callback function
        function StartAppButton_2Pushed(app, event)
            if (app.countStart ~= 0)
                f = cla(app.gx,'reset');
                f.Children;
                app.LastactionsTextArea.Value = "Panel cleared" + newline + app.LastactionsTextArea.Value;
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
            elseif (value == 0)
                app.StartTestAppButton.Visible = 0;
                app.TestSceneDropDown.Visible = 0;
                app.TestSceneDropDownLabel.Visible = 0;
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
            app.TestSceneDropDownLabel.Position = [20 111 69 22];
            app.TestSceneDropDownLabel.Text = 'Test-Scene:';

            % Create TestSceneDropDown
            app.TestSceneDropDown = uidropdown(app.LeftPanel);
            app.TestSceneDropDown.Items = {'Nothing', 'Add Background', 'Add Map', 'Add BS', 'Add CU', 'Remove CU'};
            app.TestSceneDropDown.ItemsData = {'1', '2', '3', '4', '5', '6'};
            app.TestSceneDropDown.ValueChangedFcn = createCallbackFcn(app, @TestSceneDropDownValueChanged, true);
            app.TestSceneDropDown.Visible = 'off';
            app.TestSceneDropDown.Position = [104 111 100 22];
            app.TestSceneDropDown.Value = '1';

            % Create StopResumeSimulationSwitchLabel
            app.StopResumeSimulationSwitchLabel = uilabel(app.LeftPanel);
            app.StopResumeSimulationSwitchLabel.HorizontalAlignment = 'center';
            app.StopResumeSimulationSwitchLabel.Position = [16 627 85 28];
            app.StopResumeSimulationSwitchLabel.Text = {'Stop / Resume'; 'Simulation'};

            % Create Image
            app.Image = uiimage(app.LeftPanel);
            app.Image.Position = [7 14 95 27];
            app.Image.ImageSource = 'ic-institute.png';

            % Create Label
            app.Label = uilabel(app.LeftPanel);
            app.Label.FontSize = 7.9;
            app.Label.Position = [102 11 115 31];
            app.Label.Text = {'Andrej Fadin, Haotian Wang, '; 'Huiying Zhang, Marc Wagels, '; 'Oliver Schirrmacher, Till M�ller'};

            % Create Label2
            app.Label2 = uilabel(app.LeftPanel);
            app.Label2.FontSize = 8;
            app.Label2.FontWeight = 'bold';
            app.Label2.Position = [14 37 203 42];
            app.Label2.Text = {'Institutsprojekt: '; 'Maschinelles Lernen in der Kommunikationstechnik '; 'und Verteilte Algorithmen f�r adaptive Schlafmodi '; 'in 5G-Netzen'};

            % Create StartTestAppButton
            app.StartTestAppButton = uibutton(app.LeftPanel, 'push');
            app.StartTestAppButton.ButtonPushedFcn = createCallbackFcn(app, @StartTestAppButtonPushed, true);
            app.StartTestAppButton.Visible = 'off';
            app.StartTestAppButton.Position = [59 140 100 22];
            app.StartTestAppButton.Text = 'Start Test-App';

            % Create ShowTestsCheckBox
            app.ShowTestsCheckBox = uicheckbox(app.LeftPanel);
            app.ShowTestsCheckBox.ValueChangedFcn = createCallbackFcn(app, @ShowTestsCheckBoxValueChanged, true);
            app.ShowTestsCheckBox.Text = 'Show Tests?';
            app.ShowTestsCheckBox.Position = [13 82 90 22];

            % Create ONButton
            app.ONButton = uibutton(app.LeftPanel, 'state');
            app.ONButton.ValueChangedFcn = createCallbackFcn(app, @ONButtonValueChanged, true);
            app.ONButton.Text = 'ON';
            app.ONButton.BackgroundColor = [0 1 0];
            app.ONButton.Position = [110 630 100 22];
            app.ONButton.Value = true;

            % Create RightPanel
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.Layout.Row = 1;
            app.RightPanel.Layout.Column = 2;

            % Create SimulatedtimeLabel
            app.SimulatedtimeLabel = uilabel(app.RightPanel);
            app.SimulatedtimeLabel.Position = [10 151 88 22];
            app.SimulatedtimeLabel.Text = 'Simulated time:';

            % Create LastactionsTextAreaLabel
            app.LastactionsTextAreaLabel = uilabel(app.RightPanel);
            app.LastactionsTextAreaLabel.HorizontalAlignment = 'right';
            app.LastactionsTextAreaLabel.Position = [307 151 70 22];
            app.LastactionsTextAreaLabel.Text = 'Last actions';

            % Create LastactionsTextArea
            app.LastactionsTextArea = uitextarea(app.RightPanel);
            app.LastactionsTextArea.Editable = 'off';
            app.LastactionsTextArea.Position = [307 14 429 138];

            % Create EditField
            app.EditField = uieditfield(app.RightPanel, 'numeric');
            app.EditField.ValueDisplayFormat = '%11.4g ns';
            app.EditField.Editable = 'off';
            app.EditField.Position = [10 130 88 22];

            % Create placeholderLabel
            app.placeholderLabel = uilabel(app.RightPanel);
            app.placeholderLabel.Position = [10 14 342 98];
            app.placeholderLabel.Text = {'Bekannte Bugs:'; 'X'};

            % Create Panel
            app.Panel = uipanel(app.RightPanel);
            app.Panel.Title = 'Panel';
            app.Panel.Position = [10 183 726 504];

            % Create UIAxes
            app.UIAxes = uiaxes(app.Panel);
            title(app.UIAxes, 'Title')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            app.UIAxes.XLim = [0 1000];
            app.UIAxes.YLim = [0 750];
            app.UIAxes.ZLim = [0 100];
            app.UIAxes.Position = [1 -1 726 483];

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