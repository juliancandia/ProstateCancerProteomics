
import excel "~\git\ProstateCancerProteomics\DATA\biologicalprocess_clinicaldemo_survival_cases.xlsx", sheet("vars") firstrow clear /*replace this line with your local path*/

********************************** Overall Survival ******************************************************************************************************
stset SurvivalDx_months_2018, failure(survival_2018==1)
*Unadjusted Hazard Ratio
stcox apoptosis_averagezscore autophagy_averagezscore chemotaxis_averagezscore promoteTI_averagezscore suppressTI_averagezscore vasculature_averagezscore  if study=="NCI-MD"  
 *Adjusted Hazard Ratio 
stcox apoptosis_averagezscore autophagy_averagezscore chemotaxis_averagezscore promoteTI_averagezscore suppressTI_averagezscore vasculature_averagezscore age_quart bmi education_NCIMD_imp aspirin diabetes smoke_imp treatment race_num income_imp if study=="NCI-MD"
stcox apoptosis_averagezscore autophagy_averagezscore chemotaxis_averagezscore promoteTI_averagezscore suppressTI_averagezscore vasculature_averagezscore age_quart bmi education_NCIMD_imp aspirin diabetes smoke_imp treatment race_num income_imp if study=="NCI-MD", level(99)

********************************** Prostate Cancer Specific Survival **************************************************************************************
stset SurvivalDx_months_2018, failure(prostate_survival_2018==1)
*** Unadjusted Hazard Ratio
 stcox apoptosis_averagezscore autophagy_averagezscore chemotaxis_averagezscore promoteTI_averagezscore suppressTI_averagezscore vasculature_averagezscore  if study=="NCI-MD" 
 ***Adjusted Hazard Ratio 
stcox apoptosis_averagezscore autophagy_averagezscore chemotaxis_averagezscore promoteTI_averagezscore suppressTI_averagezscore vasculature_averagezscore age_quart bmi education_NCIMD_imp aspirin diabetes smoke_imp treatment race_num income_imp if study=="NCI-MD"
stcox apoptosis_averagezscore autophagy_averagezscore chemotaxis_averagezscore promoteTI_averagezscore suppressTI_averagezscore vasculature_averagezscore age_quart bmi education_NCIMD_imp aspirin diabetes smoke_imp treatment race_num income_imp if study=="NCI-MD", level(99)

**********************************  Cancer Mortality ******************************************************************************************************
stset SurvivalDx_months_2018, failure( cancer_survival_2018==1)
*** Unadjusted Hazard Ratio
stcox apoptosis_averagezscore autophagy_averagezscore chemotaxis_averagezscore promoteTI_averagezscore suppressTI_averagezscore vasculature_averagezscore  if study=="NCI-MD" 
 ***Adjusted Hazard Ratio 
stcox apoptosis_averagezscore autophagy_averagezscore chemotaxis_averagezscore promoteTI_averagezscore suppressTI_averagezscore vasculature_averagezscore age_quart bmi education_NCIMD_imp aspirin diabetes smoke_imp treatment race_num income_imp if study=="NCI-MD"
stcox apoptosis_averagezscore autophagy_averagezscore chemotaxis_averagezscore promoteTI_averagezscore suppressTI_averagezscore vasculature_averagezscore age_quart bmi education_NCIMD_imp aspirin diabetes smoke_imp treatment race_num income_imp if study=="NCI-MD", level(99)


