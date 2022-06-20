clear all
close all
clc

warning 'off'

addpath('..');


msg = "What figure to plot?";
opts = ["Figure 2" ....
        "Figure 3" ....
        "Figure 4" ....
        "Figure 5" ....
        "Figure 6" ...
        "Figure SI" ];

choice = menu(msg,opts);

try

if     choice == 1 
%% Figure 2
addpath('./CODE/PLOT/Figure 2')
figure2_plotCorrelationNILB

elseif choice == 2
%% Figure 3
addpath('./CODE/PLOT/Figure 3')
figure3_plotCorrelationAZ_Individual

elseif choice == 3
%% Figure 4
addpath('./CODE/PLOT/Figure 4')
figure4_plotPLForPaper2

elseif choice == 4
%% Figure 5
addpath('./CODE/PLOT/Figure 5')
figure5_runDR
elseif choice == 5
%% Figure 6
addpath('./CODE/PLOT/Figure 6')
figure(1); runDrugPrediction
figure(2); makeFigure6_Efficacy
figure(3); makeFigure6_NILB
figure(4); makeFigure6DR
figure(5); makeFigure6DR_zoomed

elseif choice == 6
addpath('./CODE/PLOT/Figure SI')
calc_PL_CI_overlap_Ki
calc_PL_CI_overlap_Ke
end
catch err
   close all 
   disp(err)
   disp("The systems biology toolbox (http://www.sbtoolbox2.org/main.php) is necessary to run the scripts in this project.")
   disp("It must be compiled and added to the MATLAB path before the scripts are run.")
end
