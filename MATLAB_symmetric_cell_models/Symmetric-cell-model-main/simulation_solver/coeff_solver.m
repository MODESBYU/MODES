clear; close all; clc;

%% Generalized path setup

% find working path
[filepath,~,~] = fileparts(mfilename('fullpath'));
cd(filepath)

% find parent path
parentDir = fileparts(filepath);

%% load the necessary paths

addpath(genpath(parentDir))

parentPathCalc = [parentDir filesep 'CalculationFunctions'];
addpath(genpath(parentPathCalc))

parentPathParams = [parentDir filesep 'ParameterFunctions'];
addpath(genpath(parentPathParams))


%% load the data to be matched
% change this to match the path of the data of interest
file_to_load = [parentDir filesep 'Results' filesep 'test.mat'];
load(file_to_load);

%% Set up the values to be used by the solver
% initialize the guess values/starting values
%    [Do,t+];
x0 = [.5,.8];

% initialize the boundaries for each of the functions
% found with functions to calculate t+ and D_o at molarities of 0M and 3M
lb = [.71518,0.4420];
ub = [33.879,0.4991];

%% separate function to bring in the concentration data
%msqe_data = @(x) msqe(x, C_Liion);

%% Solver, output
% call fmincon to minimize the function, with constraints
[xstar,fstar] = fmincon(@(x) msqe(x, C_Liion),x0,[],[],[],[],lb,ub);

fprintf('D_o: %f, t+: %d\n', xstar(1), xstar(2));

%% Path for saving the graphs
saveGraph_loc = [filepath filesep 'Results'];

%% Try plotting the two graphs, see if that will work

% plot the solved data
[Cstar,~,~] = RunSim_solver(xstar,1);

% save the plot
fit_data = [filepath filesep 'Results' filesep 'fit_data.jpg'];
saveas(gcf,fit_data)

%% Plot the original data
% Time Vector
N_times = 5; % Number of times to plot
% Make Desired Times for Plotting
time_des = linspace(0, t_soln(end), N_times);
for i = 1:length(time_des)
    [~,t_index(i)] = min(abs(time_des(i)-t_soln));
end

figure
%hold off
hold on

for i = 1:N_times
    %plot(GEO.x_vec*1000,C_Liion(t_index(i),:),'-o','LineWidth',2,'DisplayName',['t = ' , num2str(t_soln(t_index(i))) , 's'])
    plot(GEO.x_vec*1000,adjusted_data(t_index(i),:),'LineWidth',3,'DisplayName',['t = ' , num2str(t_soln(t_index(i)),4) , 's'])
        lgn = legend;
        lgn.Location = 'southwest';
        lgn.Box = 'off';
        lgn.FontSize = 30;
        title('Electrolyte [Li^+]')
        xlabel('x position (mm)')
        ylabel('[Li^+] (kmol m^{-3})')
        set(gca,"FontSize",30)
        ylim([1 1.45])
        %0.05);
    % exportgraphics(gcf,'testAnimated.gif','Append',true);
end

% plot the data
real_data = [filepath filesep 'Results' filesep 'real_data.jpg'];
saveas(gcf,real_data)

%% Plot a heatmap showing error

hold off;

figure;

% calculate error
difference = (adjusted_data - Cstar);

% Define custom colormap
custom_colors = [
    0 0 1   % Blue
    1 1 1   % White
    1 0 0   % Red
];

% calculate max, min, and mean values in the array
small = difference(1,1);
big = difference(1,1);
num = 0;
sum = 0;
for i = 1:size(difference, 1)
    for j = 1:size(difference, 2)
        % check if max
        if difference(i,j) < small
            small = difference(i,j);
        end
        % check if min
        if difference(i,j) > big
            big = difference(i,j);
        end
        % increment for mean
        num = num + 1;
        sum = sum + difference(i,j);
    end
end

mean_val = sum / num;

% Specify the positions for the colors in the colormap
color_positions = [small; mean_val; big];

% Normalize the color positions to [0, 1]
normalized_positions = (color_positions - small) / (big - small);

% Create the colormap
custom_colormap = interp1(normalized_positions, custom_colors, linspace(0,1,256));

% Apply the custom colormap to the heatmap
colormap(custom_colormap);

heatmap(GEO.x_vec * 1000, t_soln / 60, difference, 'Colormap', custom_colormap);
title('Heatmap of Errors between Experimental and Model Data');
xlabel('Position (mm)');
ylabel('Time (min)');

% plot the data
heat_map = [filepath filesep 'Results' filesep 'heat_map.jpg'];
saveas(gcf,heat_map)

%% 3D plots: concentration, error
ex = GEO.x_vec;
tee = t_soln;

disp(ex)
disp(tee)

[X,T] = meshgrid(ex,tee);

% plot the real data
figure
surfc(X * 1000,T / 60,adjusted_data)
title 'real data'
xlabel 'x (mm)'
ylabel 'time (min)'
zlabel 'concentration (M)'
colorbar
shading interp

% save plot
real_3d = [filepath filesep 'Results' filesep 'real_3d.jpg'];
saveas(gcf,real_3d)

% plot the fit data
figure
surfc(X * 1000,T / 60,Cstar)
title 'modeled data'
xlabel 'x (mm)'
ylabel 'time (min)'
zlabel 'concentration (M)'
colorbar
shading interp

% save plot
modeled_3d = [filepath filesep 'Results' filesep 'modeled_3d.jpg'];
saveas(gcf,modeled_3d)

% plot the error between the two
figure
surfc(X * 1000,T / 60,difference)
title 'difference in concentration between model and data'
xlabel 'x (mm)'
ylabel 'time (min)'
zlabel 'difference in concentration (M)'
colorbar
colormap autumn
shading interp

% save plot
error_3d = [filepath filesep 'Results' filesep 'error_3d.jpg'];
saveas(gcf,error_3d)


%% future goals
% 
% produce a plot of the two concentration gradients: done! 3/4/2024 20:37
%       the plots work! They don't match, so I guess that's the next
%       project...
% 
% get it to work: done! 3/4/2024 7:59;
%       not entirely sure how well it works, but it ran, and it didn't give
%       me an error message
% 
% get the concentration graphs to match: done! 3/5/2024 21:02
%       It does pretty good at matching the data! I changed the original
%       data transference number and diffusion coefficient, and changed the
%       original guess values, and it seemed to work well either way
%           the only thing I had to change was to get a new data set using
%           constant coefficients. The original test file I was using had
%           used changing coefficients, so it wasn't able to match a
%           constant coefficient fit to that... maybe something to look at
%           again later?
% 
% find out expected range of both tranference number and diffusion coeff.
% 
% test the solver over whole range of expected values
%
% test the solver using a data set that isn't from the original model
%
% find some way to factor in the changing values?
%       potential problem with that, the functions for determining the
%       constants (f(C_Li)) don't take in an initial transference number,
%       so altering the coefficients in the input functions doesn't
%       actually do anything; you would theoretically get the exact same
%       things out from the solver every time, so nothing would change...
%
% subplot that shows the error between changing coefficients and the solver
%       Gaussian error function (mess up the 'perfect' data): done! 
