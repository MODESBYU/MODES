%% Phi fsolve fun
function [res] = phiSolveFnc(phi,SV,EL,SIM,GEO,CONS,P,N,FLAG,PROPS)
%% Initialize
res = zeros(1,N.N_CV_tot);

%% Parameters
if FLAG.VARIABLE_PROPS_FROM_HANDLES
[props] = getProps(SV , EL , SIM , GEO , CONS , P , N , FLAG , PROPS);
else
    props = PROPS;
end
[i_el] = CurrentFluxCalcs(phi,SV,EL,SIM,GEO,CONS,P,N,props);

%Solving for Residuals
for i = 1:N.N_points
    if i == 1
        res(i) = 0 - phi(1);
    else
%         res(i) = -(i_el(i+1) - i_el(i))/ GEO.del_x;
        res(i) = i_el(i+1) - i_el(i);
    end
end
end