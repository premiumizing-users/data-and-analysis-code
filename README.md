# "Premiumizing" Users: Sales Strategies in Mobile Games - Data and Analysis Code

This repository contains code and data (as can be made available) for the research project "'Premiumizing' Users: Sales Strategies in Mobile Games". Please note that identifying information such as game, company, and product names were removed from the code displayed here for confidentiality reasons. The individual experiment folders in this repository contain the SQL code used to extract the data from the company's databases and the R code used to further process and manipulate the raw data.

The data for this research project are subject to a non-disclosure agreement with the industry partner as it contains sensitive customer and company information. We are hence unable to make user-level data publicly available as these were deemed too sensitive by the industry partner. Instead, we can provide the data aggregated to the segment-level as mean and standard deviation for all variables / columns used in the analysis in one zip archive. The main repository folder has the R file used to aggregate this shareable data. Please contact the authors to obtain a copy of this archive. It must be deleted upon completion of your analysis / replication. 

The shareable archive comprises a dataset for each of Experiment 1, 2, and 3b and six datasets for Experiment 3a. The datasets for Experiments 1, 2, and 3b are named experiment1_data_aggregated.csv, experiment2_data_aggregated.csv, and experiment3b_data_aggregated.csv. Experiment 3a of the study repeats the same experiment six times along the days of users' experience in the app, starting on users' second day after first app use ("d2). The last "sub-experiment" happens on users' 12th day in the app ("d12"). The respective datasets for the sub-experiments are named experiment3a_d2_data_aggregated.csv, experiment3a_d4_data_aggregated.csv, experiment3a_d6_data_aggregated.csv, experiment3a_d8_data_aggregated.csv, experiment3a_d10_data_aggregated.csv, experiment3a_d12_data_aggregated.csv. 

The R code used for analysis can be chiefly found in the file main_analysis.R in the main repository folder. The R file for the randomization checks for Experiments 1, 2, and 3b (shown in Web Appendix WA2 of the paper) can also be found there. The analysis and randomization checks for the price path sub-experiments along days of the user experience (Experiment 3a) can be found in the sub-folder for that experiment and not in the main folder. In addition, there is a folder showing the code and data for the merging of the GDP per capita data and the code for the non-parametric assessment of heterogeneous treatment effects in device memory and GDP per capita (Section 6.3 and Web Appendix WA7 of the paper).

Please reach out to the authors in case of questions.
