clear
close all
clc

%% Parameter settings
N = 7;                  % NOTE: Index of the eigenvector
x = zeros(N,1);
y = zeros(N,1);

for i = 1:N
    x(i) = cos(2*(i-1)*pi/7);
    y(i) = sin(2*(i-1)*pi/7);
end


% Given graph Laplacian
L = [5, -1, -1, -1, -1, -1, 0;
    -1, 3, 0, -1, 0, 0, -1;
    -1, 0, 2, 0, -1, 0, 0;
    -1, -1, 0, 4, -1, -1, 0;
    -1, 0, -1, -1, 4, -1, 0;
    -1, 0, 0, -1, -1, 3, 0;
    0, -1, 0, 0, 0, 0, 1];

[T, Lambda] = eig(L);


%% Visualization
figure
hold on
box on

% Generate the graph (nodes and edges) corresponding to the graph Laplacian
scatter(x, y, 20, 'k', 'filled');
for i = 1:N
    for j = i+1:N
        if L(i, j) == -1
            plot([x(i), x(j)], [y(i), y(j)], 'Color', [0.8, 0.8, 0.8], 'LineWidth', 4.0);
        end
    end
end

% Plot the graph Fourier basis (eigenvector values on vertices)
v_num = 7;
z = T(:, v_num);
scatter(x, y, 2500, z, 'filled');
colormap(slanCM('vik'));

c = colorbar;
c.Location = "westoutside";
c.FontSize = 20;
clim([-1, 1]);

pbaspect([1, 1, 1])
xlim([-1, 1])
ylim([-1, 1])
set(gcf, 'Color', 'white');
axis off


%% Save the data
if ~exist('Graph_Fourier_Transform', 'dir')
    mkdir('Graph_Fourier_Transform');
end

filename = fullfile('Graph_Fourier_Transform', sprintf('Graph_Fourier_Basis_%d.svg', v_num));
print(gcf, filename, '-dsvg');
