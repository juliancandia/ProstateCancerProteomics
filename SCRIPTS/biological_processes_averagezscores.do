

import excel "~\git\ProstateCancerProteomics\DATA\original_data.xlsx", sheet("vars") firstrow clear /*replace this line with your local path*/

*****To tag each of the immune-oncological proteins using a prefix a_
foreach v of var IL8-LAPTGFbeta1 {
	rename `v' a_`v' 
		}		
*****To calculate z scores for each of the proteins
findit zscore /*install the zscore package from stata*/

foreach v of var a_* {
zscore `v'
}
*****To generate average z scores for each of the biological processes 
*Autophagy
gen autophagy_sumzscore= z_a_HO1 + z_a_CAIX + z_a_ADA 
gen autophagy_averagezscore= (autophagy_sumzscore)/3

*Apoptosis
gen apoptosis_sumzscore= z_a_CASP8 + z_a_CD40L + z_a_FASLG + z_a_Gal9 + z_a_GZMA + z_a_GZMB + z_a_GZMH + z_a_MMP7 + z_a_TRAIL + z_a_TWEAK + z_a_TNFRSF12A + z_a_TNFRSF21 
gen apoptosis_averagezscore= (apoptosis_sumzscore)/12

*Chemotaxis
gen chemotaxis_sumzscore= z_a_MCP1 + z_a_CCL3 + z_a_CCL4 + z_a_MCP3 + z_a_MCP2 + z_a_MCP4 + z_a_CCL17 + z_a_CCL19 + z_a_CCL20 + z_a_CCL23 + z_a_CXCL1 + z_a_CXCL5 + z_a_CXCL9 + z_a_CXCL10 + z_a_CXCL11 + z_a_CXCL13 + z_a_CX3CL1 + z_a_IL8 
gen chemotaxis_averagezscore= (chemotaxis_sumzscore)/18

*Promotion of Tumor Immunity
gen promoteTI_sumzscore= z_a_CD27 + z_a_CD40L + z_a_CD40 + z_a_CD70 + z_a_CD83 + z_a_CXCL9 + z_a_CXCL10 + z_a_CXCL11 + z_a_CXCL13 + z_a_CRTAM + z_a_CX3CL1 + z_a_ICOSLG + z_a_IL6 + z_a_IL7 + z_a_IL12RB1 + z_a_IL18 + z_a_NCR1 + z_a_CD244 + z_a_KLRD1 + z_a_CD4 + z_a_CD5 + z_a_CD8A + z_a_CD28 + z_a_TNFSF14 + z_a_TNFRSF4 + z_a_TNFRSF9 
gen promoteTI_averagezscore= (promoteTI_sumzscore)/26

*Suppression of Tumor Immunity 
gen suppressTI_sumzscore= z_a_MCP4 + z_a_CCL17 + z_a_CCL19 + z_a_CCL20 + z_a_CXCL1 + z_a_CXCL5 + z_a_CXCL11 + z_a_CXCL13 + z_a_Gal1 + z_a_Gal9 + z_a_IL4 + z_a_IL5 + z_a_IL6 + z_a_IL8 + z_a_IL10 + z_a_IL18 + z_a_LAPTGFbeta1 + z_a_LAMP3 + z_a_CSF1 + z_a_MMP12 + z_a_MMP7 + z_a_MICAB + z_a_PDL1 + z_a_PDL2 + z_a_PDCD1 + z_a_CD4 + z_a_CD5 + z_a_ARG1 
gen suppressTI_averagezscore= (suppressTI_sumzscore)/28

*Vasculature & tissue remodeling 
gen vasculature_sumzscore= z_a_ADGRG1 + z_a_ANG1 + z_a_TIE2 + z_a_ANGPT2 + z_a_CAIX + z_a_MCP1 + z_a_MCP4 + z_a_CCL23 + z_a_CXCL1 + z_a_CXCL5 + z_a_CXCL9 + z_a_CXCL10 + z_a_CXCL11 + z_a_DCN + z_a_FGF2 + z_a_Gal1 + z_a_Gal9 + z_a_HGF + z_a_IL8 + z_a_MMP12 + z_a_NOS3 + z_a_PGF + z_a_PDGFsubunitB + z_a_PTN + z_a_EGF + z_a_TWEAK + z_a_TNFRSF12A + z_a_VEGFA + z_a_VEGFC + z_a_VEGFR2 
gen vasculature_averagezscore= (vasculature_sumzscore)/30

*to export an updated version of the orignial data with the newly added biological processes averragezscore variables
export excel  using "~\git\ProstateCancerProteomics\RESULTS\original_data_BPaveragezscores.xlsx", firstrow(variables) keepcellfmt /*replace the path with your local path*/

*to export the averagezscores and race values for controls only
export delimited race apoptosis_averagezscore autophagy_averagezscore chemotaxis_averagezscore promoteTI_averagezscore suppressTI_averagezscore vasculature_averagezscore if case==0 using "~\git\ProstateCancerProteomics\RESULTS\biological_processes_averagezscores_controls.txt" /*replace the path with your local path*/

