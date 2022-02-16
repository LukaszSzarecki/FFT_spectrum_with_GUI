classdef fft_analyser_v3_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        fftAnalyserFigure      matlab.ui.Figure
        BasicFFTAnalyserLabel  matlab.ui.control.Label
        ChartsPanel            matlab.ui.container.Panel
        UIAxes2                matlab.ui.control.UIAxes
        UIAxes                 matlab.ui.control.UIAxes
        Load_filePanel         matlab.ui.container.Panel
        CloseButton            matlab.ui.control.Button
        Label                  matlab.ui.control.Label
        FilenameLabel          matlab.ui.control.Label
        BrowseButton           matlab.ui.control.Button
        MediaPanel             matlab.ui.container.Panel
        Switch                 matlab.ui.control.Switch
        StopButton             matlab.ui.control.Button
        PlayButton             matlab.ui.control.Button
    end

    
    properties (Access = private)
        sample_frequency = 2^15;
        stopped = false;
    end
    
    methods (Access = private)
        
        function results = plot_ffts(app)
            global y_save
            global fs_save
            global sound

%             global stopped
            
            Fs = fs_save;
            x = y_save;

            fs = app.sample_frequency;

            
%             ---------------------------------------COUNTS FFTS
            [fft_data1, fft_data2, step] = count_ffts_data(app,x,fs);
%             ---------------------------------------COUNTS FFTS

            top_ylim = 2.005*abs(max(fft_data1)/step);   
            
%             ----------------------------------------PLOT GRAPHS
            play(sound); 
%           ----MATLAB CHART
            
            ax2=app.UIAxes2;
            xlabel(ax2,'f (Hz)');
            ylabel(ax2,'|P1_2(f)|');
            
            ylim(ax2, [0,top_ylim]); 
            xlim(ax2, [0,1200]);
            
%             ^^^^^OWN FFT CHART
            ax1=app.UIAxes;
            xlabel(ax1,'f (Hz)');
            ylabel(ax1,'|P1(f)|');
            
            ylim(ax1,[0,top_ylim]);            
            xlim(ax1,[0,1200]);

%           =====ANIMATE MATLAB FFT AND OWN FFT FUNCTION            

             for i=0:floor(length(x)/step)-1
             start = i*step+1;
             stop = (i+1)*step;
            
            
             Y1 = fft_data1(start:stop);
             Y2 = fft_data2(start:stop);
            
             L1 = length(Y1);  % L1ength of signal
             Fs1 = Fs;  % Sampling frequency1
              
             P2 = abs(Y1/L1);
             P1 = P2(1:L1/2+1);
             P1(2:end-1) = 2*P1(2:end-1);
             
             f1 = Fs1*(0:(L1/2))/L1;    
            
            
             L2 = length(Y2);  % L1ength of signal
             Fs2 = Fs;  % Sampling frequency1
                
             P2_2 = abs(Y2/L2);
             P1_2 = P2_2(1:L2/2+1);
             P1_2(2:end-1) = (2*P1_2(2:end-1));
             
             f2 = Fs2*(0:(L2/2))/L2;
             
             if app.stopped == true
                break

             else
                bar(ax1,f1,P1 ,2.5);
                bar(ax2,f2,P1_2, 2.5);
             
%               Uniwersalny
                 pause(0.93 * fs/Fs); %file example
             end
             
             end
            


%             ----------------------------------------PLOT GRAPHS

        end
        

%         --------------------------------------------FFT OWN FUNCTION
        function[x] = fft_iterative_DIT(app,x)
        %Radix 2 FFT
        % Decimation in Time DIT 
        % Non-recursive procedure of DIT algorithm
            n = length(x); %length of x[] is a power of 2
            x = x(bitrevorder(1:n)); %metoda numeracji o odwróconej kolejnosci bitow
            
            ldn = round(log2(n)); 
            
            for ldm=1:ldn
                m = 2^ldm;
                m_half = m/2;
                
                for k=1:m_half
                    e = exp(-1i*2*pi*(k-1)/m);
                    
                    for r=0:m:n-m
                        u = x(r+k);
                        v = x(r+k+m_half) * e;
                        x(r+k) = u + v;
                        x(r+k+m_half) = u - v;
                    end
                end
            end
        

        end
%         --------------------------------------------FFT OWN FUNCTION

%         --------------------------------------------COUNT FFTS DATA
        function[fft_data1,fft_data2, step] = count_ffts_data(app,x,fs)
            step = fs;
            
            % own FFT
            for i=0:floor(length(x)/step)-1
                start = i*step+1;
                stop = (i+1)*step;
                fft_data1(start:stop) = fft_iterative_DIT(app,x(start:stop));
            end 
            
            % Matlab FFT 
            for i=0:floor(length(x)/step)-1
                start = i*step+1;
                stop = (i+1)*step;
                fft_data2(start:stop) = fft(x(start:stop));
            end
        end
