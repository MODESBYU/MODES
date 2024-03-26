function [EL,GEO,SIM,CONS,P,N,FLAG,PROPS] = initialization(EL,GEO,SIM,N,FLAG)
%% Constants
CONS.F = 96485338.3; % [C kmol^-1], Faraday's Constant
CONS.R = 8314.472;   % [J kmol^-1 K^-1], Gas Constant


%% Pointers
% SV
i = 1;
P.C_Liion = i; i = i+1; % Lithium-ion concentration

N.N_SV = P.C_Liion;     % Number of state variables

% Parameters
i = 1;
P.D_o_Li_ion = i; i = i+1; % Diffusion
P.tf_num     = i; i = i+1; % Transference Number
P.activity   = i; i = i+1; % Activity (Thermo)
P.kappa      = i; i = i+1; % Conductivity

N.N_prop = P.kappa; % Number of parameters


%% Regional Indexing
N.N_SV_tot = N.N_SV * N.N_points; % Total number of state variables
N.N_CV_tot = N.N_points;          % Total number of control volumes


%% Numerical Discretization
GEO.del_x = GEO.L/(N.N_points - 1); % [m], Distance between discretized points
GEO.x_vec = 0:GEO.del_x:GEO.L;      % [m], Position of each point (Half cells at boundaries)


%% Initializing Properties
    PROPS = zeros( N.N_prop , N.N_CV_tot ); % Matrix that hold all property values
    
    PROPS( P.D_o_Li_ion , : ) = EL.D_o_Li_ion * ones( 1 , N.N_CV_tot );
    PROPS( P.tf_num     , : ) = EL.tf_num     * ones( 1 , N.N_CV_tot );
    PROPS( P.activity   , : ) = EL.activity   * ones( 1 , N.N_CV_tot );
    PROPS( P.kappa      , : ) = EL.kappa      * ones( 1 , N.N_CV_tot );
    

%% Initialize Bruggeman
    if FLAG.Bruggeman
        % Initialize
        CONS.BRUG = ones(size(PROPS));
        
        % Calculate Brug for each region/phase
            tau_fac_SEP_EL = GEO.gamma_brug * GEO.eps_el ^ (1 - GEO.alpha_brug);
            
            tau_fac_EL = tau_fac_SEP_EL*ones(1,N.N_SV_tot);
            eps_EL     = GEO.eps_el    *ones(1,N.N_SV_tot);
            brug_EL    = eps_EL ./ tau_fac_EL;
        
        % Fill Brug Matrix based on FLAG
        if FLAG.BRUG_D_o_Liion
            CONS.BRUG(P.D_o_Li_ion , :) = brug_EL;
        end
        if FLAG.BRUG_tf_num
            CONS.BRUG(P.tf_num , :)     = brug_EL;
        end
        if FLAG.BRUG_activity
            CONS.BRUG(P.activity , :)   = brug_EL;
        end
        if FLAG.BRUG_kappa
            CONS.BRUG(P.kappa , :)      = brug_EL;
        end
        
        % Apply Brug to PROPS
        PROPS = PROPS .* CONS.BRUG;
    end


%% Geometry Calcs
GEO.Vol       = GEO.A_c * GEO.L;     % [m^3] Total electrolyte volume
GEO.dVol      = GEO.A_c * GEO.del_x; % [m^3] Control volume, volume
GEO.dVol_half = GEO.dVol/2;          % [m^3] Half control volume, volume
GEO.A_s       = GEO.A_c/GEO.dVol;    % [m_surf^2 / m_CV^3 --> 1/m ] Amount of reaction surface area per control volume

GEO.dVol_vec      = [GEO.dVol_half , GEO.dVol*ones(1,N.N_CV_tot-2) , GEO.dVol_half];
GEO.dVol_vec_norm = GEO.dVol_vec/GEO.dVol; % Used in mass matrix


%% Load Current
% ---- Constant Current ----
if SIM.SimMode == 1
    SIM.i_user = SIM.I_user/GEO.A_c; % [A m^-2], Load current density (flux)
end

%% Species Production
%!!!!!!!!!!!!!!! Might have to change this to be calculated internal to
%governing equations if doing harmonic load current
SIM.s_dot = SIM.i_user / CONS.F ;  % [kmol_Li^+ m_surf^-2 s^-1], Species production/consumption rate at electrode surface


%% Determine Initial State Vector
SV_IC = zeros(N.N_SV_tot,1);
for i = 1:N.N_CV_tot
    index_offset = (i-1)*N.N_SV; 
    % Temp
    %SV_IC(index_offset + P.T)       =  SIM.Temp_start;
    
    % C_Li^+
    SV_IC(index_offset + P.C_Liion) =  EL.C_ini; 
end

SIM.SV_IC = SV_IC;


%% Solve for better PROP values
if ( FLAG.CONSTANT_PROPS_FROM_HANDLES || FLAG.VARIABLE_PROPS_FROM_HANDLES)
    SV    = SV1Dto2D(SV_IC , N , P , FLAG);
    props = getProps(SV , EL , SIM , GEO , CONS , P , N , FLAG , PROPS);
    if FLAG.CONSTANT_PROPS_FROM_HANDLES
        % Update PROPS to use initial conditions
        PROPS = props;
    end
else
   props = PROPS; %!!!! Did this because I was using props to do an fsolve on phi variables... wonder if I need it at all?
end


%% Mass Matrix
Mass = zeros(N.N_SV_tot);
for i = 1:N.N_points
    offset = (i-1)*N.N_SV;
%     if i == 1
%         Mass(offset + P.C_Liion , offset + P.C_Liion) = 0.5; % Accounts for half cell, porosity is also 1
%     elseif i == N.N_points
%         Mass(offset + P.C_Liion , offset + P.C_Liion) = 0.5; % Accounts for half cell, porosity is also 1
%     else
%         Mass(offset + P.C_Liion , offset + P.C_Liion) = 1;   % Porosity is 1
%     end
    %     Mass(offset + P.phi_el , offset + P.phi_el)  = 0;

    Mass(offset + P.C_Liion , offset + P.C_Liion) = GEO.dVol_vec_norm(i)*GEO.eps_el;
end
SIM.Mass = Mass;

end