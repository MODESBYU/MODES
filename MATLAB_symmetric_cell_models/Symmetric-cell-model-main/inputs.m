%% 1D Symmetric Cell
% This script is used to evaluate Li^+ concentration for a Li/Li symmetric cell
%
% Date:     February 6, 2022
% Author:   Tyler Evans
% Modified: November 17, 2022
%
%% Units used in this model
% * Mass       : kilogram (kg)
% * Moles      : kilomole (kmol)
% * Time       : seconds  (s)
% * Temperature: Kelvin   (K)
% * Length     : meter    (m)
% * Energy     : Joule    (J)
% * Power      : Watt     (W)
% * Current    : Amp      (A)
% * Resistance : Ohms     (Omega)
%             or Siemens  (S)
%
%% Simulation Modes
% 1) Constant Current

function [EL,GEO,SIM,N,FLAG] = inputs(SIM)
%% FLAGS
FLAG.COE    = 0; % Cons of Energy (Temperature). 0 if dTdt = 0 ######NOT IMPLEMENTED YET

FLAG.Bruggeman = 0; % 1 if properties are adjusted for tortuosity
    % Specific Parameters to have BRUG applied to
    FLAG.BRUG_D_o_Liion = 1;
    FLAG.BRUG_tf_num    = 1;
    FLAG.BRUG_activity  = 0;
    FLAG.BRUG_kappa     = 0;

FLAG.Newman_i_o = 1; % 1 if using  i_o = k_o*F*(C_Li)^alpha_c * (C_max - C_Li)^alpha_a * (C_Liion)^alpha_a; 0 if using a function handle

FLAG.CONSTANT_PROPS_FROM_HANDLES = 0; % Uses the initial conditions to solve for the properties and uses those throughout the simulation
FLAG.VARIABLE_PROPS_FROM_HANDLES = 1;
    FLAG.VARIABLE_D_o_Liion = 1;
    FLAG.VARIABLE_tf_num    = 1;
    FLAG.VARIABLE_activity  = 1;
    FLAG.VARIABLE_kappa     = 1;
    
%%%% If CONSTANT_PROPS_FROM_HANDLES or VARIABLE_PROPS_FROM_HANDLES are 1
%%%% but none of the individual properties are a 1, then all properties are
%%%% equal to the defaults set below.
if ( FLAG.CONSTANT_PROPS_FROM_HANDLES && FLAG.VARIABLE_PROPS_FROM_HANDLES)
    warning('Both FLAG.CONSTANT_PROPS_FROM_HANDLES and FLAG.VARIABLE_PROPS_FROM_HANDLES are 1.')
end

FLAG.doPostProcessing = 1;   % 1 if the postprocessing function is performed after a simulation completes
    FLAG.ReduceSolnTime = 0; % 1 if the results that are saved don't use all the points produced by t_soln ######NOT IMPLEMENTED YET
FLAG.Plot             = 1;   % 1 if the results plot immediately



%% Numerical Parameters
N.N_points  = 25;         % Number of discretized points


%% fsolve Options
optionsf = optimoptions('fsolve');
optionsf.FunctionTolerance = 1e-15;
optionsf.MaxFunctionEvaluations = 5e3;
% optionsf.MaxIterations = 4.000000e10;
optionsf.Display = 'off'; %'none'

SIM.fsolve_options = optionsf;

%% Battery Chemistry
EL.C_ini    = 1; % [kmol m^-3], Initial Li^+ concentration

% Elyte Properties/Function Handles
EL.D_o_Li_ionHandle = @D_oLiion;
EL.tf_numHandle     = @transferenceNumber;
EL.activityHandle   = @activity;
EL.kappaHandle      = @kappa;

% Elyte Constant Properties
EL.D_o_Li_ion = 1.5e-11; % [m^2 s^-1], Li^+ liquid diffusion coefficient
EL.tf_num     = 0.45;   % [-], Transference Number
EL.activity   = 1;    % Placeholder value for activity. Activity of zero produces a constant voltage gradient
EL.kappa      = 0.28;    % [S m^-1], Ionic conductivity


%% Cell Geometry
GEO.L          = 800e-6;    % [m], Distance between electrodes
GEO.A_c        = 6e-8; % [m^2], Cross-sectional area
GEO.eps_el     = 1;       % [m_el^3 / m_CV^3], Porosity
GEO.gamma_brug = 1.0;     % [-], Bruggeman pre-exponential multiplier
GEO.alpha_brug = 1.5;     % [-], Bruggeman exponential factor


%% Simulation Parameters
SIM.Temp    = 298;  % [K], Temperature, assuming isothermal
SIM.I_user  = 1e-6; % [A], User defined load current,sym paper
% SIM.I_user  = 5e-1; % [A], User defined load current,test
% SIM.I_user  = 5e0; % [A], User defined load current,test

SIM.t_final = 1000;    % [s], Time for the end of simulation,sym paper
% SIM.t_final = 1e-3;    % [s], Time for the end of simulation,test do this when variable param
% SIM.t_final = 1e0;    % [s], Time for the end of simulation,test do this when variable param


%% Simulation Modes
% 1) Constant Current
SIM.SimMode = 1;


end