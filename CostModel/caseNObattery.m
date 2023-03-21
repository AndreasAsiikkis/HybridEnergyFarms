function [TOT_unsoldenergy,TOT_revenues_NO_Battery,TOT_revenues_not_raised,power_differencePminD,power_differenceDminP] = caseNObattery(NUM_hubs,physical_cables_capacityHtoShore,sold_matrix_toShore,NUM_production_elements,physical_cables_capacityEtoH,sustained_EtoH,NUM_iterations,TOT_power_output,row_demand,price)
        
% This function performs the calculations on power quantities and 
% reveunes for the case where the Batteries are not deployed.

    % Vectors initialization
        power_differencePminD = zeros(1,NUM_iterations);
        power_differenceDminP = zeros(1,NUM_iterations);
        REVENUES_energy_sold = zeros(1,NUM_iterations);
        REVENUES_not_raised = zeros(1,NUM_iterations);
        sold_energy = zeros(1,NUM_iterations);
        unsold_energy = zeros(1,NUM_iterations);
        bought_energy = zeros(1,NUM_iterations);
        
    % Compare demand and total production and compute the initialized
    % quanitites
        for i = 1:NUM_iterations
            if (row_demand(1,i) <= (TOT_power_output(1,i)))
                power_differencePminD(1,i) = (TOT_power_output(1,i)) - row_demand(1,i);
                for j=1:NUM_hubs
                    if (sold_matrix_toShore(i,j) > row_demand(1,i))
                        sold_energy(1,i) = row_demand(1,i);
                        unsold_energy(1,i) = power_differencePminD(1,i);
                    elseif (sold_matrix_toShore(i,j) <= row_demand(1,i))
                        sold_energy(1,i) = physical_cables_capacityEtoH(1,j);
                        unsold_energy(1,i) = power_differencePminD(1,i);
                    end
                end
            elseif (row_demand(1,i) > (TOT_power_output(1,i)))
                power_differenceDminP(1,i) = row_demand(1,i) - (TOT_power_output(1,i));
                if (TOT_power_output > 0)
                    for j=1:NUM_hubs
                        if (sold_matrix_toShore(i,j) > physical_cables_capacityHtoShore(1,j))
                            sold_energy(1,i) = physical_cables_capacityHtoShore(1,j);
                            unsold_energy(1,i) = power_differenceDminP(1,i);
                        elseif (sold_matrix_toShore(i,j) <= physical_cables_capacityHtoShore(1,j))
                            sold_energy(1,i) = sold_matrix_toShore(i,1);
                            unsold_energy(1,i) = power_differenceDminP(1,i);
                        end
                    end
                end
            elseif (TOT_power_output(1,i) <= 0)
                power_differenceDminP(1,i) = row_demand(1,i) - (TOT_power_output(1,i));
                sold_energy(1,i) = 0; 
                bought_energy(1,i) = power_differenceDminP(1,i);
            end
        REVENUES_energy_sold(1,i) = sold_energy(1,i)*price(1,i);
        REVENUES_not_raised(1,i) = unsold_energy(1,i)*price(1,i);
        end
        
    % Calculating the revenues over the given period.       
        TOT_unsoldenergy = sum(unsold_energy);
        TOT_revenues_NO_Battery = sum(REVENUES_energy_sold) - sum(REVENUES_not_raised);
        TOT_revenues_not_raised = sum(REVENUES_not_raised);
end