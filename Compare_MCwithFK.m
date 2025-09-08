clear
close all
clc


%% Download the data
load("MCdata\SafeProb_MCdata.mat")
load("PDEdata\SafeProb_FKdata_(lambda_0,sigma=0.2).mat")
load("PDEdata\SafeProb_FKdata_(lambda_1,sigma=0.2).mat")
load("PDEdata\SafeProb_FKdata_(lambda_2,sigma=0.2).mat")
load("PDEdata\SafeProb_FKdata_(lambda_3,sigma=0.2).mat")
load("PDEdata\SafeProb_FKdata_(lambda_4,sigma=0.2).mat")
load("PDEdata\SafeProb_FKdata_(lambda_5,sigma=0.2).mat")
load("PDEdata\SafeProb_FKdata_(lambda_6,sigma=0.2).mat")
threshold = [2, 2, 1.5, 1.5, 1.5, 1.0, 1.0];

% Set the initial state vector
N = 7;
n = 2;
L = [5, -1, -1, -1, -1, -1, 0;
    -1, 3, 0, -1, 0, 0, -1;
    -1, 0, 2, 0, -1, 0, 0;
    -1, -1, 0, 4, -1, -1, 0;
    -1, 0, -1, -1, 4, -1, 0;
    -1, 0, 0, -1, -1, 3, 0;
    0, -1, 0, 0, 0, 0, 1];
[T, Lambda] = eig(L);
GFT = kron(transpose(T), eye(n));
initial_state_1 = transpose([0.3, 0.6, -0.6, 0.1, 0.3, -0.6, 0]);
initial_state_2 = transpose([-0.4, 0.6, -0.4, 0.6, 0.3, 0.1, -0.6]);
initial_state = kron(initial_state_1, [1;0]) + kron(initial_state_2, [0;1]);
initial_spectrum = GFT * initial_state;


%% Safety probability obtained by the MC sampling
time_num = length(times);
safeprob_stat = zeros(time_num, 1);

for i = 1:time_num
    safeprob_stat(i) = safeprob_MC((length(safeprob_MC)-1)*(i-1)/(time_num-1) + 1);
end


%% Safety probability obtained by the Feynman-Kac PDE
safeprob_PDEdata = cat(4, data_lambda_0, data_lambda_1, data_lambda_2, data_lambda_3, data_lambda_4, data_lambda_5, data_lambda_6);
safeprob_mode = zeros(time_num, N);

for i = 1:N
    step_size = 2*threshold(i)/256;
    x_index = round((initial_spectrum(2*i-1) + threshold(i)) / step_size);
    y_index = round((initial_spectrum(2*i) + threshold(i)) / step_size);
    safeprob_mode(:,i) = safeprob_PDEdata(:, x_index, y_index, i);
end

safeprob_FK = prod(safeprob_mode, 2);


%% Visualization
figure
hold on
box on
colors = slanCM('RdPu', 10); 
colororder(colors);

if 1
    for i = 1:N
        h = plot(times, safeprob_mode(:,i), LineWidth=2);
    end
end

plot(times, safeprob_stat, LineWidth=2, Color=[0, 0, 0.9])
plot(times, safeprob_FK, LineStyle='--', LineWidth=2, Color=[0.8, 0, 0])
lgd = legend('$\ \pi_1$','$\ \pi_2$','$\ \pi_3$','$\ \pi_4$','$\ \pi_5$','$\ \pi_6$','$\ \pi_7$','$\ \pi\ (\mathrm{Ground\ truth})$','$\ \prod_{k=1}^7\pi_k\ (\mathrm{Proposed})$',Interpreter='latex', FontSize=12, Location='southwest');
legend('boxoff')
lgd.LineWidth = 1;
lgd.NumColumns = 2;
lgd.EdgeColor = 'k';
pbaspect([1,1,1])

ax = gca;
ax.LineWidth = 1.0;
ax.XAxis.FontSize = 18;
ax.YAxis.FontSize = 18;
xlabel('Time Horizon $T$','Interpreter','latex');
ylabel('Safety Probability $\pi,\pi_k$','Interpreter','latex');
xlim([0,10])
ylim([0, 1.02])

if ~exist('Results', 'dir')
    mkdir('Results');
end

filename = fullfile('Results', 'Compare_MCwithFK.svg');
print(gcf, filename, '-dsvg');