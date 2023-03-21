function [TOT_pw_stored,power_stored_total,TOT_revenues_YES_Battery,TOT_revenues_energysale_fromGenerating,total_pw_drained,TOT_revenues_energysale_fromDraining] = caseYESbattery(power_to_be_filled_per_timestep,sold_matrix,NUM_production_elements,turbine_efficiency,pump_efficiency,NUM_iterations,TOT_power_output,row_demand,price,sustained_EtoH,vector_days)

% This function performs the calculations on power quantities and 
% reveunes for the case where the Batteries are deployed.

% Code a smoother behaviour of the pump
        equal_points = zeros(1,NUM_iterations);
        counter1 = zeros(1,NUM_iterations);        
        counter2 = zeros(1,NUM_iterations);

        slope = zeros(1,NUM_iterations);
        slope(1,1) = 0;
        counter1(1,1) = 0;
        counter2(1,1) = 0;
        for i = 2:NUM_iterations
            if (row_demand(1,i) < (TOT_power_output(1,i)))
                counter1(1,i) = counter1(1,i-1) + 1;
                slope(1,i) = 1;
            elseif (row_demand(1,i) == (TOT_power_output(1,i)))
                equal_points(1,i) = 1;
                counter1(1,i) = counter1(1,i-1);
            elseif (row_demand(1,i) > (TOT_power_output(1,i)))
                counter2(1,i) = counter2(1,i-1) + 1;
                slope(1,i) = -1;
            end
        end
fprintf('The number of control decisions per day are: %f', (sum(counter1) + sum(counter2))/365);

