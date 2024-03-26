function appendDataToFile(filename, data)
    % Load the existing data from the file
    if exist(filename, 'file') == 2
        existing_data = load(filename);
    else
        existing_data = [];
    end
    
    % Append the new data to the existing data
    if isempty(existing_data)
        combined_data = data;
    else
        combined_data = [existing_data; data];
    end
    
    % Save the combined data to the file
    save(filename, 'combined_data');
end