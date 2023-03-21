function [input_vector] = inputs(NUM_inputs)

input_vector = zeros(1,NUM_inputs); 

% Offshore farm characterization ------------------------------------------

    % How many MWs would you like the farm to generate?
    input_vector(1,1) = 750; % desired generation
    % Do you want to include a wind production module?
    input_vector(1,2) = 1; % if = 1, module present; 0 otherwise.
    % Do you want to include a solar production module?
    input_vector(1,3) = 1; % if = 1, module present; 0 otherwise.
        % Which is the surface of each solar panel? [m^2]
        input_vector(1,53) = 1;
    % Do you want to include a wave production module?
    input_vector(1,4) = 1; % if = 1, module present; 0 otherwise.
    % Do you want to include storage (Ocean Battery)?
    input_vector(1,5) = 1; % if = 1, module present; 0 otherwise.
    % Which time window do you want to analyze? Type the number of months.
    input_vector(1,10) = 12;
        % Therefore, the number of days is equal to:
        input_vector(1,33) = floor(input_vector(1,10)*30.45);
    % Which is the time step you want to analyze? Type the number of minutes. [min]
    input_vector(1,11) = 15;
        time_ratio = 60/input_vector(1,11);
        % Therefore the number of iterations is equal to:
        input_vector(1,12) = floor(input_vector(1,10)*30.4167*24*time_ratio);
        % Therefore the number of days simulated is equal to:
        input_vector(1,13) = floor(input_vector(1,10)*30.4167);
    % How much do you think you need to invest? Type the amount in mln EUR.
    input_vector(1,14) = 525;
    % How much energy capacity for the single Ocean Battery [Wh]
    input_vector(1,15) = 2440000;
        % Therefore:
        input_vector(1,46) = input_vector(1,15)/3600; % [W]
        % Therefore, the power capacity for the Single Ocean Battery per iteration is:
        input_vector(1,51) = input_vector(1,46)*60*input_vector(1,11);
%     % How much power does the turbine generate? [W]
%     input_vector(1,52) = 1000000;
    % The power capacity per iteration for the single Ocean Battery is: [W]
    input_vector(1,30) = input_vector(1,15)/0.75; % input_vector(1,15)*(input_vector(1,11)/60); %(input_vector(1,15)*60/input_vector(1,11);)
        % Therefore, the Battery drains completely in: [hrs]
        input_vector(1,52) = input_vector(1,15)/input_vector(1,52);
    % What is the efficiency of the pump?
    input_vector(1,31) = 0.9;
    % What is the efficiency of the turbine?
    input_vector(1,32) = 0.9;
    % Which is the factor you want to divide the Demand for?
    input_vector(1,45) = 26;  % Type 30 for the case of Wind offshore farm (64 0 0 77 2 25).
    % How far is the hub from the shore?
    input_vector(1,46) = 20; % [Km]
    
    % Cables - Elements to hub:
        % Which cables? -> Prysmian, copper, flat distribution, 800 mm^2 of
        % cross sectional area, resistance 0,20 Ohm/Km, capacity 955
        % Ampere. - DC
        input_vector(1,16) = 955;          % [A]
        input_vector(1,17) = 0.20;         % [Ohm/km]
        input_vector(1,18) = 50;           % [Km] - Cables' tot length
        % Therefore, the accepted power is equal to:
        input_vector(1,19) = ((input_vector(1,16))^2)*input_vector(1,17)*input_vector(1,18);  % [W]
        input_vector(1,20) = 55*((input_vector(1,16))^2)*input_vector(1,17);  % [W/Km] for wind
        input_vector(1,49) = ((input_vector(1,16))^2)*input_vector(1,17);  % [W/Km] for solar
        input_vector(1,50) = 10*((input_vector(1,16))^2)*input_vector(1,17);  % [W/Km] for wave
        
    % Cables - Elements to storage:
        % Which cables? -> Prysmian, copper, flat distribution, 800 mm^2 of
        % cross sectional area, resistance 0,20 Ohm/Km, capacity 955
        % Ampere. - DC
        input_vector(1,35) = 955;          % [A]
        input_vector(1,36) = 0.20;         % [Ohm/km]
        input_vector(1,37) = 50;           % [Km] - Cables' tot length
        % Therefore, the accepted power is equal to:
        input_vector(1,38) = ((input_vector(1,35))^2)*input_vector(1,36)*input_vector(1,37);  % [W]
        input_vector(1,39) = 10*((input_vector(1,35))^2)*input_vector(1,36);  % [W/Km] for wind
        input_vector(1,47) = ((input_vector(1,35))^2)*input_vector(1,36);  % [W/Km] for solar
        input_vector(1,48) = 10*((input_vector(1,35))^2)*input_vector(1,36);  % [W/Km] for wave
    % Cables - Hubs to shore:
        % Which cables? -> Prysmian, copper, flat distribution, 800 mm^2 of
        % cross sectional area, resistance 0,20 Ohm/Km, capacity 955
        % Ampere. - DC
        input_vector(1,40) = 955;          % [A]
        input_vector(1,41) = 0.20;         % [Ohm/km]
        input_vector(1,42) = 50;           % [Km] - Cables' tot length
        % Therefore, the accepted power is equal to:
        input_vector(1,43) = 1000*((input_vector(1,40))^2)*input_vector(1,41)*input_vector(1,42);  % [W]
        input_vector(1,44) = 2500*((input_vector(1,40))^2)*input_vector(1,41);  % [W/Km]
        
        
   % Turbine
        % What is the maximum rpm of the pump?
        input_vector(1,29) = 750;          % [rev/min or rpm] 
    % Market:
        % Agreement with TenneT? Type 1 for agreement between BRP and
        % TenneT. Type 0 otherwise.
        input_vector(1,21) = 1;
        
    % Opex:
        % How many year of service for the components?
        input_vector(1,23) = 35;  % wind
        input_vector(1,24) = 19;  % solar
        input_vector(1,25) = 20;  % wave
        
    % Hydraulic head   http://web.engr.oregonstate.edu/~webbky/ESE471_files/Section%203%20Pumped%20Hydro.pdf
                     % https://arena.gov.au/assets/2018/10/ANU-STORES-An-Atlas-of-Pumped-Hydro-Energy-Storage-The-Complete-Atlas.pdf
        % How many Hectars?
        input_vector(1,54) = 0.005;
        % How many meters deep?
        input_vector(1,55) = 30;
        % Then, the used liters of water are:
        input_vector(1,56) = input_vector(1,54)*10000*(85/100)*input_vector(1,55)*1000;
        % What is the hydraulic head?
        input_vector(1,57) = 25;
        % Then, the effective storage capacity is equal to:
        input_vector(1,58) = input_vector(1,56)*9.8*input_vector(1,57)*input_vector(1,31)*input_vector(1,32);
end

            
    
    
    
    
    