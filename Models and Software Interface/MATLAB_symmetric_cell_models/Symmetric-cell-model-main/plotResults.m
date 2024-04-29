function plotResults(filename)
%% Load Results
load(filename)

%% Plot Flags
FLAG.PLOT.COM         = 0; % Conservation of Mass Check
FLAG.PLOT.C_Liion     = 1; % Mass/Species (Concentration Normalized): Li_ion
FLAG.PLOT.phi_el      = 0; % phi_el
FLAG.PLOT.cellVoltage = 0; % Terminal voltage of the battery vs time
FLAG.PLOT.D_o_Liion   = 0;
FLAG.PLOT.tf_num      = 0;
FLAG.PLOT.activity    = 0;
FLAG.PLOT.kappa       = 0;

%% Make Time Vector
    % Time Vector
    N_times = 5; % Number of times to plot
    % Make Desired Times for Plotting
    time_des = linspace(0, t_soln(end), N_times);
    for i = 1:length(time_des)
        [~,t_index(i)] = min(abs(time_des(i)-t_soln));
    end
%%
    % Conservation of Mass
    if FLAG.PLOT.COM
    figure
    plot(t_soln,mass_error,'LineWidth',2)
    title('Conservation of Mass Check')
    xlabel('Time (s)')
    ylabel('Error [kmol]')
    end
%%
    % Mass/Species (Concentration): Li_ion
    if FLAG.PLOT.C_Liion
    figure
    %hold off
    hold on

    for i = 1:N_times
        %plot(GEO.x_vec*1000,C_Liion(t_index(i),:),'-o','LineWidth',2,'DisplayName',['t = ' , num2str(t_soln(t_index(i))) , 's'])
        plot(GEO.x_vec*1000,C_Liion(t_index(i),:),'LineWidth',3,'DisplayName',['t = ' , num2str(t_soln(t_index(i)),4) , 's'])
            lgn = legend;
            lgn.Location = 'southwest';
            lgn.Box = 'off'
            lgn.FontSize = 30;
            title('Electrolyte [Li^+]')
            xlabel('x position (mm)')
            ylabel('[Li^+] (kmol m^{-3})')
            set(gca,"FontSize",30)
            ylim([1 1.45])
            %0.05);
        exportgraphics(gcf,'testAnimated.gif','Append',true);
    end
    
    %f = gca;
     %    exportgraphics(f,'concentration.png', 'Resolution', 600)
    end
%%
    % phi electrolyte
    % Plot concentrations for desired times
    if FLAG.PLOT.phi_el
    figure
    hold on
    for i = 1:N_times
        plot(GEO.x_vec,phi_el(t_index(i),:),'-o','LineWidth',2,'DisplayName',['t = ' , num2str(t_soln(t_index(i))) , 's'])
    end
    lgn = legend;
    lgn.Location = 'southwest';
    title('\phi_{el}')
    xlabel('X Position (m)')
    ylabel('phi_{el} (V)')
    %     f = gca;
    %     exportgraphics(f,'potential.png', 'Resolution', 600)
    end
%%
    % Cell voltage
    if FLAG.PLOT.cellVoltage
    figure
    plot(t_soln,cell_voltage,'LineWidth',2)
    title('Cell Voltage')
    xlabel('Time (s)')
    ylabel('Voltage (V)')
    xlim([0,t_soln(end)])
    end
%%
    % D_o_Liion
    if FLAG.PLOT.D_o_Liion
    figure
    hold on
    for i = 1:N_times
        plot(GEO.x_vec,D_o_Liion_vec(t_index(i),:),'-*','LineWidth',2,'DisplayName',['t = ' , num2str(t_soln(t_index(i))) , 's'])
    end
    lgn = legend;
    lgn.Location = 'southwest';
    title('D_{o,Li^+}')
    xlabel('X Position (m)')
    ylabel('D_{o,Li^+} (m^2 /s)')
    end    
%%    
    % tf_num
    if FLAG.PLOT.tf_num
    figure
    hold on
    for i = 1:N_times
        plot(GEO.x_vec,tf_vec(t_index(i),:),'-*','LineWidth',2,'DisplayName',['t = ' , num2str(t_soln(t_index(i))) , 's'])
    end
    lgn = legend;
    lgn.Location = 'southwest';
    title('Transference Number')
    xlabel('X Position (m)')
    ylabel('t_{+}^0 (-)')
    end
%%    
    % activity
    if FLAG.PLOT.activity
    figure
    hold on
    for i = 1:N_times
        plot(GEO.x_vec,activity_vec(t_index(i),:),'-*','LineWidth',2,'DisplayName',['t = ' , num2str(t_soln(t_index(i))) , 's'])
    end
    lgn = legend;
    lgn.Location = 'southwest';
    title('Activity')
    xlabel('X Position (m)')
    ylabel('activity (-)')
    end
 %%   
    % Ionic Conductivity
    if FLAG.PLOT.kappa
    figure
    hold on
    for i = 1:N_times
        plot(GEO.x_vec,kappa_vec(t_index(i),:),'-*','LineWidth',2,'DisplayName',['t = ' , num2str(t_soln(t_index(i))) , 's'])
    end
    lgn = legend;
    lgn.Location = 'southwest';
    title('\kappa')
    xlabel('X Position (m)')
    ylabel('\kappa (S/m)')
    end

%% Arrange Figures
FigArrange = 1;
fig = gcf;
NumFig = fig.Number;
if FigArrange == 1
    Ncol = 3;
    
    for i = 1:NumFig
        f = figure(i);
        k = mod(i-1,Ncol);
        row = mod(fix((i-1)/Ncol),2);
        if row == 0
            r = 575;
%             r = 540;
        elseif row == 1
            r = 62;
        end
        f.Position = [k*575+15 r 560 420];
    end
end
end