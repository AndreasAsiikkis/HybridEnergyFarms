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
### 1.1 Hybrid Energy Farms
<p align="justify">Hybrid energy farms consist of multiple power generation technologies such as wind turbines, wave energy converters and solar panels. In addition, the present model's hybrid farm incorporates an innovative storage technology called the Ocean Battery (OB).

The OB technology [1] is a form of a pumped hydro storage system that uses underwater flexible bladders to store water and generate electricity when needed. The system works by pumping water from a rigid reservoir into the flexible bladder on the seabed, where it is stored as potential energy in the form of water under high pressure due to the hydrostatic pressure. When energy is needed, the water is released from the bladders back into the rigid reservoirs, driving hydro turbines that generate electricity. This technology has the potential to provide scalable and eco-friendly utility scale energy storage from renewable sources such as wind turbines, floating solar farms and wave energy converters in the ocean.

HybridEnergyFarms is a toolkit presented in [2] that offers a modular and integrated model, demonstrating how the Ocean Battery interacts with offshore power plants that utilize any combination of three energy production sources, namely wind, solar, and wave.</p>

### 1.2 Model Structure
<p align="justify">The techno-financial model is composed of two constituents: the Power Model, modelled in Simulink; the Cost Model, designed within MATLAB. The main features of these models are shown in Figure 1.

Regarding the Power Model, blocks available within Simulink libraries were associated to reproduce the three power generation processes. Peculiarly, with respect to the wind power generation, models available in the Mathworks library were re-adapted [3]. On the other hand, the Solar panel was modelled by associating 54 solar photo-voltaic cells, as presented in relevant literature [4]. The Power Model receives the relevant input data for Solar, Wind and Wave power production from excel files.

The Cost Model combines a wide set of inputs, entered by the user from the file "inputs.m", with the produced power and demand trends attained from the Power Model. Such integration allows the Cost model to rely on multiple functions in order to conclude the simulation by assessing the Levelized Cost Of Energy (LCOE) and a new key performance index termed the Levelized Cost of Ocean Grazer (LCOG) for the given farm characterization. Specifically, the Cost Model makes use of a series of functions, ranging from the assessment on the power acceptability with respect to the cables to the price of energy per time step. Additionally, the Cost Model encapsulates dynamical behaviors such as the energy market and the storage charging and discharging.</p>

![Figure1](https://user-images.githubusercontent.com/51987477/226570095-e118141d-8df0-49eb-a9c1-77e6b51c99d7.png)

###### Figure 1: Key features of the two sub-components of the Techno-Financial model, namely: the Power model and the Cost model.

### 1.3 Inputs, Outputs and Controls (IOCs)
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
