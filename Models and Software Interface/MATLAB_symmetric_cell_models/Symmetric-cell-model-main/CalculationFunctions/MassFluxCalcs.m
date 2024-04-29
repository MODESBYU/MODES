%% Mass Flux Calculations
function [J_Liion] = MassFluxCalcs(SV,EL,SIM,GEO,CONS,P,N,props)
%% Initialize
J_Liion = zeros(1 , N.N_CV_tot + 1 );

%% Internal Regions
for i = 2:N.N_CV_tot
    % Uses i_user since i_el = i_user (don't need to calculate phi to obtain i_el)
    D_o_Li_ion = (props( P.D_o_Li_ion , i ) + props( P.D_o_Li_ion , i-1 ))/2;
    tf         = (props( P.tf_num     , i ) + props( P.tf_num     , i-1 ))/2;
    
    J_Liion(i) = - GEO.eps_el * D_o_Li_ion * ( SV(P.C_Liion,i) - SV(P.C_Liion,i-1) ) / GEO.del_x...
                 + SIM.i_user * tf / CONS.F;
end
end