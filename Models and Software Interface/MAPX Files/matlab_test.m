% % Open the .mapx file for reading
% fileID = fopen('test.mapx', 'r');
% 
% % Define the format of the data (e.g., '%f' for floating-point numbers)
% formatSpec = '%f';
% 
% % Read the data into a column vector
% A = fscanf(fileID, formatSpec);
% 
% % Close the file
% fclose(fileID);
% 
% display(A)
% 
% 

%% Clear the directory
clear; close all; clc;

%% Generalized path setup
[filepath,~,~] = fileparts(mfilename('fullpath'));
cd(filepath)


% Save Filename
save_filename = 'test.mat';

[current_file_path,~,~] = fileparts(mfilename('fullpath'));
addpath(genpath(current_file_path)); % Adds subdirectories

save_file_path = [current_file_path filesep 'Results'];

%% ChatGPT 的贡献
% Get the path of the current file
currentFilePath = mfilename('fullpath');

% Extract the directory part of the current file path
[currentDir, ~, ~] = fileparts(currentFilePath);

% Get the parent directory by going one level up
parentDir = fileparts(currentDir);
grandparentDir = fileparts(parentDir);

% Now you have the path to the parent directory
disp(['Parent directory path: ' parentDir]);

