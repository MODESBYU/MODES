function postProcessing(filename)
%% Load file to workspace
load(filename,'postProcessComplete')


%% do post-processing if it hasn't already
if ~postProcessComplete
    load(filename)
    
    %% Make Desired Times Vector
    N_t_steps = length(t_soln);
    idx = 1:1:N_t_steps;

    %% Initialize Variables
    SV            = zeros(N.N_SV , N.N_CV_tot, N_t_steps );
    C_Liion       = zeros( N_t_steps , N.N_CV_tot );
    total_mass    = zeros( N_t_steps , 1 );
    phi_el        = zeros( N_t_steps , N.N_CV_tot );
    D_o_Liion_vec = zeros( N_t_steps , N.N_CV_tot);
    tf_vec        = zeros( N_t_steps , N.N_CV_tot);
    activity_vec  = zeros( N_t_steps , N.N_CV_tot);
    kappa_vec     = zeros( N_t_steps , N.N_CV_tot);

    %% Perform Calcs
    for i = 1:N_t_steps
        % Go through the solution vector and reshape every SV to 2D (3D matrix)
        SV( : , : , i ) = SV1Dto2D( SV_soln( idx(i) , : ) , N , P , FLAG );
        C_Liion( i , : ) = SV( P.C_Liion, : , i );
        if FLAG.VARIABLE_PROPS_FROM_HANDLES
            props = getProps(SV( : , : , i ) , EL , SIM , GEO , CONS , P , N , FLAG , PROPS);
        else
            props = PROPS;
        end
        D_o_Liion_vec( i , : ) = props( P.D_o_Li_ion , : );
        tf_vec( i , : )        = props( P.tf_num     , : );
        activity_vec( i , : )  = props( P.activity   , : );
        kappa_vec( i , : )     = props( P.kappa      , : );
    end

    % Solve for the voltage profile
    del_phi  = (GEO.del_x / EL.kappa) * SIM.i_user; % [V], Change in voltage for a given i_user
    % for i = 1:N.N_points
    %     phi_guess(i) = 0 - (i-1)*del_phi;
    % end
    phi_guess = zeros(1,N.N_CV_tot);

    for i = 1:length(t_soln)
        SV = SV1Dto2D(SV_soln(i,:) , N , P , FLAG);
        phi_el(i,:) = fsolve(@(phi)phiSolveFnc(phi,SV,EL,SIM,GEO,CONS,P,N,FLAG,PROPS),phi_guess,SIM.fsolve_options)'; % [V], Voltage vector at each time step
    end

    % Cell Voltage
    cell_voltage = phi_el(:,end);

    % Conservation of Mass
    initial_mass = sum(EL.C_ini*GEO.dVol_vec);
    for i = 1:N_t_steps
        total_mass(i,1) = sum( C_Liion( i , : ).*GEO.dVol_vec);
    end
    mass_error = total_mass(:) - initial_mass;

    
    %% Set the variable for finished post-processing
    postProcessComplete = 1;


    %% Resave data to the .mat file
    clearvars i
    save(filename);
end
end