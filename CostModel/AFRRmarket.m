function [norm_diff] = AFRRmarket(NUM_iterations,row_pwfromwind,row_pwfromwave,row_pwfromsolar,row_demand,vector_days)

        random_vector_production = rand(1,NUM_iterations);
        random_vector_demand = rand(1,NUM_iterations);
        row_ProducedPwToday_PerIteration = zeros(1,NUM_iterations);
        row_ProducedPwTomorrow_PerIteration = zeros(1,NUM_iterations);
        row_DemandTomorrow_PerIteration = zeros(1,NUM_iterations);
        difference_DminP = zeros(1,NUM_iterations);
        for i=1:NUM_iterations
            row_ProducedPwToday_PerIteration(1,i) = row_pwfromwind(1,i) + row_pwfromsolar(1,i) + row_pwfromwave(1,i);
            row_ProducedPwTomorrow_PerIteration(1,i) = row_ProducedPwToday_PerIteration(1,i)*random_vector_production(1,i);
            row_DemandTomorrow_PerIteration(1,i) = row_demand(1,i)*random_vector_demand(1,i);
        end
        % rand_forpricevector = zeros(1,NUM_iterations);
        % Generating the difference vector between forecasts
        for i=1:NUM_iterations
            difference_DminP(1,i) = row_DemandTomorrow_PerIteration(1,i) - row_ProducedPwToday_PerIteration(1,i);
        end
        max_difference = max(difference_DminP);
        % Normalizing the difference vector between forecasts: this will influence the price
        norm_diff = zeros(1,NUM_iterations);
        for i=1:NUM_iterations
            norm_diff(1,i) = (abs(difference_DminP(1,i)))/max_difference;
        end
       