classdef helpmenu_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure            matlab.ui.Figure
        Image               matlab.ui.control.Image
        ffnenButton         matlab.ui.control.Button
        DokumentationLabel  matlab.ui.control.Label
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: ffnenButton
        function ffnenButtonPushed(app, event)
            winopen('dokumentation.pdf');
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create Image
            app.Image = uiimage(app.UIFigure);
            app.Image.Position = [1 36 640 445];

            % Create ffnenButton
            app.ffnenButton = uibutton(app.UIFigure, 'push');
            app.ffnenButton.ButtonPushedFcn = createCallbackFcn(app, @ffnenButtonPushed, true);
            app.ffnenButton.Position = [120 7 100 22];
            app.ffnenButton.Text = 'Öffnen';

            % Create DokumentationLabel
            app.DokumentationLabel = uilabel(app.UIFigure);
            app.DokumentationLabel.Position = [28 7 93 22];
            app.DokumentationLabel.Text = 'Dokumentation:';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = helpmenu_exported

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