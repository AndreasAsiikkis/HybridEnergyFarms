function [cable_capacity_matrix_tobattery] = physicalcapacityEtoS(capacitcapacity_watt_km_cables_EtoH_wind,capacity_watt_km_cables_EtoH_solar,capacity_watt_km_cables_EtoH_wave,NUM_batteries,NUM_production_elements,NUM_windmills,NUM_solarpanels)

% This function sets the max cables capacity values per each production
% element to storage connection.

    cable_capacity_matrix_tobattery = zeros(NUM_batteries,NUM_production_elements);
    NUM_batteries_vec = 1:NUM_batteries;
    NUM_elements_vec = 1:NUM_production_elements;
    
    for i=1:NUM_batteries
        for j=1:NUM_windmills
            cable_capacity_matrix_tobattery(i,j) = capacitcapacity_watt_km_cables_EtoH_wind;
        end
        for j=NUM_windmills+1:(NUM_windmills+NUM_solarpanels)
            cable_capacity_matrix_tobattery(i,j) = capacity_watt_km_cables_EtoH_solar;
        end
        for j=(NUM_windmills+NUM_solarpanels+1):(NUM_production_elements)
            cable_capacity_matrix_tobattery(i,j) = capacity_watt_km_cables_EtoH_wave;
        end
    end
end