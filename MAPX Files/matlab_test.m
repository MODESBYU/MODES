% Open the .mapx file for reading
fileID = fopen('test.mapx', 'r');

% Define the format of the data (e.g., '%f' for floating-point numbers)
formatSpec = '%f';

% Read the data into a column vector
A = fscanf(fileID, formatSpec);

% Close the file
fclose(fileID);

display(A)