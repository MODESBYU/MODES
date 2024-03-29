function t = transferenceNumber(Ce, T)
% C_e is the concentration of Li^+ in the electrolyte in kmol /m^3
% Also depends on temperature but for now I'll keep that constant
% T = 303.15; %[K]
%%%%%%%%%%% OLD
% A = -0.0000002876102 * T.^2 + 0.0002077407 * T - 0.03881203;
% B =  0.0000011614630 * T.^2 - 0.0008682500 * T + 0.17772660;
% C = -0.0000006766258 * T.^2 + 0.0006389189 * T + 0.30917610;
% 
% t = A .* Ce.^2 + B .* Ce + C;

%%%%%%%%%%% 
t = -9.076E-4*Ce.^2 ...
    +0.017910*Ce ...
    + 0.44196;

end