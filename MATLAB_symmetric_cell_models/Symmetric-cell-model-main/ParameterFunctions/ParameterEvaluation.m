%% Evaluating Parameter Functions
clear all; close all; clc
%%
plot_test_fig = 1;
numHalfPoints = 25;

Ce = [linspace(0,1.2,numHalfPoints),linspace(1.2+(1.2/(numHalfPoints-1)),2,numHalfPoints)];
% Ce = linspace(-0.5,0.5,25);
% Ce = zeros(1,25);
T  = 298 * ones(1,numHalfPoints*2);

D_o_Liion = D_oLiion(Ce , T);
t         = transferenceNumber(Ce, T);
dfdc      = activity(Ce, T);
kappa_vec = kappa(Ce , T);


disp('The following are the parameter value at 1.2 kmol m^-3')
disp(['D_o_Liion = ' num2str(D_o_Liion(numHalfPoints))])
disp(['tf =        ' num2str(t(        numHalfPoints))])
disp(['activity =  ' num2str(dfdc(     numHalfPoints))])
disp(['kappa =     ' num2str(kappa_vec(numHalfPoints))])


if plot_test_fig
    % D_o_Liion
    figure
    plot(Ce,D_o_Liion,'-*','MarkerFaceColor','red','MarkerEdgeColor','red','MarkerIndices',numHalfPoints,'Linewidth',2)
    title('D_{o,Li^+}')

    % Transference Number
    figure
    plot(Ce,t,'-*','MarkerFaceColor','red','MarkerEdgeColor','red','MarkerIndices',numHalfPoints,'Linewidth',2)
    title('tf')

    % Activity
    figure
    plot(Ce,dfdc,'-*','MarkerFaceColor','red','MarkerEdgeColor','red','MarkerIndices',numHalfPoints,'Linewidth',2)
    title('Activity')

    % Conductivity
    figure
    plot(Ce,kappa_vec,'-*','MarkerFaceColor','red','MarkerEdgeColor','red','MarkerIndices',numHalfPoints,'Linewidth',2)
    title('\kappa')
end