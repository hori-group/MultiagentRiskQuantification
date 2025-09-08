clear
close all
clc


%% Load the data
load("MCdata\StateTrajectories_MCdata.mat","L","X","N","n","path_num","time_num","terminal_time")


%% Define the barrier function (boundary of the safe set)
[T, Lambda] = eig(L);
barrier = @(v,x,gamma) gamma - norm(transpose(kron(v,eye(2)))*x, inf);

% Thresholds for the safe set
gamma = [2, 2, 1.5, 1.5, 1.5, 1, 1];
K = length(gamma);


%% Check if the state vector of multi-agents is contained in the safe set
count = zeros(time_num+1, path_num);
for j = 1:path_num
    for i = 1:time_num+1
        cond = true;
        for k = 1:K
            if barrier(T(:,k), X(:,i,j), gamma(k)) < 0
                cond = false;
                break;
            end
        end
        count(i,j) = cond;
    end
end

% NOT count once the state enters the unsafe set
for j = 1:path_num
    for i = 1:time_num
        if count(i,j) == 0
            count(i+1,j) = 0;
        end
    end
end

time = linspace(0, terminal_time, time_num+1);
safeprob_MC = sum(transpose(count))/path_num;


%% Save the data
filename = fullfile('Results', 'Plot_SafeProb_by_MCdata.svg');
print(gcf, filename, '-dsvg');

if ~exist('MCdata', 'dir')
    mkdir('MCdata');
end

filename = fullfile('MCdata', 'SafeProb_MCdata.mat');
save(filename, 'safeprob_MC');