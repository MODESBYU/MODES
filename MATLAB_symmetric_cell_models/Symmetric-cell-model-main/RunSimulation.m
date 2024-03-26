%% Run Simulation
% To use this script
%   * Modify the cell properties in `inputs.m`
%   * If plotting, select the FLAGS for the properties to display
%   * Run this file
clear all; close all; clc


%% Change to this script's working directory
[filepath,~,~] = fileparts(mfilename('fullpath'));
cd(filepath)


%% Save Filename
save_filename = 'test.mat';

[current_file_path,~,~] = fileparts(mfilename('fullpath'));
addpath(genpath(current_file_path)); % Adds subdirectories

save_file_path = [current_file_path filesep 'Results'];

if isfile([save_file_path filesep save_filename])
    disp('Deleting existing simulation.')
end

SIM.filenameAndPath = [save_file_path filesep save_filename];


%% Call Inputs and Initialization
[EL,GEO,SIM,N,FLAG] = inputs(SIM);
[EL,GEO,SIM,CONS,P,N,FLAG,PROPS] = initialization(EL,GEO,SIM,N,FLAG);

% Save Simulation File
postProcessComplete = 0;
save(SIM.filenameAndPath,'EL','SIM','GEO','CONS','P','N','FLAG','PROPS','postProcessComplete')


%% Run Simulation

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Constant Current %%%%%%%%%%%%%%%%%%%%%%%%%%%%
tspan = linspace(0,SIM.t_final,30);   % [0 , SIM.t_final]; % Simulation vector
Tol.Abs = 1E-10; % Absolute tolerance
Tol.Rel = 1E-3;  % Relative tolerance

options = odeset('RelTol',Tol.Rel, ...
                 'AbsTol',Tol.Abs, ...
                 'Mass',SIM.Mass,  ...
                 'MassSingular','no');

[t_soln,SV_soln] = ode15s(@(t,SV)govnEqn(t,SV,EL,SIM,GEO,CONS,P,N,FLAG,PROPS),tspan,SIM.SV_IC,options);

% Save File
postProcessComplete = 0;
save([save_file_path filesep save_filename],'t_soln','SV_soln','EL','GEO','SIM','CONS','P','N','FLAG','PROPS','postProcessComplete')


%% Perform Post-Processing
if FLAG.doPostProcessing
    disp('Performing Post-Processing')
    postProcessing(SIM.filenameAndPath);
end


%% Plot Results
if FLAG.Plot
    plotResults(SIM.filenameAndPath)
end

