function [sold_matrix] = sold(NUM_windmills,NUM_solarpanels,row_pwfromwind,row_pwfromsolar,row_pwfromwave,NUM_iterations,NUM_production_elements,sustained_EtoH,sum_physical_cables_capacityEtoH)

% This function store the value of the sold energy to the grid per
% iteration. This quantity depends both on the produced power as well as on
% the capacity of the used cables.

sold_matrix = zeros(NUM_iterations,NUM_production_elements);
for i=1:NUM_iterations
        for j=1:NUM_windmills
            if (sustained_EtoH(i,j) == 1) % Adjacency matrix deriving from functions "sustained[...].m"
                sold_matrix(i,j) = row_pwfromwind(1,i);
            elseif (sustained_EtoH(i,j) == 0)
                sold_matrix(i,j) = sum_physical_cables_capacityEtoH(1,1);
            end
        end
        for j=NUM_windmills+1:(NUM_windmills+NUM_solarpanels)
            if (sustained_EtoH(i,j) == 1)
                sold_matrix(i,j) = row_pwfromsolar(1,i);
            elseif (sustained_EtoH(i,j) == 0)
                sold_matrix(i,j) = sum_physical_cables_capacityEtoH(1,1);
            end
        end
        for j=(NUM_windmills+NUM_solarpanels+1):NUM_production_elements
            if (sustained_EtoH(i,j) == 1)
                sold_matrix(i,j) = row_pwfromwave(1,i);
            elseif (sustained_EtoH(i,j) == 0)
                sold_matrix(i,j) = sum_physical_cables_capacityEtoH(1,1);
            end
        end
end
end