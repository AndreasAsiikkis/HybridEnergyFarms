# HybridEnergyFarms


![HybridEnergyFarms](https://user-images.githubusercontent.com/51987477/226568297-77d5f47b-a30d-4ef1-9a24-e4167bc38ed2.png "HybridEnergyFarms")



## Authors of the documentation
- Andreas T. Asiikkis
- Andrea Di Modugno
- Antonis I. Vakis

## Code Developed by
- Andrea Di Modugno


<div align="right">

Engineering and Technology Institute Groningen (ENTEG)  
Faculty of Science and Engineering (FSE)  
University of Groningen (RUG)  
Groningen, The Netherlands  
February, 2023

</div>


## 1. Introduction
### 1.1. Hybrid Energy Farms
<p align="justify">Hybrid energy farms consist of multiple power generation technologies such as wind turbines, wave energy converters and solar panels. In addition, the present model's hybrid farm incorporates an innovative storage technology called the Ocean Battery (OB).

The OB technology [1] is a form of a pumped hydro storage system that uses underwater flexible bladders to store water and generate electricity when needed. The system works by pumping water from a rigid reservoir into the flexible bladder on the seabed, where it is stored as potential energy in the form of water under high pressure due to the hydrostatic pressure. When energy is needed, the water is released from the bladders back into the rigid reservoirs, driving hydro turbines that generate electricity. This technology has the potential to provide scalable and eco-friendly utility scale energy storage from renewable sources such as wind turbines, floating solar farms and wave energy converters in the ocean.

HybridEnergyFarms is a toolkit presented in [2] that offers a modular and integrated model, demonstrating how the Ocean Battery interacts with offshore power plants that utilize any combination of three energy production sources, namely wind, solar, and wave.</p>

### 1.2. Model Structure
<p align="justify">The techno-financial model is composed of two constituents: the Power Model, modelled in Simulink; the Cost Model, designed within MATLAB. The main features of these models are shown in Figure 1.

Regarding the Power Model, blocks available within Simulink libraries were associated to reproduce the three power generation processes. Peculiarly, with respect to the wind power generation, models available in the Mathworks library were re-adapted [3]. On the other hand, the Solar panel was modelled by associating 54 solar photo-voltaic cells, as presented in relevant literature [4]. The Power Model receives the relevant input data for Solar, Wind and Wave power production from excel files.

The Cost Model combines a wide set of inputs, entered by the user from the file "inputs.m", with the produced power and demand trends attained from the Power Model. Such integration allows the Cost model to rely on multiple functions in order to conclude the simulation by assessing the Levelized Cost Of Energy (LCOE) and a new key performance index termed the Levelized Cost of Ocean Grazer (LCOG) for the given farm characterization. Specifically, the Cost Model makes use of a series of functions, ranging from the assessment on the power acceptability with respect to the cables to the price of energy per time step. Additionally, the Cost Model encapsulates dynamical behaviors such as the energy market and the storage charging and discharging.</p>

![Figure1](https://user-images.githubusercontent.com/51987477/226570095-e118141d-8df0-49eb-a9c1-77e6b51c99d7.png)

###### Figure 1: Key features of the two sub-components of the Techno-Financial model, namely: the Power model and the Cost model.

### 1.3. Inputs, Outputs and Controls (IOCs)
<p align="justify">The present section describes the inputs, outputs and controls, the so-called IOCs. As shown in Figure 2, the designed Techno-Financial Model has the purpose of producing a profitability assessment of an offshore hybrid integration farm based on both the farm's geographical location as well as on the farm characterization. As anticipated in Figure 1, the developed model acquires as inputs four datasheets: the power demand, the generated power per buoy, the average wind speed pattern and the sun irradiation. These data sheets are dependent on the selection of a specific location. For instance, the average value related to the sun irradiation ([W/m2]) may differ across geographical domains. These four input databases shall be two-columns arrays, where the number of rows reflects the simulation time as well as the time discreteness. The first column shall represent the simulation time step; on the other hand, the second column of each of these datasheets contains the relevant characteristic values: wind speed, solar panel voltage, power per buoy and sun irradiation.

Since the Techno-Financial Model produces a profitability assessment of the selected grid characterization, the LCOE and the LCOG of the farm are the overall outputs of the model. These results can vary based on the type of farm. Therefore, the Techno-Financial Model allows to accurately pre-select the farm characterization based on the project to be investigated. In fact, as shown in Figure 2, the cardinality of each farm component is set as control of the model: by changing these values, the attained profitability indices may differ. The selection of the control values is allowed at the Cost Model simulation incipit. This feature allows the model to display complete modularity and versatility.</p>

![Figure2](https://user-images.githubusercontent.com/51987477/226570435-7e0e0f5e-ed61-4d4c-a307-c5859949a91d.png)

###### Figure 2: Inputs, Outputs, and Controls of the Techno-Financial model.

## 2. Installation
<p align="justify">The HybridEnergyFarms toolkit runs within the MATLAB environment and consists of a Simulink model and MATLAB scripts. All the required files, except the MATLAB software and the relevant Add-Ons, can be downloaded through the WEBSITE(GitHub). Within these files, an example to run the model is already in place, and the relevant input files can be modified to run another case.</p>

<ins>Requirements</ins> 

- MATLAB R2022b or later (can be downloaded through: https://www.mathworks.com/products/matlab.html)
- Simulink (MATLAB Add-On). Can be downloaded with MATLAB.
-	Simscape Electrical (MATLAB Add-On). Can be downloaded with MATLAB.
-	A folder called HybridEnergyFarms which includes the following folders/files:
  -	Folder called PowerModel:
    -	EemshavenWavePerBuoySheet3.xlsx
    -	EemshavenWindspeedSheet6.xlsx
    -	EemshavenSunIrradSheet5.xlsx
    -	EemshavenVoltageSheet4.xlsx
    -	Copy of DemandSheet5.xlsx
    -	HybridIntegrationEemshaven.slxc
  - Folder Called CostModel
    - GeneralModel.m
    - ustainedcapacityHtoShore.m
    - sustainedcapacityEtoH.m
    - physicalcapacityEtoH.m
    - sustainedcapacityStoH.m
    - cablesmatrix.m
    - cablesmatrixtohub.m
    - caseNObattery.m
    - physicalcapacityEtoS.m
    - sold.m
    - cablesmatrix_StoH.m
    - physicalcapacityHtoShore.m
    - caseYESbattery.m
    - sold_toshore.m
    - circles.m
    - make_circle_figure.m
    - plot_circle.m
    - workspacestart.mat
    - energypriceperW.m
    - sustainedcapacityEtoS.m
    - inputs.m
    - physicalcablescapacity_STORtoHUB.m
    - AFRRmarket.m
  - Folder called Images:
    - PowerAnalysis.PNG
    - Waves.jpg
    - Panels.jpg
    - ProductionModules.png
    - OceanBattery.jpg
    - WindPower.PNG
    - WavePower.jpeg
    - PanelsInputData.jpg


## 3. Input files explained
### 3.1. Power Model files
<p align="justify">The file "workspacestart.m" contains the workspace of the variable which are crucial for the model of the wind turbine. The file "HybridIntegrationEemshaven.slx" represents the Power Model of the hybrid integration for the investigation of offshore Eemshaven as a location and refers to the files: "EemshavenWindspeedSheet6.xls", "EemshavenWavePerBuoySheet5.xls", "Eemshaven- VoltageSheet4.xls", "EemshavenSunIrradSheet5.xls", "Copy of DemandSheet5.xls" as input datasheets. These Excel files are built as 35515 x 2 arrays: the first column represents the time step, which is updated with a cadence of 0.05 s; the second column represents the value of the respective quantity. For those datasheets containing multiple sheets, only the sheets indicated within the Excel files' name must be consulted.
  
The Power Model is versatile to any simulation period and simulation time step. The simulation time step must be consistent with the time step in the Excel datasheets. In the used datasheets, for instance, as the first column represents the simulation time step, these are built with a 0.05 s time step. The latter value is chosen for a specific reason. In fact, it must coincide with the Power Model time step of simulation: 0.05 s. As the Power Model simulation was conducted with a stop time of 1756.5 s, it is immediate to calculate that 35151 steps are analyzed. If 15 minutes in reality are compared to 0.05 s in the simulation, the total simulation time of 1756.5 s would equal approximately 365 days. This allows the Power Model to simulate and produce yearly power outputs. In particular, the time step of 15 minutes is selected since it was addressed in previous investigations as the most appropriate to analyze the Battery's behavior with [5]. It must be specified that the Power Model expects the generated power per buoy database to contain the power generated per buoy, to be previously calculated based on the wave height for the given location. This is motivated by the fact that the Wave Power Production block was left as a black box.</p>

### 3.2. Cost Model files
<p align="justify">All MATLAB files are properly commented to allow the user a smooth understanding of the represented processes. Here, the key aspects of each of the enlisted files are reported. The file "GeneralModel.m" represents the main file of the Cost Model. All the other files are functions, which are contained within, called from and executed during the run of the "GeneralModel.m". The file "inputs.m" contains a wide set of inputs which influence the model's behavior, such as: Ocean Battery capacity, turbine power, time step, time window to be simulated, number of iterations, cables' characterization, etc. The files "caseYESbattery.m" and "caseNObattery.m" contain the functions which perform the analysis for the cases of Battery(ies) deployed and storage absent, respectively. Files "sold_toshore.m" and "sold.m" calculate respectively the power amounts transferred to the hub and the power amount transferred to the shore. The files "cablesmatrix_StoH.m", "cablesmatrix.m", "cablesmatrixtohub.m", calculate the length of the grid cables based on the element placement operated during the initial stages of the "GeneralModel.m" simulations. The functions "physicalcapacityEtoH.m", "physicalcapacityEtoS.m", "physicalcablescapacity_STORtoHUB.m", "physicalcapacityHtoShore.m" store the information of cables capacities for each grid connection present within the farm. Subsequently, "sustainedcapacityHtoShore.m", "sustainedcapacityEtoS.m", "sustainedcapacityEtoH.m", "sustainedcapacityStoH.m" assess whether the hypothesized transmitted power across cables could be effectively sustained by the respective cables. The files "AFRRmarket.m" and "energypriceperW.m" respectively model the demand and produced power forecasts (useful for establishing the actual energy price) and the price of the power per watt, based on the previously obtained forecasts. The files "plot_circle.m", "make_circle_figure.m" and "circles.m" allow to draw the topology mapping tools within the "GeneralModel.m" simulation.</p>

## 4. User Guide
<p align="justify">As explained in 1.2, the designed Techno-Financial Model is composed of two different blocks: the Power Model and the Cost Model. For the model to properly function, the simulation of the former must be initially run, whereas the latter must follow. In fact, in order to produce results, the Cost Model requires data which are generated by the Power Model. In the present section, the detailed sequence of actions to be performed by the user to allow the model to accurately function is described.</p>

### 4.1. Power Model Simulation
- Open MATLAB, which hosts both the simulations. Since the Power Model is engineered within Simulink, once MATLAB has opened, Simulink must be launched. In MATLAB, locate the directory HybridEnergyFarms, set it as the current folder and add all its subfolders to path by right-clicking on the folder and then "Add to Path → Selected Folders and Subfolders".
- Load the file "workspacestart.mat".
- Open the file "HybridIntegrationEemshaven.slx" located in the folder "PowerModel". Figure 3 shows the Power Analysis block which shows up. Double-click on this block to open it. Other Simulink blocks show up as indicated in Figure 4.

<img width="445" alt="Figure1 1" src="https://user-images.githubusercontent.com/51987477/226574156-c5f8dd37-d795-4f99-b655-00616bba4869.PNG">
###### Figure 3: Power Analysis block in the file HybridIntegrationEemshaven.slx.

<img width="830" alt="Figure1 2" src="https://user-images.githubusercontent.com/51987477/226574380-e4c4da51-dc18-4974-a2ba-d6413b2b832e.PNG">
###### Figure 4: Simulink blocks for the Power Model.

- Double-click on Wave Power Input Data block to specify the related excel file for the power per buoy. Double-click on the Panels Input Data to specify the related excel files for the sun irradiation and the solar panel voltage. Double-click on the Production Modules block and then on the Wind Power Production block (see Figure 5) to specify the speed of the wind. Finally, double-click on the Ocean Battery block to specify the excel file related to the power demand.

<img width="993" alt="Figure1 3" src="https://user-images.githubusercontent.com/51987477/226574564-5baa3240-6a2b-40ca-bf98-3806336e07f1.PNG">
###### Figure 5: Simulink blocks within the Production Modules block.

- The Power Model is set-up. Click Run in the Simulation tab of Simulink to simulate the model.

### 4.2. Cost Model Simulation
- Without clearing the data generated by the Power Model simulation, continue by opening the file "inputs.m" and modify it according to the needs of your project. Click save.
- Then, open the file "GeneralModel.m" and in the Editor tab of MATLAB, click Run.
- A small window pops up as shown in Figure 6 asking for the number of windmills, solar arrays, WEC arrays, Batteries and hubs and the length of the grid. Specify the relevant values and click OK.

![image](https://user-images.githubusercontent.com/51987477/226574940-bfb83903-b630-451d-82c6-0f8eb7c5a98b.png)
###### Figure 6: Grid Characterization for the Cost Model.

- Then, a figure shows up, as illustrated in Figure 7, where the placement of all the windmills, solar panels, buoys, ocean batteries and hubs need to be specified by clicking throughout the figure.

![image](https://user-images.githubusercontent.com/51987477/226575043-cd5755fc-89ea-4e75-ab9e-2e88d4d85410.png)
###### Figure 7: Specifying the placement of windmills, solar panels, buoys, ocean batteries and hubs.

- When all the elements (i.e., windmills, solar panels etc.) are defined, the Cost Model runs automatically, and the results are presented through figures and the command window.

## 5.	Contact Information
Prof. dr. A.I. (Antonis) Vakis  
University of Groningen, FSE-ENTEG-CMME  
Room 5113.0042, Nijenborg 4, Groningen, the Netherlands  
[https://sites.google.com/view/avakis](https://sites.google.com/view/avakis)

## 6.	References
[1] 	"OCEAN BATTERY," Ocean Grazer B.V., 2023. [Online]. Available: https://oceangrazer.com/.

[2] 	A. D. Modugno, "A Techno-Financial Model of Ocean Grazer's Hybrid Integration Proposing the Ocean Battery as Deployable On-site Storage Profitability Optimizer for Offshore Renewable Production Plants," University of Groningen, MSc Thesis, Groningen, 2021.

[3] 	MATLAB, "Three-Phase Asynchronous Wind Turbine Generator," [Online]. Available: https://www.mathworks.com/help/sps/ug/three-phase-asynchronous-wind-turbine-generator.html.

[4] 	T. Salmi, M. Bouzguenda, A. Gastli and A. Masmoudi, "MATLAB/Simulink Based Modelling of Solar," International Journal of Renewable Energy Research, vol. 2, no. 2, pp. 213-218, 2012.

[5] 	H. Bijl, "Techno-economic analysis of energy storage systems for offshore wind farms," University of Groningen, MSc Thesis, Groningen, 2019.
