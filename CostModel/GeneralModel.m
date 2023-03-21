
%%% Techno-Financial Analysis
    
    % This model performs a techno-financial analysis of any offshore hybrid 
    % integration containing the Ocean Battery (PHS device) as on-site storage device.

% Extracting inputs here---------------------------------------------------

    % The complete set of model's inputs can be modified from the file 
    % "inputs.m".
    
    prompt = {'How many windmills?','How many solar arrays?','How many WEC arrays?','How many batteries?','How many hubs?','Insert the length of the grid side [Km]'};
    dlgtitle = 'Grid Characterization'; 
    dims = [1 55; 1 55; 1 55; 1 55; 1 55; 1 55;];
    definput = {'95','0','0','25','1','19'};
    answer = inputdlg(prompt,dlgtitle,dims,definput);

    NUM_windmills = str2num(answer{1});
    NUM_solarpanels = str2num(answer{2});
    NUM_buoys = str2num(answer{3});
    NUM_batteries = str2num(answer{4});
    NUM_hubs = str2num(answer{5});
    square_side = str2num(answer{6});

    % Here all inputs are extracted from function inputs.m
    NUM_inputs = 58;     % How many inputs are you planning to provide?
    vector_of_inputs = inputs(NUM_inputs); % Call function inputs in order to extract the inputs.
    present_wind = vector_of_inputs(1,2);  % If wind power production is present.
    present_solar = vector_of_inputs(1,3); % If solar power production is present.
    solarpanel_surface = vector_of_inputs(1,53); % Solar panel surface [m^2].
    present_wave = vector_of_inputs(1,4); % If wave power production is present.
    present_ob = vector_of_inputs(1,5); % If Ocean Battery as storage is present.
    time_period = vector_of_inputs(1,10); % Period to be analysed.
    time_step = vector_of_inputs(1,11); % Simulation time step.
    NUM_iterations = 35151; % Must be minor or equal to the number of rows of the power trends from the Power Model, contained in function "out".
    NUM_days = vector_of_inputs(1,33); % Number of days in time_period.
        vector_days = linspace(1,NUM_days,NUM_iterations);
    ob_max_storage = vector_of_inputs(1,15); % Energy storage capacity of the single Ocean Battery.
    capacity_watt_km_cables_EtoH_wind = vector_of_inputs(1,20); % Cables capacities from element to hub.
        capacity_watt_km_cables_EtoH_solar = vector_of_inputs(1,49);
            capacity_watt_km_cables_EtoH_wave = vector_of_inputs(1,50);
    capacity_watt_km_cables_EtoS_wind = vector_of_inputs(1,39); % Cables capacities from element to storage.
        capacity_watt_km_cables_EtoS_solar = vector_of_inputs(1,47);
            capacity_watt_km_cables_EtoS_wave = vector_of_inputs(1,48);
    capacity_watt_km_cables_StoragetoH = vector_of_inputs(1,39); % Cables capacities from storage to hub.
    capacity_watt_km_cables_HtoShore = vector_of_inputs(1,44); % Cables capacities from hub to shore.
    tennet_agreement_forBRP = vector_of_inputs(1,21); % Agreement with Tennet for power supply.
    time_stepsfor_max_rpm = vector_of_inputs(1,26); % Cables capacities from element to hub.
    battery_power_capacity_periteration = vector_of_inputs(1,30)*NUM_batteries; % How much the Ocean Battery can accept per iteration
    pump_efficiency = vector_of_inputs(1,31);
    turbine_efficiency = vector_of_inputs(1,32);
    demand_factor = vector_of_inputs(1,45); % Factor by which the demand needs to be divided in order to compare it to the production. Look inside function "inputs.m".
    distance_hub_to_shore = vector_of_inputs(1,46); % Distance between grid hub and shore.

    % Express the offshore farm's characterization
    if (present_wind == 1)
        fprintf('Wind production recorded: the case with %.2f windmills will be simulated. \n', NUM_windmills);
    end
    if (present_solar == 1)
        fprintf('Solar production recorded: the case with %.2f panels will be simulated. \n', NUM_solarpanels);
    end
    if (present_wave == 1)
        fprintf('Wave production recorded: the case with %.2f buoys will be simulated. \n', NUM_buoys);
    end
    if (present_ob == 1)
        fprintf('Ocean Battery presence recorded: the case with %.2f Ocean Battery(ies) will be simulated. \n', NUM_batteries);
    end
    % Recall timespan and consequent iteration number of the simulation
    fprintf('The period which will be analyzed corresponds to %i month(s), with the time step of %.2f minutes. \n', time_period, time_step);
    fprintf('Consequently, %.2f iterations will be performed. \n', NUM_iterations);
    
