bayesFloodStage

README file last updated by Christopher Piecuch, cpiecuch-at-whoi-dot-edu, Thu Mar 6 2025

Basic description

Citation

This code was generated to produce the results presented in the main text of:

Piecuch, C. G., S. B. Das, L. Gorrell, S. Dangendorf, B. D. Hamlington, P. R. Thompson, and T. Wahl, “Impact-Based Thresholds for Investigation of High-Tide FLooding in the United States”, Earth's Future, xxx.

Please cite this reference when using this code. 

Contents

Text files
•	Copyright: copyright statement
•	License: license statement

MATLAB .mat files
•	20240602_taskteam_regions.mat: latitude, longitude, name, id, region, and threshold information for all tide gauges from sweet et al. (2022)
•	allstations.mat (produced by generateResults.m): latitudes, longitudes, and ids of all stations 
•	clr0.mat: color map file
•	maindata.mat (produced by generateResults.m): main results shown in the text (produced by generateResults.m)
•	minorfloodstage.mat (produced by generateResults.m): latitudes, longitudes, ids, and nos and nws flood stages for locations with both
•	nxd.mat (produced by generateResults.m): latitude, longitude, name, id, nos/nws/Bayesian minor flood thresholds, and number of flooding days by year and tide gauge for each of the flood thresholds
•	experiment_floodstagepaper.mat (produced by bayes_main_code.m): Bayesian model solutions for minor flood stage

Main MATLAB .m files
•	bayes_main_code.m: Bayesian model code. Execute to produce posterior flood threshold solutions
•	generateResults.m: Generate results shown in the paper
  * This code outputs the .mat files allstations, maindata, minorfloodstage, and nxd
  * I've uploaded the versions of these .mat files that I produced and used for the paper
  * If you'd like to reproduce the results, uncomment the "%%% " code in this file
•	makePlots.m: Generate plots in the main text

Supporting MATLAB .m files
•	bayes_main_code_paper_loocv.m: Version of bayes_main_code used for leave-one-out cross validation
•	bayes_main_code_paper_lorocv.m: Version of bayes_main_code used for leave-one-region-out cross validation
•	delete_burn_in3.m: Delete burn in (called in bayes_main_code)
•	EarthDistances.m: Compute great-circle distance between latitudes and longitudes (called in bayes_main_code)
•	initialize_output_w2.m: Initialize posterior model output (called in bayes_main_code)
•	noaaDatums.m: Download tidal datums from NOAA (called in generateResults)
•	noaaFlood.m: Download flood stages from NOAA (called in generateResults)
•	noaaSealevel.m: Download hourly tide gauge water level data from NOAA (called in generateResults)
•	set_hyperparameters4.m: Set hyperparameters in Bayesian model code (called in bayes_main_code)
•	set_initial_values3.m: Set initial conditions in Bayesian model code (called in bayes_main_code)
•	update_all_arrays3.m: Update model output for each iteration of the Metropolis sampler in Bayesian model code (called in bayes_main_code)

Subdirectories (each with readme files)
•	bayes_model_solutions: Bayesian model solutions for minor flood thresholds presented in the paper


Note on usage of code and MATLAB release
This code was written and executed (to produce results in Piecuch et al. 2025) using the MATLAB release version MATLAB_R2024a.   
