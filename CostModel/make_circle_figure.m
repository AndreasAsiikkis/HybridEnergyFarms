close all; clear all;

%% load power difference for each floater in the case 1
load('sustainedcapacityEtoS.mat','sustained_EtoS_vector_perelement')
load('GeneralModel.mat','NUM_windmills','NUM_buoys','NUM_solarpanels','x_windmills',x_windmills)
%% define variables necessary for plot_circle
FB.CG= CG;

%% make plot_circle

figure(1)
plot_circle(sustained_EtoS_vector_perelements); hold on
title('Sustained power [%]')



