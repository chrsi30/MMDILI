
All code written by Markus Karlsson and editetd by Christian Simonsson 

%% This file suite include all the data, models, model parameters and MATLAB code to produce all figures
for the manuscript 

'Mathematical Models for Biomarker Calculation of Drug-Induced Liver Injury in Humans and Experi-mental 
Models Based on Gadoxetate Enhanced Magnetic Resonance Imaging'

Markus Karlsson, Christian Simonsson, Nils Dahlström, Gunnar Cedersund, Peter Lundberg* 


-- Overview --
The main directory contains: three subfolders and a matlab script ('Run.m')

The folder CODE, contains five subfolders: Common Code, PLOT, prefusion/sim and cost, Ulloa/sim and cost, and Whole-body.
The 'Common Code' folder contains functions/scripts for commonly used operations. The 'PLOT' folder contains all the scripts for plotting all manuscript figures (including supplementary figures). The 'prefusion/sim and cost' contains scripts for simulating the prefusion model. The 'Ulloa/sim and cost' contains scripts for simulating the Ulloa model. Lastly the 'Whole-body' folder contains scripts for simulating the whole-body model. 

The folder 'Data/Forsgren et al' contains our DCE-MRI signal intensity data, used in the manuscript. 

The folder Results contains all model parameter-sets. 

To plot the manuscript figures, simply run the 'Run.m' script (see sections below). 

-- Setup --
Before running any scripts the systems biology toolbox (http://www.sbtoolbox2.org/main.php) needs to be installed. 

To download the toolbox follow the link: http://www.sbtoolbox2.org/main.php?display=download&menu=download

For installation of the toolbox, please follow the guide found at : http://www.sbtoolbox2.org/main.php?display=installation&menu=installation


-- Simulating model and plotting corresponding figures -- 
To plot manuscript figures - Run the Run.m file and choose witch figures to plot. This will initiate the corresponding model simulations and plot the figures. 
 
 
--
Code used for parameter estimation and analysis is aviable upon request.

-- For questions --
*Contact: peter.lundberg@liu.se 
          gunnar.cedersund@liu.se
          christian.simonsson@liu.se
