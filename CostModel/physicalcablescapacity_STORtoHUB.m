function [cable_capacity_matrix_STORtoHUB] = physicalcablescapacity_STORtoHUB(NUM_hubs,NUM_batteries,capacity_watt_km_cables_StoragetoH)

    cable_capacity_matrix_STORtoHUB = zeros(NUM_batteries,NUM_hubs);
    NUM_batteries_vec = 1:NUM_batteries;
    NUM_hubs_vec = 1:NUM_hubs;
    
    for i=1:NUM_batteries
        for j=1:NUM_hubs
            cable_capacity_matrix_STORtoHUB(i,j) = capacity_watt_km_cables_StoragetoH;
        end
    end
%     Plot the cable capacity versus the capacity that shall be needed
%     figure
%     if (NUM_batteries == 1)  && (NUM_hubs == 1)
%         plot(NUM_batteries_vec,cable_capacity_matrix_STORtoHUB);
%     elseif (NUM_batteries == 1)  && (NUM_hubs > 1)
%         plot(NUM_hubs_vec,cable_capacity_matrix_STORtoHUB);
%     elseif (NUM_hubs == 1) && (NUM_batteries > 1)
%         plot(NUM_batteries_vec,cable_capacity_matrix_STORtoHUB);
%     elseif (NUM_batteries > 1) && (NUM_hubs > 1)
%         mesh(NUM_hubs_vec,NUM_batteries_vec,cable_capacity_matrix_STORtoHUB);
%     end
%     title('Cable capacity (STOR to H) [W]');
end