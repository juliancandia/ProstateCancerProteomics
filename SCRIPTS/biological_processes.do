

import delimited "~\git\ProstateCancerProteomics\RESULTS\original_data_outliers_removed.txt" /*replace this line with your local path*/

*Autophagy
export excel race HO1 CAIX ADA if case==0 using "~\git\ProstateCancerProteomics\RESULTS\autophagy_controls.xlsx", firstrow(variables) keepcellfmt /*replace the path with your local path*/

*Apoptosis
export excel race CASP8 CD40L FASLG Gal9 GZMA GZMB GZMH MMP7 TRAIL TWEAK TNFRSF12A TNFRSF21 if case==0 using "~\git\ProstateCancerProteomics\RESULTS\apoptosis_controls.xlsx", firstrow(variables) keepcellfmt /*replace the path with your local path*/

*Chemotaxis
export excel race MCP1 CCL3 CCL4 MCP3 MCP2 MCP4 CCL17 CCL19 CCL20 CCL23 CXCL1 CXCL5 CXCL9 CXCL10 CXCL11 CXCL13 CX3CL1 IL8 if case==0 using "~\git\ProstateCancerProteomics\RESULTS\chemotaxis_controls.xlsx", firstrow(variables) keepcellfmt /*replace the path with your local path*/

*Promotion of Tumor Immunity 
export excel race CD27 CD40L CD40 CD70 CD83 CXCL9 CXCL10 CXCL11 CXCL13 CRTAM CX3CL1 ICOSLG IL6 IL7 IL12RB1 IL18 NCR1 CD244 KLRD1 CD4 CD5 CD8A CD28 TNFSF14 TNFRSF4 TNFRSF9 if case==0 using "~\git\ProstateCancerProteomics\RESULTS\promoteTI_controls.xlsx", firstrow(variables) keepcellfmt /*replace the path with your local path*/

*Suppression Tumor Immunity 
export excel race MCP4 CCL17 CCL19 CCL20 CXCL1 CXCL5 CXCL11 CXCL13 Gal1 Gal9 IL4 IL5 IL6 IL8 IL10 IL18 LAPTGFbeta1 LAMP3 CSF1 MMP12 MMP7 MICAB PDL1 PDL2 PDCD1 CD4 CD5 if case==0 using "~\git\ProstateCancerProteomics\RESULTS\suppressTI_controls.xlsx", firstrow(variables) keepcellfmt /*replace the path with your local path*/

*Vasculature & tissue remodeling 
export excel race ADGRG1 ANG1 TIE2 ANGPT2 CAIX MCP1 MCP4 CCL23 CXCL1 CXCL5 CXCL9 CXCL10 CXCL11 DCN FGF2 Gal1 Gal9 HGF IL8 MMP12 NOS3 PGF PDGFsubunitB PTN EGF TWEAK TNFRSF12A VEGFA VEGFC VEGFR2 if case==0 using "~\git\ProstateCancerProteomics\RESULTS\vasculature_controls.xlsx", firstrow(variables) keepcellfmt /*replace the path with your local path*/

