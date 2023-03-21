function [sustained_HtoShore,for_percentage_sustained_HtoS] = sustainedcapacityHtoShore(TOT_power_output,physical_cables_capacityHtoShore,NUM_hubs,NUM_iterations)

% This function compares the cables physical capacities with the produced
% power to verify whether the power amounts produced per iteration were
% sustained by cables. The following step is contained in functions
% "sold[...].m".

row_physical_cables_capacityHtoShore = physical_cables_capacityHtoShore(1,:);
sustained_HtoShore = zeros(NUM_iterations,NUM_hubs);
NUM_iterations_vec = 1:NUM_iterations;
for_percentage_sustained_HtoS = zeros(1,NUM_hubs);

    
for i=1:NUM_iterations
        for j=1:NUM_hubs
            if (TOT_power_output(1,i) <= row_physical_cables_capacityHtoShore(1,j))
                sustained_HtoShore(i,j) = 1;
            elseif (TOT_power_output(1,i) > row_physical_cables_capacityHtoShore(1,j))
                sustained_HtoShore(i,j) = 0;
            end
        end
end

sustained_HtoS_vector_perelement = sum(sustained_HtoShore);
for j=1:NUM_hubs
    for_percentage_sustained_HtoS(1,j) = round(sustained_HtoS_vector_perelement(1,j)*100/NUM_iterations,2);
end
end