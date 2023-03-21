function [cables_length_s_to_hub] = cablesmatrix_StoH(NUM_batteries,NUM_hubs,x_battery,y_battery,x_hub,y_hub)

% This function computes the length of cables per Storage to hub connection.

    NUM_cables_s_to_hub = NUM_hubs*NUM_batteries;
    cables_length_s_to_hub = zeros(NUM_hubs,NUM_batteries);

for i=1:NUM_hubs
    for j=1:NUM_batteries
        cables_length_s_to_hub(i,j) = sqrt(((x_hub(i,1)-x_battery(j,1))^2)+(y_hub(i,1)-y_battery(j,1))^2);
    end
end

fprintf('The number of cables to storage is %i. \n', NUM_cables_s_to_hub);
end

