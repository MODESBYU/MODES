%% DAE function
function [dSVdt] = govnEqn(t,SV,EL,SIM,GEO,CONS,P,N,FLAG,PROPS)
% Initialize
dSVdt = zeros(N.N_SV_tot , 1);
SV = SV1Dto2D(SV , N , P , FLAG); % Written to be general if more SV are used

% Evaluate Parameters
if FLAG.VARIABLE_PROPS_FROM_HANDLES
    props = getProps(SV , EL , SIM , GEO , CONS , P , N , FLAG , PROPS);
else
    props = PROPS;
end


% Perform Calculations
% Calculate Species Flux
[J_Liion] = MassFluxCalcs(SV,EL,SIM,GEO,CONS,P,N,props);

% Species production
s_dot      = zeros(1 , N.N_CV_tot);
s_dot(1)   =  SIM.s_dot;
s_dot(end) = -SIM.s_dot;

% Differential
for i = 1:N.N_points
    offset = (i-1)*N.N_SV;
    % Concentration
    dSVdt(offset + P.C_Liion) = -(J_Liion(i+1) - J_Liion(i))/GEO.del_x + GEO.A_s*s_dot(i);
end

%% Trouble shooting
if t > 0
    %    t
end
end