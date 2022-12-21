 *-------------------------------------------------------------------------------
* Program Setup
*-------------------------------------------------------------------------------

version 12              
set more off            
clear all               
capture log close       

*-------------------------------------------------------------------------------
//1. Paths and Graph Settings
*-------------------------------------------------------------------------------

local base C:\Users\..... /*Path of the "cleaner.do" file in local computer*/
local tables C:\Users\..... /*Path for export the tables*/

*-------------------------------------------------------------------------------
*2. Load of Base for Estimates
*-------------------------------------------------------------------------------

cd "`base'"

do cleaner

cd "`tables'"

*********************************************************************************
********************* Table G.3 Attrition Analysis  *****************************
*********************************************************************************


	// Attrition calculations
	
gen attr = balanced2 == 1 & balanced3==1 
replace attr = 0 if attr==.

foreach var in  attr  { 
eststo: reg `var' treatment1 riqueza_pca_1 t_personas_1 ln_gastos_t_1  ///
               if relevant==1  & error_gr!=1 & error_con!=1  & treatment3!=1 & a==1 & b!=1 & ola==3 , cl(consecutivo_c)
			   
eststo: reg `var' treatment1 treatment3 riqueza_pca_1 t_personas_1 ln_gastos_t_1  ///
               if relevant==1  & error_gr!=1 & error_con!=1 & a==1 & b!=1 & ola==3 , cl(consecutivo_c)			   
	}
	
esttab using attr_1.tex, replace label b(3) se(3) parentheses gaps booktabs fragment star(* 0.10 ** 0.05 *** 0.01) r2 ar2 
est clear	
	