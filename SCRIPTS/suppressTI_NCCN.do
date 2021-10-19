import excel "~\git\ProstateCancerProteomics\RESULTS\original_data_BPaveragezscores.xlsx", sheet("Sheet1") firstrow

***grouping suppressTI scores into low and high with cutoffs determined using the distribution of the score among controls
pctile suppressTI_averagezscore_pct= suppressTI_averagezscore if case==0 & study=="NCI-MD", nq(2)
xtile q2_suppressTI_averagezscore = suppressTI_averagezscore if study=="NCI-MD" & case==1, cutpoints(suppressTI_averagezscore_pct)
bys q2_suppressTI_averagezscore: tabstat suppressTI_averagezscore, stats(n min max)
drop suppressTI_averagezscore_pct

replace q2_suppressTI_averagezscore=0 if q2_suppressTI_averagezscore==1
replace q2_suppressTI_averagezscore=1 if q2_suppressTI_averagezscore==2

***logistic regression for all cases***
logistic q2_suppressTI_averagezscore i.NCCN age_quart bmi education_NCIMD_imp aspirin diabetes smoke_imp treatment race_num income_imp if study=="NCI-MD"
logistic q2_suppressTI_averagezscore NCCN age_quart bmi education_NCIMD_imp aspirin diabetes smoke_imp treatment race_num income_imp if study=="NCI-MD"

***logistic regression for African American cases***
logistic q2_suppressTI_averagezscore i.NCCN age_quart bmi education_NCIMD_imp aspirin diabetes smoke_imp treatment income_imp if study=="NCI-MD" & race=="African American"
logistic q2_suppressTI_averagezscore NCCN age_quart bmi education_NCIMD_imp aspirin diabetes smoke_imp treatment  income_imp if study=="NCI-MD" & race=="African American"

***logistic regression for European American cases***
logistic q2_suppressTI_averagezscore i.NCCN age_quart bmi education_NCIMD_imp aspirin diabetes smoke_imp treatment  income_imp if study=="NCI-MD" & race=="European American"
logistic q2_suppressTI_averagezscore NCCN age_quart bmi education_NCIMD_imp aspirin diabetes smoke_imp treatment  income_imp if study=="NCI-MD" & race=="European American"
