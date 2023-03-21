function [cable_capacity_matrix_tohub] = physicalcapacityEtoH(NUM_windmills,NUM_solarpanels,capacity_watt_km_cables_EtoH_wind,capacity_watt_km_cables_EtoH_solar,capacity_watt_km_cables_EtoH_wave,NUM_hubs,NUM_production_elements)

% This function sets the max cables capacity values per each production
% element to hub connection.

    cable_capacity_matrix_tohub = zeros(NUM_hubs,NUM_production_elements);
    NUM_hubs_vec = 1:NUM_hubs;
    NUM_elements_vec = 1:NUM_production_elements;
    
    for i=1:NUM_hubs
        for j=1:NUM_windmills
            cable_capacity_matrix_tohub(i,j) = capacity_watt_km_cables_EtoH_wind;
        end
        for j=NUM_windmills+1:(NUM_windmills+NUM_solarpanels)
            cable_capacity_matrix_tohub(i,j) = capacity_watt_km_cables_EtoH_solar;
        end
        for j=(NUM_windmills+NUM_solarpanels+1):(NUM_production_elements)
            cable_capacity_matrix_tohub(i,j) = capacity_watt_km_cables_EtoH_wave;
        end
    end
end