% Vectors initialization
        power_stored = zeros(1,NUM_iterations);
        power_stored(1,1) = 0; % If the initial stored value is zero
        power_differencePminD = zeros(1,NUM_iterations);
        power_differenceDminP = zeros(1,NUM_iterations);
        power_drained = zeros(1,NUM_iterations);
        power_drained(1,1) = 0;
        TOT_power_stored = zeros(1,NUM_iterations);
        TOT_power_drained = zeros(1,NUM_iterations);
        TOT_power_stored(1,1) = 0;
        TOT_power_drained(1,1) = 0;

    % Compare demand and total production and compute the initialized
    % quanitites
        for i = 2:NUM_iterations
            if (row_demand(1,i) <  (TOT_power_output(1,i)))
                power_differencePminD(1,i) = (TOT_power_output(1,i)) - row_demand(1,i);
                if (TOT_power_stored(1,i) < power_to_be_filled_per_timestep)
                    if (power_differencePminD(1,i) <= (power_to_be_filled_per_timestep - TOT_power_stored(1,i-1)))
                        if (power_differencePminD(1,i) <= power_to_be_filled_per_timestep)
                            power_stored(1,i) = pump_efficiency*power_differencePminD(1,i);
                            TOT_power_stored(1,i) = TOT_power_stored(1,i-1) + power_stored(1,i);
                            TOT_power_drained(1,i) = TOT_power_drained(1,i-1);
                        elseif (power_differencePminD(1,i) > power_to_be_filled_per_timestep)
                            power_stored(1,i) = pump_efficiency*power_to_be_filled_per_timestep;
                            TOT_power_stored(1,i) = TOT_power_stored(1,i-1) + power_stored(1,i);
                            TOT_power_drained(1,i) = TOT_power_drained(1,i-1);
                        end
                    elseif (power_differencePminD(1,i) > (power_to_be_filled_per_timestep - TOT_power_stored(1,i-1)))
                            power_stored(1,i) = pump_efficiency*(power_to_be_filled_per_timestep - TOT_power_stored(1,i-1));
                            TOT_power_stored(1,i) = TOT_power_stored(1,i-1) + power_stored(1,i);
                            TOT_power_drained(1,i) = TOT_power_drained(1,i-1);
                    end
                elseif (TOT_power_stored(1,i) == power_to_be_filled_per_timestep)
                    power_stored(1,i) = 0;
                    TOT_power_stored(1,i) = TOT_power_stored(1,i-1);
                    TOT_power_drained(1,i) = TOT_power_drained(1,i-1);
                    power_drained(1,i) = 0;
                end
            elseif (row_demand(1,i) > (TOT_power_output(1,i)))
                power_differenceDminP(1,i) = row_demand(1,i) - (TOT_power_output(1,i));
                if (TOT_power_stored(1,i-1) > power_differenceDminP(1,i))
                    power_drained(1,i) = turbine_efficiency*power_differenceDminP(1,i);
                    TOT_power_drained(1,i) = TOT_power_drained(1,i-1) + power_drained(1,i);
                    TOT_power_stored(1,i) = TOT_power_stored(1,i-1) - power_drained(1,i);
                elseif (TOT_power_stored(1,i-1) < power_differenceDminP(1,i))
                    power_drained(1,i) = turbine_efficiency*TOT_power_stored(1,i-1);
                    TOT_power_drained(1,i) = TOT_power_drained(1,i-1) + power_drained(1,i);  
                    TOT_power_stored(1,i) = TOT_power_stored(1,i-1) - power_drained(1,i);
                elseif (TOT_power_stored(1,i-1) == power_differenceDminP(1,i))
                    power_drained(1,i) = power_differenceDminP(1,i);
                    TOT_power_drained(1,i) = TOT_power_drained(1,i-1) + power_drained(1,i);  
                    TOT_power_stored(1,i) = TOT_power_stored(1,i-1) - power_drained(1,i);
                elseif (TOT_power_stored(1,i) == 0)
                    power_drained(1,i) = 0;
                    power_stored(1,i) = 0;
                    power_differenceDminP(1,i) = row_demand(1,i) - TOT_power_output(1,i);
                    TOT_power_drained(1,i) = TOT_power_drained(1,i-1);
                    TOT_power_stored(1,i) = TOT_power_stored(1,i-1);
                end
            elseif (row_demand(1,i) == (TOT_power_output(1,i)))
                power_drained(1,i) = 0;
                power_stored(1,i) = 0;
                TOT_power_drained(1,i) = TOT_power_drained(1,i-1);  
                TOT_power_stored(1,i) = TOT_power_stored(1,i-1);
            end
        end
        % Initializing and calculating the revenues
        total_pw_drained = max(TOT_power_drained);
        selling_iteration = zeros(1,NUM_iterations);
        notselling_iteration = zeros(1,NUM_iterations);
        REVENUES_energy_sold_fromDraining = zeros(1,NUM_iterations);
        REVENUES_not_raised = zeros(1,NUM_iterations);
        for i=1:NUM_iterations
            if (power_drained(1,i) ~= 0)
                selling_iteration(1,i) = 1; % If it has been drained, it has been sold.
            elseif (power_stored(1,i) ~= 0)
                notselling_iteration(1,i) = 1;
            end
            REVENUES_energy_sold_fromDraining(1,i) = selling_iteration(1,i)*(power_drained(1,i))*price(1,i);  % (power_drained(1,i) + power_differenceDminP(1,i) - power_stored(1,i))
            REVENUES_not_raised(1,i) = notselling_iteration(1,i)*power_stored(1,i)*price(1,i);
        end
    % Calculating the revenues over the given period.   
    TOT_revenues_notraised = sum(REVENUES_not_raised);
    TOT_revenues_energysale_fromDraining = sum(REVENUES_energy_sold_fromDraining);
    power_stored_total = sum(power_stored);
        REVENUES_energy_sold_fromGenerating = zeros(1,NUM_iterations);
        for i=1:NUM_iterations
            for j=1:NUM_production_elements
                if (sustained_EtoH(i,j) == 1)
                    if (sold_matrix(i,j) > 0)
                        REVENUES_energy_sold_fromGenerating(1,i) = sold_matrix(i,j)*price(1,i);
                    end
                end
            end
        end
    TOT_revenues_energysale_fromGenerating = sum(REVENUES_energy_sold_fromGenerating);
    TOT_pw_stored = sum(power_stored);
    TOT_revenues_YES_Battery = TOT_revenues_energysale_fromGenerating + TOT_revenues_energysale_fromDraining;
    
    figure
    grid on
    plot(vector_days,(power_differenceDminP)/1000000); % From Watt to MWatt
    xlabel('Day of the year');
    ylabel('Power [MW]');
    title('Demand minus Production trend');
    
    figure
    grid on
    plot(vector_days,(TOT_power_drained)/1000000);
        xlabel('Day of the year');
    ylabel('Power [MW]');
    title('Total drained power');
    
    figure
    grid on
    plot(vector_days,(TOT_power_stored)/1000000);
        xlabel('Day of the year');
    ylabel('Power [MW]');
    title('Total stored power');
    
    figure
    grid on
    plot(vector_days,(power_stored)/1000000);
        xlabel('Day of the year');
    ylabel('Power [MW]');
    title('Stored power at time step');
    
    figure
    grid on
    plot(vector_days,(power_drained)/1000000);
        xlabel('Day of the year');
    ylabel('Power [MW]');
    title('Drained power at time step');
    
    figure
    grid on
    plot(vector_days,REVENUES_energy_sold_fromDraining);
            xlabel('Day of the year');
    ylabel('Revenues [EUR]');
    title('Revenues from Battery draining');
    
    figure
    grid on
    plot(vector_days,REVENUES_energy_sold_fromGenerating);
                xlabel('Day of the year');
    ylabel('Revenues [EUR]');
    title('Revenues from power generation');    
    
end