%         --------------------------------------------COUNT FFTS DATA


    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            global sound
            sound = 0;
            
        end

        % Button pushed function: BrowseButton
        function BrowseButtonPushed(app, event)
            global sound
            global y_save
            global fs_save
            
            [filename, pathname] = uigetfile({'*.wav;*.flac;*.mp3','Supported audio file';... 
                                            '*.wav','Waveform Audio File Format (*.wav)';...
                                            '*.flac','Free Lossless Audio Codec (*.flac)';... 
                                            '*.mp3','MPEG 1 Layer3 (*.mp3)';...
                                            '*.*','All files (*.*)'});
                                        
            if isequal(filename,0) || isequal(pathname,0)
                sound = 0;
                return
            else
                [x, fs] = audioread([pathname,filename]);            % x:signal  fs:rate
                sound=audioplayer(x, fs);          
                        
                app.Label.Text=filename;
                
                y_save=x;
                fs_save=fs;
            end
        end

        % Button pushed function: PlayButton
        function PlayButtonPushed(app, event)
            global sound           

            if sound == 0
                return
            else
                app.stopped = false;
                plot_ffts(app);
            end
            
        end

        % Button pushed function: StopButton
        function StopButtonPushed(app, event)
            global sound
            
            app.stopped = true;
            stop(sound);

        end

        % Button pushed function: CloseButton
        function CloseButtonPushed(app, event)
           delete(app.fftAnalyserFigure)  
        end

        % Value changed function: Switch
        function SwitchValueChanged(app, event)
            value = app.Switch.Value;
            if strcmp(value,'Song')
                app.sample_frequency = 2^12;
            else
                app.sample_frequency = 2^15; 
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create fftAnalyserFigure and hide until all components are created
            app.fftAnalyserFigure = uifigure('Visible', 'off');
            app.fftAnalyserFigure.Position = [100 100 886 622];
            app.fftAnalyserFigure.Name = 'MATLAB App';

            % Create MediaPanel
            app.MediaPanel = uipanel(app.fftAnalyserFigure);
            app.MediaPanel.ForegroundColor = [0.302 0.7451 0.9333];
            app.MediaPanel.Title = 'Media';
            app.MediaPanel.BackgroundColor = [0.8 0.8 0.8];
            app.MediaPanel.Position = [22 69 261 251];

            % Create PlayButton
            app.PlayButton = uibutton(app.MediaPanel, 'push');
            app.PlayButton.ButtonPushedFcn = createCallbackFcn(app, @PlayButtonPushed, true);
            app.PlayButton.Position = [7 158 247 63];
            app.PlayButton.Text = 'Play';

            % Create StopButton
            app.StopButton = uibutton(app.MediaPanel, 'push');
            app.StopButton.ButtonPushedFcn = createCallbackFcn(app, @StopButtonPushed, true);
            app.StopButton.Position = [7 78 247 63];
            app.StopButton.Text = 'Stop';

            % Create Switch
            app.Switch = uiswitch(app.MediaPanel, 'slider');
            app.Switch.Items = {'Sample', 'Song'};
            app.Switch.ValueChangedFcn = createCallbackFcn(app, @SwitchValueChanged, true);
            app.Switch.Position = [54 49 45 20];
            app.Switch.Value = 'Sample';

            % Create Load_filePanel
            app.Load_filePanel = uipanel(app.fftAnalyserFigure);
            app.Load_filePanel.ForegroundColor = [0.302 0.7451 0.9333];
            app.Load_filePanel.Title = 'Load_file';
            app.Load_filePanel.BackgroundColor = [0.8 0.8 0.8];
            app.Load_filePanel.Position = [22 358 261 251];

            % Create BrowseButton
            app.BrowseButton = uibutton(app.Load_filePanel, 'push');
            app.BrowseButton.ButtonPushedFcn = createCallbackFcn(app, @BrowseButtonPushed, true);
            app.BrowseButton.Position = [8 159 247 63];
            app.BrowseButton.Text = 'Browse';

            % Create FilenameLabel
            app.FilenameLabel = uilabel(app.Load_filePanel);
            app.FilenameLabel.Position = [16 127 55 22];
            app.FilenameLabel.Text = 'Filename';

            % Create Label
            app.Label = uilabel(app.Load_filePanel);
            app.Label.BackgroundColor = [0.902 0.902 0.902];
            app.Label.Position = [9 99 245 27];
            app.Label.Text = '';

            % Create CloseButton
            app.CloseButton = uibutton(app.Load_filePanel, 'push');
            app.CloseButton.ButtonPushedFcn = createCallbackFcn(app, @CloseButtonPushed, true);
            app.CloseButton.Position = [140 15 115 63];
            app.CloseButton.Text = 'Close';

            % Create ChartsPanel
            app.ChartsPanel = uipanel(app.fftAnalyserFigure);
            app.ChartsPanel.ForegroundColor = [0.302 0.7451 0.9333];
            app.ChartsPanel.Title = 'Charts';
            app.ChartsPanel.BackgroundColor = [0.902 0.902 0.902];
            app.ChartsPanel.Position = [305 62 563 547];

            % Create UIAxes
            app.UIAxes = uiaxes(app.ChartsPanel);
            title(app.UIAxes, 'OWN FFT FUNCTION')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.XGrid = 'on';
            app.UIAxes.YGrid = 'on';
            app.UIAxes.Position = [11 270 541 244];

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.ChartsPanel);
            title(app.UIAxes2, 'MATLAB FFT')
            xlabel(app.UIAxes2, 'X')
            ylabel(app.UIAxes2, 'Y')
            zlabel(app.UIAxes2, 'Z')
            app.UIAxes2.XGrid = 'on';
            app.UIAxes2.YGrid = 'on';
            app.UIAxes2.Position = [11 11 541 244];

            % Create BasicFFTAnalyserLabel
            app.BasicFFTAnalyserLabel = uilabel(app.fftAnalyserFigure);
            app.BasicFFTAnalyserLabel.BackgroundColor = [0.302 0.7451 0.9333];
            app.BasicFFTAnalyserLabel.HorizontalAlignment = 'center';
            app.BasicFFTAnalyserLabel.FontSize = 16;
            app.BasicFFTAnalyserLabel.FontWeight = 'bold';
            app.BasicFFTAnalyserLabel.FontColor = [1 1 1];
            app.BasicFFTAnalyserLabel.Position = [22 14 846 38];
            app.BasicFFTAnalyserLabel.Text = 'Basic FFT Analyser';

            % Show the figure after all components are created
            app.fftAnalyserFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = fft_analyser_v3_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.fftAnalyserFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.fftAnalyserFigure)
        end
    end
end