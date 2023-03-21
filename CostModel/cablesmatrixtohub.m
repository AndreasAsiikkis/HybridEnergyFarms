function [cables_length_to_hub] = cablesmatrixtohub(NUM_hubs,NUM_production_elements,NUM_windmills,NUM_solarpanels,x_windmills,y_windmills,x_solar,y_solar,x_buoys,y_buoys,x_hub,y_hub)

% This function computes the length of cables for production element to hub connection.

    NUM_cables_to_hub = NUM_production_elements*NUM_hubs;
    cables_length_to_hub = zeros(NUM_hubs,NUM_production_elements);

for i=1:NUM_windmills
    for j=1:NUM_hubs
        cables_length_to_hub(j,i) = sqrt(((x_windmills(i,1)-x_hub(j,1))^2)+(y_windmills(i,1)-y_hub(j,1))^2);
    end
end

for i=NUM_windmills+1:NUM_windmills+NUM_solarpanels
        for j=1:NUM_hubs
            cables_length_to_hub(j,i) = sqrt(((x_solar(i-NUM_windmills,1)-x_hub(j,1))^2)+(y_solar(i-NUM_windmills,1)-y_hub(j,1))^2);
        end
end

for i=NUM_windmills+NUM_solarpanels+1:NUM_production_elements
        for j=1:NUM_hubs
            cables_length_to_hub(j,i) = sqrt(((x_buoys(i-NUM_windmills-NUM_solarpanels,1)-x_hub(j,1))^2)+(y_buoys(i-NUM_windmills-NUM_solarpanels,1)-y_hub(j,1))^2);
        end
end

fprintf('The number of cables to the hub(s) is %i. \n', NUM_cables_to_hub);
end

