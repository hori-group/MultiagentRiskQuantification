clear
close all
clc


%% Model parameters of each agent
beta_1 = 1;
beta_2 = 1;
A = [0, 1; -beta_1, -beta_2];
B = [0; 1];
C = [1, 0];
N = 7;
n = 2;
L = [5, -1, -1, -1, -1, -1, 0;
    -1, 3, 0, -1, 0, 0, -1;
    -1, 0, 2, 0, -1, 0, 0;
    -1, -1, 0, 4, -1, -1, 0;
    -1, 0, -1, -1, 4, -1, 0;
    -1, 0, 0, -1, -1, 3, 0;
    0, -1, 0, 0, 0, 0, 1];

A_Sigma = kron(eye(N),A) - kron(L,B*C);


%% Simulation settings
terminal_time = 10;
time_num = 10000;
path_num = 10000;
dt = terminal_time / time_num;
time = linspace(0, terminal_time, time_num + 1);
X = zeros(n*N, time_num+1);

% Setting the initial state vector
initial_state_1 = transpose([0.3, 0.6, -0.6, 0.1, 0.3, -0.6, 0]);
initial_state_2 = transpose([-0.4, 0.6, -0.4, 0.6, 0.3, 0.1, -0.6]);
initial_state = kron(initial_state_1, [1;0]) + kron(initial_state_2, [0;1]);

for i = 1:path_num
    X(:,1,i) = initial_state;
end

sigma = 0.2;        % NOTE: SD of the white Gaussian noise

for j = 1:path_num
    for i = 1:time_num
        w = sigma * randn(n*N,1);
        X(:,i+1,j) = (eye(n*N) + A_Sigma*dt)*X(:,i,j) + sqrt(dt)*w;
    end
end


%% Save the data
if ~exist('MCdata', 'dir')
    mkdir('MCdata');
end

filename = fullfile('MCdata', 'StateTrajectories_MCdata.mat');
save(filename, '-v7.3');