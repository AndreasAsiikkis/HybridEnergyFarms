function [sustained_StoH,for_percentage_sustained_StoH] = sustainedcapacityStoH(NUM_batteries,physical_cables_capacity_STOR_to_HUB,NUM_hubs,DminP,NUM_iterations,NUM_cables_stor_to_hubs)

% This function compares the cables physical capacities with the produced
% power to verify whether the power amounts produced per iteration were
% sustained by cables. The following step is contained in functions
% "sold[...].m".

row_physical_cables_capacity_STOR_to_HUB = physical_cables_capacity_STOR_to_HUB(1,:);
sustained_StoH = zeros(NUM_iterations,NUM_hubs);
NUM_hubs_vec = 1:NUM_hubs;
NUM_batteries_vec = 1:NUM_batteries;
NUM_iterations_vec = 1:NUM_iterations;
for_percentage_sustained_StoH = zeros(1,NUM_hubs);
    
for i=1:NUM_iterations
        for j=1:NUM_hubs
            if (DminP(1,i)/(NUM_cables_stor_to_hubs) <= row_physical_cables_capacity_STOR_to_HUB(1,j))
                sustained_StoH(i,j) = 1;
            elseif (DminP(1,i)/(NUM_cables_stor_to_hubs) > row_physical_cables_capacity_STOR_to_HUB(1,j))
                sustained_StoH(i,j) = 0;
            end
        end
end

sustained_StoH_vector_perelement = sum(sustained_StoH);
for j=1:NUM_hubs
    for_percentage_sustained_StoH(1,j) = round(sustained_StoH_vector_perelement(1,j)*100/NUM_iterations,2);
end
end
