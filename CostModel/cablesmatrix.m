function [cables_length_to_storage] = cablesmatrix(NUM_production_elements,NUM_windmills,NUM_solarpanels,NUM_batteries,x_windmills,y_windmills,x_solar,y_solar,x_buoys,y_buoys,x_battery,y_battery)

% This function computes the length of cables per production element to Storage connection.

    NUM_cables_to_storage = NUM_production_elements*NUM_batteries;
    cables_length_to_storage = zeros(NUM_batteries,NUM_production_elements);

for i=1:NUM_windmills
    for j=1:NUM_batteries
        cables_length_to_storage(j,i) = sqrt(((x_windmills(i,1)-x_battery(j,1))^2)+(y_windmills(i,1)-y_battery(j,1))^2);
    end
end

for i=NUM_windmills+1:NUM_windmills+NUM_solarpanels
        for j=1:NUM_batteries
            cables_length_to_storage(j,i) = sqrt(((x_solar(i-NUM_windmills,1)-x_battery(j,1))^2)+(y_solar(i-NUM_windmills,1)-y_battery(j,1))^2);
        end    
end

for i=NUM_windmills+NUM_solarpanels+1:NUM_production_elements
        for j=1:NUM_batteries
            cables_length_to_storage(j,i) = sqrt(((x_buoys(i-NUM_windmills-NUM_solarpanels,1)-x_battery(j,1))^2)+(y_buoys(i-NUM_windmills-NUM_solarpanels,1)-y_battery(j,1))^2);
        end    
end

fprintf('The number of cables to storage is %i. \n', NUM_cables_to_storage);


end

