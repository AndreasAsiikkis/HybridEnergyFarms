function [sustained_EtoS,for_percentage_sustained_EtoS] = sustainedcapacityEtoS(NUM_batteries,physical_cables_capacityEtoS,NUM_production_elements,PminD,NUM_iterations,NUM_cables_to_storage)

% This function compares the cables physical capacities with the produced
% power to verify whether the power amounts produced per iteration were
% sustained by cables. The following step is contained in functions
% "sold[...].m".

row_physical_cables_capacityEtoS = physical_cables_capacityEtoS(1,:);
sustained_EtoS = zeros(NUM_iterations,NUM_production_elements);
NUM_elements_vec = 1:NUM_production_elements;
NUM_batteries_vec = 1:NUM_batteries;
for_percentage_sustained_EtoS = zeros(1,NUM_production_elements);
    
for i=1:NUM_iterations
    for j=1:NUM_production_elements
        if (PminD(1,i)/(NUM_cables_to_storage) <= row_physical_cables_capacityEtoS(1,j))
                sustained_EtoS(i,j) = 1;
        elseif (PminD(1,i)/(NUM_cables_to_storage) > row_physical_cables_capacityEtoS(1,j))
                sustained_EtoS(i,j) = 0;
        end
     end
end

sustained_EtoS_vector_perelement = sum(sustained_EtoS);
for j=1:NUM_production_elements
    for_percentage_sustained_EtoS(1,j) = round(sustained_EtoS_vector_perelement(1,j)*100/NUM_iterations,2);
end
end
