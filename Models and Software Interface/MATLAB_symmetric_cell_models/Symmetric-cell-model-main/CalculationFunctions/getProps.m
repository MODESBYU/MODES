%% Properties Evaluation function
% This function evaluates all parameters based on concentration 
function [props] = getProps(SV , EL , SIM , GEO , CONS , P , N , FLAG , PROPS)
%% Initialize
props = zeros(N.N_prop , N.N_CV_tot ); 
Ce = SV( P.C_Liion , :);
T  = SIM.Temp*ones(size(Ce)); %%%!!!! hardcoded

% D_o_Liion
    if FLAG.VARIABLE_D_o_Liion
        props(P.D_o_Li_ion , : ) = EL.D_o_Li_ionHandle(Ce , T);
    else
        props(P.D_o_Li_ion , : ) = PROPS( P.D_o_Li_ion , :);
    end
% Transference Number
    if FLAG.VARIABLE_tf_num
        props(P.tf_num     , : ) = EL.tf_numHandle(Ce , T);
    else
        props(P.tf_num , : )     = PROPS( P.tf_num , :);
    end

% Activity
    if FLAG.VARIABLE_activity
        props(P.activity   , : ) = EL.activityHandle(Ce , T);
    else
        props(P.activity , : )   = PROPS( P.activity , :);
    end

% kappa
    if FLAG.VARIABLE_kappa
        props(P.kappa , : )  = EL.kappaHandle(Ce , T);
    else
        props(P.kappa , : )  = PROPS( P.kappa , :);
    end

% Account for tortuosity (Bruggeman)
    if FLAG.Bruggeman
        props = props .* CONS.BRUG;
    end

end