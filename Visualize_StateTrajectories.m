clear
close all
clc


%% Load the data
load("MCdata\StateTrajectories_MCdata.mat","X")


%% Parameter settings
terminal_time = 10;
time_num = 10000;
time = linspace(0, terminal_time, time_num + 1);
blues = slanCM('Blues', 7);
reds = slanCM('Reds', 7);


%% Visualization
figure;
hold on;
box on;

for i = 1:7
    plot(time, X(2*i-1,:,3), 'LineWidth', 1, 'Color', blues(i, :));
end

for i = 1:7
    plot(time, X(2*i,:,3), 'LineWidth', 1, 'Color', reds(i, :));
end

ax = gca;
ax.LineWidth = 1.0;
ax.XAxis.FontSize = 18;
ax.YAxis.FontSize = 18;
xlabel('Time', 'Interpreter', 'latex');
ylabel('States', 'Interpreter', 'latex');
pbaspect([1,1,1]);


%% Save the data
if ~exist('Results', 'dir')
    mkdir('Results');
end

filename = fullfile('Results', 'StateTrajectories.svg');
exportgraphics(gca, filename, 'ContentType', 'vector', 'BackgroundColor', 'none');
