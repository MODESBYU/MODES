%% Generalized path setup
% find working path
[filepath,~,~] = fileparts(mfilename('fullpath'));
cd(filepath)

% find parent path
parentDir = fileparts(filepath);

%% load the necessary files

addpath(genpath(parentDir))

parentPathCalc = [parentDir filesep 'CalculationFunctions'];
addpath(genpath(parentPathCalc))

parentPathParams = [parentDir filesep 'ParameterFunctions'];
addpath(genpath(parentPathParams))


%% pull in the data to be matched
% change this to match the path of the data of interest
file_to_load = [parentDir filesep 'Results' filesep 'test.mat'];
load(file_to_load);

%% Test the adjusted data 
ex = GEO.x_vec;
tee = t_soln;

[X,T] = meshgrid(ex,tee);

figure
mesh(X * 1000,T / 60,adjusted_data)
xlabel 'x (mm)'
ylabel 'time (min)'
zlabel 'concentration (M)'
colorbar
colormap autumn
shading interp

figure
meshc(X * 1000,T / 60,C_Liion)
xlabel 'x (mm)'
ylabel 'time (min)'
zlabel 'concentration (M)'
colorbar
colormap autumn
shading interp

%% Export messed up data

% Append the new variable to the existing data structure
existing_data.adjusted_data = adjusted_data;

% Save the combined data structure back to the file
save(file_to_load, '-struct', 'existing_data', '-append');
%% function to adjust the data
function adjusted_data = adjustData(original_data)

    % Get the size of the original data array
    [rows, cols] = size(original_data);
    
    % Generate random adjustment factors for each element
    adjustment_factors = rand(rows, cols) * 0.01 - 0.005; % Random number between -0.005 and 0.005
    
    % Apply adjustments to the original data
    adjusted_data = original_data .* (1 + adjustment_factors);
    
    % % Shuffle the adjusted data to randomize it
    % adjusted_data = adjusted_data(randperm(rows), :);
end