% Process geometrical data to plot grid and components
    grid_area = square_side^2;                    % [km^2]
    square_side_meters = square_side*1000;
    density_wind = grid_area/NUM_windmills; % [#/Km^2]
    density_solar = grid_area/NUM_solarpanels; % [#/Km^2]
    density_wave = grid_area/NUM_buoys; % [#/Km^2]
    fprintf('The windmills density is equal to: %.2f. \n', density_wind);
    fprintf('The solar panels density is equal to: %.2f. \n', density_solar);
    fprintf('The buoys density is equal to: %.2f. \n', density_wave);

    % Plotting the grid here---------------------------------------------------
    
    figure('Name','Element Displacement on grid, scale 1:Grid Side [m]')
    % imshow('Ocean+from+Above+Drone+Footage.png')
    grid on
    grid minor
    [x_w,y_w] = ginput(NUM_windmills);
       h1 = text(x_w,y_w,'W', ...
                'HorizontalAlignment','center', ...
                'Color', [0 0 0], ...
                'FontSize',10);

    [x_s,y_s] = ginput(NUM_solarpanels);
           h2 = text(x_s,y_s,'S', ...
                'HorizontalAlignment','center', ...
                'Color', [1 0 0], ...
                'FontSize',10);

    [x_bu,y_bu] = ginput(NUM_buoys);
           h3 = text(x_bu,y_bu,'B', ...
                'HorizontalAlignment','center', ...
                'Color', [0 0 1], ...
                'FontSize',10);

    [x_ba,y_ba] = ginput(NUM_batteries);
           h4 = text(x_ba,y_ba,'OB', ...
                'HorizontalAlignment','center', ...
                'Color', [0 1 0], ...
                'FontSize',12);

    [x_h,y_h] = ginput(NUM_hubs);
           h5 = text(x_h,y_h,'H', ...
                'HorizontalAlignment','center', ...
                'Color', [1 0 1], ...
                'FontSize',16);
    title('Elements placement on grid [scale 1:Grid Side [m]')
    grid off
    % Adapting the coordinates from ginputs to the real scale.
    x_windmills = x_w.*square_side_meters;
    y_windmills = y_w.*square_side_meters;
    x_solar = x_s.*square_side_meters;
    y_solar = y_s.*square_side_meters;
    x_buoys = x_bu.*square_side_meters;
    y_buoys = y_bu.*square_side_meters;
    x_battery = x_ba.*square_side_meters;
    y_battery = y_ba.*square_side_meters;
    x_hub = x_h.*square_side_meters;
    y_hub = y_h.*square_side_meters;
        
% Receiving inputs from the Power Analysis here----------------------------

    fprintf('The numbers given as input for each of the modules are being transferred to the Cost model. \n');
    fprintf('Now the calculated powers will be acquired. \n');
    
    % Create and fill row vectors of powers and demand
    row_demand_useful = (out.Demand.');
    row_demand = row_demand_useful./demand_factor;
    row_pwfromwind = out.pwfrom_wind.';
    row_pwfromsolar_useful = out.pwfrom_solar.';
    row_pwfromsolar = solarpanel_surface.*row_pwfromsolar_useful;
    row_pwfromwave = out.pwfrom_wave.';
    
    % Total power produced
    TOT_power_output = zeros(1,NUM_iterations);            % Vector Initialization
    for i = 1:NUM_iterations
        TOT_power_output(1,i) = (NUM_buoys*row_pwfromwave(1,i) + NUM_windmills*row_pwfromwind(1,i) + NUM_solarpanels*row_pwfromsolar(1,i));
    end
    
    % Plots of moving average
    movavg_demand = movmean(row_demand,7);
    movavg_pwfromwind = movmean(row_pwfromwind,7);
    movavg_pwfromsolar = movmean(row_pwfromsolar,7);
    movavg_pwfromwave = movmean(row_pwfromwave,7);
    movavg_TOT_power_output = zeros(1,NUM_iterations);            % Vector Initialization
    for i = 1:NUM_iterations
        movavg_TOT_power_output(1,i) = NUM_buoys*movavg_pwfromwave(1,i) + NUM_windmills*movavg_pwfromwind(1,i) + NUM_solarpanels*movavg_pwfromsolar(1,i);
    end
    
% Plot power produced by each component

%     % Power produced from wind
%     figure('Name','Trends of power produced from wind')
%     grid on
%     plot(vector_days,NUM_windmills.*row_pwfromwind,'Color',[0.65 0.65 0.65],'LineWidth',1);
%     xlabel('Day of the year'); 
%     ylabel('Power [W]'); 
%     hold on
%     plot(vector_days,NUM_windmills.*movavg_pwfromwind, 'k','LineWidth',2);
%     title('7-Moving average of Power produced from wind [W]');
%     hold off
%     
%     % Power produced from solar
%     figure('Name','Trends of power produced from solar')
%     grid on
%     plot(vector_days,NUM_solarpanels.*row_pwfromsolar,'Color',[0.65 0.65 0.65],'LineWidth',1);
%     xlabel('Day of the year'); 
%     ylabel('Power [W]'); 
%     hold on
%     plot(vector_days,NUM_solarpanels.*movavg_pwfromsolar, 'y','LineWidth',2);
%     title('7-Moving average of Power produced from solar [W]');
%     hold off
%     
%     % Power produced from waves
%     figure('Name','Trends of power produced from waves')
%     grid on
%     plot(vector_days,NUM_buoys.*row_pwfromwave,'Color',[0.65 0.65 0.65],'LineWidth',1);
%     xlabel('Day of the year'); 
%     ylabel('Power [W]'); 
%     hold on
%     plot(vector_days,NUM_buoys.*movavg_pwfromwave, 'b','LineWidth',2);
%     title('7-Moving average of Power produced from waves [W]');
%     hold off
%     
%     % Total power produced
%     figure('Name','Trends of total produced power')
%     grid on
%     plot(vector_days,(TOT_power_output)/1000000,'Color',[0.65 0.65 0.65],'LineWidth',1);
%     xlabel('Day of the year');
%     ylabel('Power [MW]'); 
%     hold on
%     plot(vector_days,(movavg_TOT_power_output)/1000000,'LineWidth',2);
%     title('7-Moving average of Total power produced [MW]');
%     hold off
%     
%     % Demand
%     figure('Name','Demand trends')
%     grid on
%     plot(vector_days,(row_demand)/1000000,'Color',[0.65 0.65 0.65],'LineWidth',1);
%     xlabel('Day of the year');
%     ylabel('Power [MW]'); 
%     hold on
%     plot(vector_days,(movavg_demand)/1000000,'LineWidth',2);
%     title('7-Moving average of Demand [MW]'); 
%     hold off
    % Generating vectors useful for later on
    DminP = row_demand - TOT_power_output;
    PminD = TOT_power_output - row_demand;
    
% Coding the grid capacity matrices here-----------------------------------

    NUM_production_elements = NUM_windmills + NUM_solarpanels + NUM_buoys;
    if (NUM_batteries > 0)
        NUM_cables_to_storage = NUM_production_elements*NUM_batteries;
        NUM_cables_stor_to_hubs = NUM_batteries*NUM_hubs;
    elseif (NUM_batteries == 0)
        NUM_cables_to_storage = 0;
        NUM_cables_stor_to_hubs = 0;
    end
    NUM_cables_E_to_hub = NUM_production_elements*NUM_hubs;
    NUM_cables_hubs_to_shore = NUM_hubs;
    
% Coding and calculating the grid cables here----------------------------------------------
    
    if (NUM_batteries > 0)
        length_grid_cables_E_to_STOR = cablesmatrix(NUM_production_elements,NUM_windmills,NUM_solarpanels,NUM_batteries,x_windmills,y_windmills,x_solar,y_solar,x_buoys,y_buoys,x_battery,y_battery);
        length_grid_cables_STOR_to_HUB = cablesmatrix_StoH(NUM_batteries,NUM_hubs,x_battery,y_battery,x_hub,y_hub);
    elseif (NUM_batteries == 0)
        length_grid_cables_E_to_STOR = 0;
        length_grid_cables_STOR_to_HUB = 0;
    end
    length_grid_cables_E_to_HUB = cablesmatrixtohub(NUM_hubs,NUM_production_elements,NUM_windmills,NUM_solarpanels,x_windmills,y_windmills,x_solar,y_solar,x_buoys,y_buoys,x_hub,y_hub);

    if (NUM_batteries > 0)
        TOT_lenght_grid_cables_E_to_STOR = sum(sum(length_grid_cables_E_to_STOR));
        TOT_lenght_grid_cables_STOR_to_HUB = sum(sum(length_grid_cables_STOR_to_HUB));
    else
        TOT_lenght_grid_cables_E_to_STOR = 0;
        TOT_lenght_grid_cables_STOR_to_HUB = 0;
    end
    TOT_length_grid_cables_E_to_HUB = sum(sum(length_grid_cables_E_to_HUB));    
    TOT_length_grid_cables_STOR = TOT_lenght_grid_cables_E_to_STOR + TOT_lenght_grid_cables_STOR_to_HUB;
    TOT_length_grid_cables_HUB_to_shore = distance_hub_to_shore*NUM_hubs;
    
% Coding the cables capacity here, I insert them in matrices. The values of the cables capacities can be changed in function inputs.m---
    if (NUM_batteries > 0)
        physical_cables_capacityEtoS = physicalcapacityEtoS(capacity_watt_km_cables_EtoH_wind,capacity_watt_km_cables_EtoH_solar,capacity_watt_km_cables_EtoH_wave,NUM_batteries,NUM_production_elements,NUM_windmills,NUM_solarpanels);
        physical_cables_capacity_STOR_to_HUB = physicalcablescapacity_STORtoHUB(NUM_hubs,NUM_batteries,capacity_watt_km_cables_StoragetoH);
    end
    physical_cables_capacityEtoH = physicalcapacityEtoH(NUM_windmills,NUM_solarpanels,capacity_watt_km_cables_EtoH_wind,capacity_watt_km_cables_EtoH_solar,capacity_watt_km_cables_EtoH_wave,NUM_hubs,NUM_production_elements);
    physical_cables_capacityHtoShore = physicalcapacityHtoShore(capacity_watt_km_cables_HtoShore,NUM_hubs);

    sum_physical_cables_capacityEtoH = sum(physical_cables_capacityEtoH);
    if (NUM_batteries > 0)
        sum_physical_cables_capacityEtoS = sum(physical_cables_capacityEtoS);
        sum_physical_cables_capacitySTORtoHUB = sum(physical_cables_capacity_STOR_to_HUB);
    end
    sum_physical_cables_capacityHtoShore = sum(physical_cables_capacityHtoShore);
    
% Coding the percentages of sustained capacity through the iterations
    [sustained_EtoH,percentage_sust_EtoH] = sustainedcapacityEtoH(NUM_hubs,NUM_production_elements,NUM_windmills,NUM_solarpanels,physical_cables_capacityEtoH,NUM_iterations,row_pwfromwave,row_pwfromsolar,row_pwfromwind);
    char_percentage_sustained_EtoH = string(percentage_sust_EtoH); % I need the sustained capacity vector as char in order to plot the values on the topology mapping
    if (NUM_batteries > 0)
        [sustained_EtoS,percentage_sust_EtoS] = sustainedcapacityEtoS(NUM_batteries,physical_cables_capacityEtoS,NUM_production_elements,PminD,NUM_iterations,NUM_cables_to_storage);
        [sustained_StoH,percentage_sust_StoH] = sustainedcapacityStoH(NUM_batteries,physical_cables_capacity_STOR_to_HUB,NUM_hubs,DminP,NUM_iterations,NUM_cables_stor_to_hubs);
        char_percentage_sustained_EtoS = string(percentage_sust_EtoS);
        char_percentage_sustained_StoH = string(percentage_sust_StoH);
    end
    [sustained_HtoS,percentage_sust_HtoS] = sustainedcapacityHtoShore(TOT_power_output,physical_cables_capacityHtoShore,NUM_hubs,NUM_iterations);
    char_percentage_sustained_HtoS = string(percentage_sust_HtoS);
    
% Coding the topology mapping plots here------------------------------------  
    total_coordinate_vec_x = zeros(1,NUM_production_elements); % Vectors gathering the coordinates of all elements
    total_coordinate_vec_y = zeros(1,NUM_production_elements);

    for i=1:NUM_windmills
        total_coordinate_vec_x(1,i) = x_windmills(i,1);
        total_coordinate_vec_y(1,i) = y_windmills(i,1);
    end
    for i=(NUM_windmills+1):(NUM_windmills+NUM_solarpanels)
        total_coordinate_vec_x(1,i) = x_solar(i-NUM_windmills,1);
        total_coordinate_vec_y(1,i) = y_solar(i-NUM_windmills,1);
    end
    for i=(NUM_windmills+NUM_solarpanels+1):NUM_production_elements
        total_coordinate_vec_x(1,i) = x_buoys(i-NUM_windmills-NUM_solarpanels,1);
        total_coordinate_vec_y(1,i) = y_buoys(i-NUM_windmills-NUM_solarpanels,1);
    end   
    
% Plotting the topology maps with the aid of function circles.m
    if (NUM_batteries > 0)
    figure('Name','Capacity acceptance percentage [E to Stor]')
    xlim([-200 square_side_meters]);
    ylim([-200 square_side_meters]);
    if (NUM_windmills > 0)
    circles(x_windmills,y_windmills,50,'facecolor','blue')
    end
    if (NUM_solarpanels > 0)
    circles(x_solar,y_solar,50,'facecolor','red')
    end
    if (NUM_buoys > 0)
    circles(x_buoys,y_buoys,50,'facecolor','yellow')
    end
    
    for i=1:NUM_windmills
        text(total_coordinate_vec_x(1,i)-125,total_coordinate_vec_y(1,i)-150,char_percentage_sustained_EtoS(1,i))
    end
    for i=(NUM_windmills+1):(NUM_windmills+NUM_solarpanels)
        text(total_coordinate_vec_x(1,i)-125,total_coordinate_vec_y(1,i)-150,char_percentage_sustained_EtoS(1,i))
    end
    for i=(NUM_windmills+NUM_solarpanels+1):NUM_production_elements
        text(total_coordinate_vec_x(1,i)-125,total_coordinate_vec_y(1,i)-150,char_percentage_sustained_EtoS(1,i))
    end 
    if (NUM_batteries > 0)
    circles(x_battery,y_battery,50,'facecolor','green')
    end
    if (NUM_hubs > 0)
    circles(x_hub,y_hub,50,'facecolor','magenta')
    end
    xlabel('Horizontal position on grid [m]');
    ylabel('Vertical position on grid [m]'); 
    title('Cables capacity acceptance percentage [E to Storage]');

    figure('Name','Capacity acceptance percentage [E to H]')
    xlim([-200 square_side_meters]);
    ylim([-200 square_side_meters]);
        if (NUM_windmills > 0)
    circles(x_windmills,y_windmills,50,'facecolor','blue','DisplayName','wind turbine: blue')
        end
            if (NUM_solarpanels > 0)
        circles(x_solar,y_solar,50,'facecolor','red','DisplayName','solar panel: red')
            end
            if (NUM_buoys > 0)
    circles(x_buoys,y_buoys,50,'facecolor','yellow','DisplayName','buoy: yellow')
            end
    end
    % Adding the respective value of capacity acceptance on the mapping plot
    for i=1:NUM_windmills
        text(total_coordinate_vec_x(1,i)-125,total_coordinate_vec_y(1,i)-150,char_percentage_sustained_EtoH(1,i))
    end
    for i=(NUM_windmills+1):(NUM_windmills+NUM_solarpanels)
        text(total_coordinate_vec_x(1,i)-125,total_coordinate_vec_y(1,i)-150,char_percentage_sustained_EtoH(1,i))
    end
    for i=(NUM_windmills+NUM_solarpanels+1):NUM_production_elements
        text(total_coordinate_vec_x(1,i)-125,total_coordinate_vec_y(1,i)-150,char_percentage_sustained_EtoH(1,i))
    end 
    % Plotting the mapping of batteries and hubs
    
    if (NUM_batteries > 0)
    circles(x_battery,y_battery,50,'facecolor','green','DisplayName','Ocean Battery: green')
    end
    if (NUM_hubs > 0)
    circles(x_hub,y_hub,50,'facecolor','magenta','DisplayName','Hub: magenta')
    end
    xlabel('Horizontal position on grid [m]');
    ylabel('Vertical position on grid [m]'); 
    title('Cables capacity acceptance percentage [E to H]');
        
    
% Counting the number of overwhelmed cables % ADD STOR TO H
    counter_overwhelmed_EtoH = 0;
    counter_overwhelmed_EtoS = 0;
    counter_overwhelmed_HtoShore = 0;

   	for i=1:NUM_iterations
        for j=1:NUM_production_elements
            if (sustained_EtoH(i,j) == 0 )
                counter_overwhelmed_EtoH = counter_overwhelmed_EtoH + 1;
            end
        end
    end
    if (NUM_batteries > 0)
        for i=1:NUM_production_elements
            for j=1:NUM_batteries
                if (sustained_EtoS(j,i) == 0 )
                    counter_overwhelmed_EtoS = counter_overwhelmed_EtoS + 1;
                end
            end
        end
    end
    for i=1:NUM_iterations
        for j=1:NUM_hubs
            if (sustained_HtoS(i,j) == 0 )
                counter_overwhelmed_HtoShore = counter_overwhelmed_HtoShore + 1;
            end
        end
    end
    TOT_overwhelemed = counter_overwhelmed_EtoH + counter_overwhelmed_EtoS + counter_overwhelmed_HtoShore;
    fprintf('The cables have been overwhelmed for %i times. \n', TOT_overwhelemed);
    
% Creating sold matrix here------------------------------------------------
    
    sold_matrix = sold(NUM_windmills,NUM_solarpanels,row_pwfromwind,row_pwfromsolar,row_pwfromwave,NUM_iterations,NUM_production_elements,sustained_EtoH,sum_physical_cables_capacityEtoH);
    sold_matrix_toShore = sold_toshore(vector_days,TOT_power_output,NUM_iterations,NUM_hubs,sustained_HtoS,sum_physical_cables_capacityHtoShore);
    
% Coding AFRR market and price function here--------------------------------------------------
    
    if (tennet_agreement_forBRP == 1)
        price = energypriceperW(NUM_iterations,row_pwfromwind,row_pwfromwave,row_pwfromsolar,row_demand,vector_days);
    end
          
% Now the case YES Battery calculations begins ----------------------------

energy_to_be_filled = ob_max_storage*NUM_batteries; % How much energy you can fill across the batteries
power_to_be_filled_per_timestep = (battery_power_capacity_periteration); % + effective_power_capacity)/2;

    if (NUM_batteries > 0)
        [TOT_pw_stored,sum_total_stored_power, revenues_with_batt,TOT_revenues_energysale_fromGenerating,total_pw_drained,TOT_revenues_energysale_fromDraining] = caseYESbattery(power_to_be_filled_per_timestep,sold_matrix,NUM_production_elements,turbine_efficiency,pump_efficiency,NUM_iterations,TOT_power_output,row_demand,price,sustained_EtoH,vector_days);
        roundtrip_efficiency = pump_efficiency*turbine_efficiency;
        fprintf('The roundtrip efficiency is equal to: %f. \n', roundtrip_efficiency)
    else 
        sum_total_stored_power = 0;
    end

% Now the case NO Battery calculations begins ----------------------------
    
    [TOT_unsoldenergy,revenues_without_batt,REVENUES_not_raised_asPwnotsold,p_diffPminD,p_diffDminP] = caseNObattery(NUM_hubs,physical_cables_capacityHtoShore,sold_matrix_toShore,NUM_production_elements,physical_cables_capacityEtoH,sustained_EtoH,NUM_iterations,TOT_power_output,row_demand,price);
    
    % Price diff
%     additional_costs = (TOT_unsoldenergy - TOT_pw_stored)*0.00001;
    additional_costs = (TOT_unsoldenergy)*0.00001;
%% COST ANALYSIS:

        capacity_factor = 0.51;
        lifetime_farm_opex = 25;
        total_pw_output = (30*NUM_buoys*0.435*sum(row_pwfromwave) + NUM_windmills*capacity_factor*sum(row_pwfromwind) + 100*NUM_solarpanels*sum(row_pwfromsolar))/1000000; % [MW]
        
    % !CAPEX!    

        % --- CAPEX WIND for 8-A-20
            if (NUM_windmills > 0)
        CAPEX_prod_wind_turbine_perW = 1.43;                          % [EUR/W]
        CAPEX_prod_wind_supportstructure_perW = 0.61;                 % [EUR/W]
        CAPEX_prod_wind_construction_perW = 0.29;                     % [EUR/W]
        CAPEX_prod_wind_development_perW = 0.1;                       % [EUR/W]
        CAPEX_prod_wind_arrayelectrical_perW = 0.1;                   % [EUR/W]

        PWfromWind = sum(row_pwfromwind)*NUM_windmills;
        CAPEX_prod_wind_turbine = CAPEX_prod_wind_turbine_perW*8000000*NUM_windmills;                               % [EUR]
        CAPEX_prod_wind_supportstructure = CAPEX_prod_wind_supportstructure_perW*8000000*NUM_windmills;             % [EUR]
        CAPEX_prod_wind_construction = CAPEX_prod_wind_construction_perW*8000000*NUM_windmills;                     % [EUR]
        CAPEX_prod_wind_development = CAPEX_prod_wind_development_perW*8000000*NUM_windmills;                       % [EUR]
        CAPEX_prod_wind_arrayelectrical = CAPEX_prod_wind_arrayelectrical_perW*8000000*NUM_windmills;               % [EUR]
        CAPEX_prod_wind_disposalcosts = 337273.68*NUM_windmills;
        
        CAPEX_prod_wind = (CAPEX_prod_wind_turbine + CAPEX_prod_wind_supportstructure + CAPEX_prod_wind_construction + CAPEX_prod_wind_development + CAPEX_prod_wind_arrayelectrical);
        fprintf('The capital expenditure for the wind module is %f euros. \n', CAPEX_prod_wind);
            else
                CAPEX_prod_wind = 0;
            end

        % --- CAPEX SOLAR
                if (NUM_solarpanels > 0)
        CAPEX_prod_solar_module_perW = 0.38;                                              % [EUR/W]
        CAPEX_prod_solar_BoS_perW = 0.34;                                                 % [EUR/W]
        
        PWfromSolar = max(row_pwfromsolar)*NUM_solarpanels;  
        CAPEX_prod_solar_module = CAPEX_prod_solar_module_perW*100*PWfromSolar;               % [EUR]
        CAPEX_prod_solar_BoS = CAPEX_prod_solar_BoS_perW*100*PWfromSolar;                     % [EUR]
        CAPEX_prod_solar_disposalcosts = 0.1671*100*PWfromSolar;
        CAPEX_prod_solar = (CAPEX_prod_solar_module + CAPEX_prod_solar_BoS + CAPEX_prod_solar_disposalcosts);
        fprintf('The capital expenditure for the solar module is %f euros. \n', CAPEX_prod_solar);
                else
                    CAPEX_prod_solar = 0;
                end
                
        % --- CAPEX WAVE
                    if (NUM_buoys > 0)
        CAPEX_prod_wave_projectdev_perW = 0.41;                        % [EUR/W]
        CAPEX_prod_wave_manufacturing_perW = 2.83;                     % [EUR/W]
        CAPEX_prod_wave_electricalconnection_perW = 0.79;              % [EUR/W]
        CAPEX_prod_wave_assembly_perW = 0.71;                          % [EUR/W]
        CAPEX_prod_wave_monitoring_perW = 0.09;                        % [EUR/W]

        PWfromWave = max(row_pwfromwave)*NUM_buoys;
        CAPEX_prod_wave_projectdev = CAPEX_prod_wave_projectdev_perW*30*PWfromWave;                          % [EUR]
        CAPEX_prod_wave_manufacturing = CAPEX_prod_wave_manufacturing_perW*30*PWfromWave;                    % [EUR]
        CAPEX_prod_wave_electricalconnection = CAPEX_prod_wave_electricalconnection_perW*30*PWfromWave;      % [EUR]
        CAPEX_prod_wave_assembly = CAPEX_prod_wave_assembly_perW*30*PWfromWave;                              % [EUR]
        CAPEX_prod_wave_monitoring = CAPEX_prod_wave_monitoring_perW*30*PWfromWave;                          % [EUR]
        CAPEX_prod_wave_disposalcosts = 822618.72*30*NUM_buoys;
        CAPEX_prod_wave = (CAPEX_prod_wave_projectdev + CAPEX_prod_wave_manufacturing + CAPEX_prod_wave_electricalconnection + CAPEX_prod_wave_assembly + CAPEX_prod_wave_monitoring);
        fprintf('The capital expenditure for the wave module is %f euros. \n', CAPEX_prod_wave);
        
                    else 
                        CAPEX_prod_wave = 0;
                    end
        
        % TOTAL CAPEX for production module
        CAPEX_cables_internally_to_GRID = TOT_length_grid_cables_E_to_HUB/1000*0.007*capacity_watt_km_cables_EtoH_wind;
        CAPEX_cables_HUB_to_SHORE = TOT_length_grid_cables_HUB_to_shore*0.007*capacity_watt_km_cables_HtoShore; % Green et al.       (0.007*capacity_watt_km_cables_HtoShore)
        
        
        CAPEX_prod = (CAPEX_prod_wind + CAPEX_prod_wave + CAPEX_prod_solar + CAPEX_cables_internally_to_GRID) + CAPEX_cables_HUB_to_SHORE;
        fprintf('The total capital expenditures are %f euros. \n', CAPEX_prod);
        
    % !OPEX!     
    if (NUM_windmills > 0)
        
        % --- OPEX WIND
        %YEARS_of_service_wind = vector_of_inputs(1,23);
        OPEX_prod_wind_operationsandplannedmaintenance_perW_perYEAR = 0.021;                          % [EUR/W/year]
        OPEX_prod_wind_unplannedservice_perW_perYEAR = 0.04;                                          % [EUR/W/year]

        OPEX_prod_wind_operationsandplannedmaintenance = OPEX_prod_wind_operationsandplannedmaintenance_perW_perYEAR*8000000*NUM_windmills;            % [EUR/year]
        OPEX_prod_wind_unplannedservice = OPEX_prod_wind_unplannedservice_perW_perYEAR*8000000*NUM_windmills;                                           % [EUR/year]

        OPEX_prod_wind = (OPEX_prod_wind_operationsandplannedmaintenance + OPEX_prod_wind_unplannedservice);
        fprintf('The operational expenditure for the wind module is %f euros. \n', OPEX_prod_wind);
    else 
        OPEX_prod_wind = 0;
    end
    
    % --- OPEX SOLAR
    if (NUM_solarpanels > 0)
        capacity_factor_solar = 0.35;
        %YEARS_of_service_solar = vector_of_inputs(1,24);
        OPEX_prod_solar_perW_perYEAR = 0.0095;                                            % [EUR/W/year]

        OPEX_prod_solar = (OPEX_prod_solar_perW_perYEAR*100*PWfromSolar);                 % [EUR/year]
        fprintf('The operational expenditure for the solar module is %f euros. \n', OPEX_prod_solar);
    else 
        OPEX_prod_solar = 0;
    end
    
    if (NUM_buoys > 0)
        %YEARS_of_service_wave = vector_of_inputs(1,25);
        OPEX_prod_wave_perW_perYEAR = 0.245;                                              % [EUR/W/year]

        OPEX_prod_wave = (OPEX_prod_wave_perW_perYEAR*30*PWfromWave);                     % [EUR/year]
        fprintf('The operational expenditure for the wave module is %f euros. \n', OPEX_prod_wave);
    else
        OPEX_prod_wave = 0;
    end
        % Total OPEX for production component
        OPEX_prod = (OPEX_prod_wind + OPEX_prod_solar + OPEX_prod_wave);                  % [EUR/year]
        fprintf('The total operational expenditures are %f euros. \n', OPEX_prod);

    % Storage Component - Cost Categories

        CAPEX_stor = (415000 + 160000)*power_to_be_filled_per_timestep/1000000;  % [EUR/W]  % Nikolaidis & Poullikkas, 2018
        OPEX_stor = 1.9*sum_total_stored_power/1000000 + 0.95*sum_total_stored_power/1000000;  % Zakeri & Syri, 2015 (Operation and Maintenance)

        additional_term = REVENUES_not_raised_asPwnotsold;
        
        % Fixed depends on how much you can store
        % Variable depends on how much it was stored
    if (NUM_batteries == 0)
        CAPEX_stor = 0;
        OPEX_stor = 0;
    end
    % FINAL STEP COST ANALYSIS:

    CAPEX = CAPEX_prod + CAPEX_stor;
    OPEX = OPEX_prod + OPEX_stor;
    fprintf('The total capex is %.2f. \n', CAPEX);
    fprintf('The total opex is %.2f. \n', OPEX);

% --- WACC

    inflation = 0.025;
    Rd = 0.024;
    Re = 0.01;
    tax_rate = 0.25;
    E = 0.15;
    D = 0.85;

    nominal_WACC = E/(E+D)*Re + D/(E+D)*Rd*(1-tax_rate);
    real_WACC = (1 + nominal_WACC)/(1+inflation) - 1;
    fprintf('The nominal WACC is equal to %f. \n', nominal_WACC);
    fprintf('The real WACC is equal to %f. \n', real_WACC);
    
% LCOE with storage

if (NUM_batteries > 0)
    LCOEwith_numerator_opex = zeros(1,lifetime_farm_opex);
    LCOEwith_numerator_capex = CAPEX_prod + CAPEX_stor - TOT_revenues_energysale_fromDraining*lifetime_farm_opex;
    for i = 1:lifetime_farm_opex
        LCOEwith_numerator_opex(1,i) = (OPEX_prod + OPEX_stor)/((1 + nominal_WACC)^i);
    end
    LCOEwith_numerator = LCOEwith_numerator_capex + sum(LCOEwith_numerator_opex);
    LCOEwith_denominator_power = zeros(1,lifetime_farm_opex);
    if (NUM_batteries == 0)
        sum_total_stored_power = 0;
    end
    for i = 1:lifetime_farm_opex
        LCOEwith_denominator_power(1,i) = (total_pw_output)/((1 + nominal_WACC)^i);
    end
    LCOEwith_denominator = sum(LCOEwith_denominator_power);
    LCOEwith = (LCOEwith_numerator/LCOEwith_denominator);
    fprintf('The LCOE with storage is equal to %.2f EUR/MWh. \n', LCOEwith*4);
end
    
% LCOE without storage    

    LCOEwithout_numerator_opex = zeros(1,lifetime_farm_opex);
    LCOEwithout_numerator_capex = CAPEX_prod;
    for i = 1:lifetime_farm_opex
        LCOEwithout_numerator_opex(1,i) = (OPEX_prod)/((1 + nominal_WACC)^i);
    end
    LCOEwithout_numerator = LCOEwithout_numerator_capex + sum(LCOEwithout_numerator_opex);
    LCOEwithout_denominator_power = zeros(1,lifetime_farm_opex);
    if (NUM_batteries == 0)
        sum_total_stored_power = 0;
    end
    for i = 1:lifetime_farm_opex
        LCOEwithout_denominator_power(1,i) = (total_pw_output)/((1 + nominal_WACC)^i);
    end
    LCOEwithout_denominator = sum(LCOEwithout_denominator_power);
    LCOEwithout = (LCOEwithout_numerator/LCOEwithout_denominator);
    fprintf('The LCOE without storage is equal to %.2f EUR/MWh. \n', LCOEwithout*4);    

    
% Plot the cable capacity versus the capacity that shall be needed
    NUM_iterations_vec = 1:NUM_iterations;
    NUM_elements_vec = 1:NUM_production_elements;
   
    figure
    grid on
    plot(vector_days,row_demand./1000000);
    xlabel('Days of the year') 
    ylabel('Power [MW]') 
    hold on
    plot(vector_days,TOT_power_output./1000000);
    hold off
    xlabel('Days of the year') 
    ylabel('Power [MW]') 
    title('Demand and Production comparison'); 
    
    figure
    grid on
    plot(vector_days,PminD./1000000);
    xlabel('Days of the year') 
    ylabel('Power [MW]') 
    title('Production minus Demand');     


% Brake Even Point:    
    
% costs_with_capex = CAPEX_stor + CAPEX_prod;
% costs_without_capex = CAPEX_prod;
% costs_with_opex = zeros(1,35);
% costs_without_opex = zeros(1,35);
% tot_revenues_with = zeros(1,35);
% tot_revenues_without = zeros(1,35);
% costs_with_opex(1,1) = OPEX_stor + OPEX_prod;
% costs_without_opex(1,1) = OPEX_prod;
% tot_revenues_with(1,1) = revenues_with_batt;
% tot_revenues_without(1,1) = revenues_without_batt;
% for i= 2:35
%     costs_with_opex(1,i) = costs_with_opex(1,i-1) + (OPEX_stor + OPEX_prod);
%     costs_without_opex(1,i) = costs_without_opex(1,i-1) + (OPEX_prod);
%     tot_revenues_with(1,i) = tot_revenues_with(1,i-1) + revenues_with_batt;
%     tot_revenues_without(1,i) = tot_revenues_without(1,i-1) + revenues_without_batt;
% end
 
% figure('Name','Brake Even Point - Case with Batteries');
% plot(costs_with_opex + costs_with_capex)
% hold on
% plot(tot_revenues_with)
% hold off
% figure('Name','Brake Even Point - Case without Batteries');
% plot(costs_without_opex + costs_without_capex)
% hold on
% plot(tot_revenues_without)
% hold off

% for i=1:25
%     if ((costs_with_opex(1,i) + costs_with_capex) == tot_revenues_with)
%         years_toBEP_with = i;
%     end
%     if ((costs_without_opex(1,i) + costs_without_capex) == tot_revenues_without)
%         years_toBEP_without = i;
%     end
% end
% fprintf('The BEP, if you deploy the batteries, is reached faster. \n');
 




