function [cable_capacity_matrix_toshore] = physicalcapacityHtoShore(capacity_watt_km_cables_HtoShore,NUM_hubs)

% This function sets the max cables capacity values per hub to storage connection.

    cable_capacity_matrix_toshore = zeros(1,NUM_hubs);
    
    for i=1:NUM_hubs
            cable_capacity_matrix_toshore(1,i) = capacity_watt_km_cables_HtoShore;
    end
    fprintf('The capacity for the cables to shore is %i. \n', capacity_watt_km_cables_HtoShore);
end