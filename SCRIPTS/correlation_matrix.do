import excel "~\git\ProstateCancerProteomics\DATA\original_data.xlsx", sheet("vars") firstrow clear /*replace this line with your local path*/

*****To tag each of the immune-oncological proteins using a prefix a_
foreach v of var IL8-LAPTGFbeta1 {
	rename `v' a_`v' 
		}		

***African American controls
export excel id a_* if case==0 & race=="African American" using "~\git\ProstateCancerProteomics\RESULTS\AA_controls.xlsx", firstrow(variables) keepcellfmt /*replace the path with your local path*/


***African American cases
export excel id a_* if case==1 & race=="African American" using "~\git\ProstateCancerProteomics\RESULTS\AA_cases.xlsx", firstrow(variables) keepcellfmt /*replace the path with your local path*/



