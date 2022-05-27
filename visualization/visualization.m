classdef visualization < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        GridLayout                      matlab.ui.container.GridLayout
        LeftPanel                       matlab.ui.container.Panel
        GModellSimulationLabel          matlab.ui.control.Label
        SelectSceneLabel                matlab.ui.control.Label
        SelectSceneDropDown             matlab.ui.control.DropDown
        StartStopSimulationSwitchLabel  matlab.ui.control.Label
        StartStopSimulationSwitch       matlab.ui.control.Switch
        Image                           matlab.ui.control.Image
        Label                           matlab.ui.control.Label
        Label2                          matlab.ui.control.Label
        RightPanel                      matlab.ui.container.Panel
        UIAxes                          matlab.ui.control.UIAxes
        SimulatedtimeLabel              matlab.ui.control.Label
        LastactionsTextAreaLabel        matlab.ui.control.Label
        LastactionsTextArea             matlab.ui.control.TextArea
        EditField                       matlab.ui.control.NumericEditField
        placeholderLabel                matlab.ui.control.Label
    end

    % Properties that correspond to apps with auto-reflow
    properties (Access = private)
        onePanelWidth = 576;
    end

    % Callbacks that handle component events
    methods (Access = private)

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

            % Create SelectSceneLabel
            app.SelectSceneLabel = uilabel(app.LeftPanel);
            app.SelectSceneLabel.HorizontalAlignment = 'right';
            app.SelectSceneLabel.Position = [7 618 80 22];
            app.SelectSceneLabel.Text = 'Select Scene:';

            % Create SelectSceneDropDown
            app.SelectSceneDropDown = uidropdown(app.LeftPanel);
            app.SelectSceneDropDown.Position = [102 618 100 22];

            % Create StartStopSimulationSwitchLabel
            app.StartStopSimulationSwitchLabel = uilabel(app.LeftPanel);
            app.StartStopSimulationSwitchLabel.HorizontalAlignment = 'center';
            app.StartStopSimulationSwitchLabel.Position = [19 581 66 28];
            app.StartStopSimulationSwitchLabel.Text = {'Start / Stop'; 'Simulation'};

            % Create StartStopSimulationSwitch
            app.StartStopSimulationSwitch = uiswitch(app.LeftPanel, 'slider');
            app.StartStopSimulationSwitch.Position = [129 585 45 20];

            % Create Image
            app.Image = uiimage(app.LeftPanel);
            app.Image.Position = [7 14 95 27];
            app.Image.ImageSource = 'ic-institute.png';

            % Create Label
            app.Label = uilabel(app.LeftPanel);
            app.Label.FontSize = 7.9;
            app.Label.Position = [102 11 115 31];
            app.Label.Text = {'Andrej Fadin, Haotian Wang, '; 'Huiying Zhang, Marc Wagels, '; 'Oliver Schirrmacher, Till Müller'};

            % Create Label2
            app.Label2 = uilabel(app.LeftPanel);
            app.Label2.FontSize = 8;
            app.Label2.FontWeight = 'bold';
            app.Label2.Position = [14 37 203 42];
            app.Label2.Text = {'Institutsprojekt: '; 'Maschinelles Lernen in der Kommunikationstechnik '; 'und Verteilte Algorithmen für adaptive Schlafmodi '; 'in 5G-Netzen'};

            % Create RightPanel
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.Layout.Row = 1;
            app.RightPanel.Layout.Column = 2;

            % Create UIAxes
            app.UIAxes = uiaxes(app.RightPanel);
            title(app.UIAxes, 'City - Map')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            app.UIAxes.Position = [1 186 735 514];

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
            app.EditField.Position = [10 130 108 22];

            % Create placeholderLabel
            app.placeholderLabel = uilabel(app.RightPanel);
            app.placeholderLabel.Position = [10 78 68 22];
            app.placeholderLabel.Text = 'placeholder';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = visualization

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