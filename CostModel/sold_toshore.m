function [sold_matrix_toShore] = sold_toshore(vector_days,TOT_power_output,NUM_iterations,NUM_hubs,sustained_HtoS,sum_physical_cables_capacityHtoShore)

% This function store the value of the sold energy to the shore per
% iteration. This quantity depends both on the produced power as well as on
% the capacity of the used cables.

sold_matrix_toShore = zeros(NUM_iterations,NUM_hubs);
for i = 1:NUM_iterations
    for j=1:NUM_hubs
        if (sustained_HtoS(i,j) == 1) % Adjacency matrix deriving from functions "sustained[...].m"
            if (TOT_power_output(1,i) > 0)
                sold_matrix_toShore(i,j) = TOT_power_output(1,i);
            end
        elseif (sustained_HtoS(i,j) == 0)
            sold_matrix_toShore(i,j) = sum_physical_cables_capacityHtoShore(1,1); 
        end
    end
end
NUM_iterations_vec = 1:NUM_iterations;
figure
plot(vector_days,(sold_matrix_toShore)/1000000);
        xlabel('Day of the year');
        ylabel('Sold power [MW]');
title('Sold power to shore');
end