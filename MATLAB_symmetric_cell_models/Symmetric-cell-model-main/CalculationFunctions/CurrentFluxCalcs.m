%% Current Flux Calculation
% Does not account for a double layer current
function [i_el] = CurrentFluxCalcs(phi,SV,EL,SIM,GEO,CONS,P,N,props)
%% Initialize
i_el    = zeros(1 , N.N_CV_tot + 1 );

%% Internal Regions
for i = 2:N.N_CV_tot
    kappa    = (props( P.kappa    , i-1 ) + props( P.kappa    , i ))/2;
    tf       = (props( P.tf_num   , i-1 ) + props( P.tf_num   , i ))/2;
    activity = (props( P.activity , i-1 ) + props( P.activity , i ))/2;

    i_el(i) = -  kappa*(phi(i)- phi(i-1))/GEO.del_x ...
              -2*kappa*(CONS.R*SIM.Temp/CONS.F)*(1 + activity)*...
              (tf-1)*(log(SV(P.C_Liion,i))-log(SV(P.C_Liion,i)))/GEO.del_x;
end

%% BC
i_el(1)   = SIM.i_user;
i_el(end) = SIM.i_user;

end