% % Open the .mapx file for reading
% fileID = fopen('test.mapx', 'r');
% 
% % Define the format of the data (e.g., '%f' for floating-point numbers)
% formatSpec = '%f';
% 
% % Read the data into a column vector
% A = fscanf(fileID, formatSpec);
% 
% % Close the file
% fclose(fileID);
% 
% display(A)
% 
% 
answer = fmincon(@solvered,2000);

display(answer)

function err = solvered(omega)
    Z1 = 50/3 * 1000;
    Z2 = 1.2 * 1000;
    Z3 = .2 * omega * 1i;
    Z4 = (50e-6 * omega * 1i)^-1;

    Zi = Z2 + Z3;
    Zeq = ((Z4 * Zi) / (Z4 + Zi)) + Z1;

    V = 30 * cos(0);

    I1 = V / Zeq;
    I2 = 5;

    err = I1 - I2;
end
