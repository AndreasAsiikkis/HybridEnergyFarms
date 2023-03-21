function [sustained_EtoHub,for_percentage_sustained_EtoH] = sustainedcapacityEtoH(NUM_hubs,NUM_production_elements,NUM_windmills,NUM_solarpanels,physical_cables_capacityEtoH,NUM_iterations,row_pwfromwave,row_pwfromsolar,row_pwfromwind)

% This function compares the cables physical capacities with the produced
% power to verify whether the power amounts produced per iteration were
% sustained by cables. The following step is contained in functions
% "sold[...].m".

row_physical_cables_capacityEtoH = physical_cables_capacityEtoH(1,:);
sustained_EtoHub = zeros(NUM_iterations,NUM_production_elements);
NUM_elements_vec = 1:NUM_production_elements;
NUM_iterations_vec = 1:NUM_iterations;
for_percentage_sustained_EtoH = zeros(1,NUM_production_elements);


    
for i=1:NUM_iterations
        for j=1:NUM_windmills
            if (row_pwfromwind(1,i) <= physical_cables_capacityEtoH(1,j))
                sustained_EtoHub(i,j) = 1;
            elseif (row_pwfromwind(1,i) > row_physical_cables_capacityEtoH(1,j))
                sustained_EtoHub(i,j) = 0;
            end
        end
        for j=NUM_windmills+1:(NUM_windmills+NUM_solarpanels)
            if (row_pwfromsolar(1,i) <= row_physical_cables_capacityEtoH(1,j))
                sustained_EtoHub(i,j) = 1;
            elseif (row_pwfromsolar(1,i) > row_physical_cables_capacityEtoH(1,j))
                sustained_EtoHub(i,j) = 0;        
            end
        end
        for j=(NUM_windmills+NUM_solarpanels+1):NUM_production_elements
            if (row_pwfromwave(1,i) <= row_physical_cables_capacityEtoH(1,j))
                sustained_EtoHub(i,j) = 1;
            elseif (row_pwfromwave(1,i) > row_physical_cables_capacityEtoH(1,j))
                sustained_EtoHub(i,j) = 0;        
            end
        end
end

sustained_EtoH_vector_perelement = sum(sustained_EtoHub);
for j=1:NUM_production_elements
    for_percentage_sustained_EtoH(1,j) = round(sustained_EtoH_vector_perelement(1,j)*100/NUM_iterations,2);
end
end
