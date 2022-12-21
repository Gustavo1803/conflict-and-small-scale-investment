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
**************** Panel A. Use of Land as Percentage of the Farm *****************
*********************************************************************************	

foreach var in  per_permanentes per_short per_live per_productive  { 
eststo: areg `var' i.treatment1##ola3  ola2##c.ln_gastos_t_1 ola2##c.riqueza_pca_1 ola2##c.t_personas_1 ///
 if treatment3!=1 & balanced_table==1,  a(consecutivo) cl(consecutivo_c)

	}
	
esttab using investment_decision_a.tex, replace label b(3) se(3) parentheses gaps booktabs fragment star(* 0.10 ** 0.05 *** 0.01) r2 ar2 
est clear	

 // Control means

foreach outcome in per_permanentes  per_short per_live per_productive {

sum `outcome'  if treatment1==0 & treatment3!=1 & balanced_table==1 & ola3==0

}	

*********************************************************************************
****************      Panel B. Increase of Land Use       **********************
*********************************************************************************	

foreach var in  w11_tamano per_forest per_no_used per_fallow  { 
eststo: areg `var' i.treatment1##ola3  ola2##c.ln_gastos_t_1 ola2##c.riqueza_pca_1 ola2##c.t_personas_1 ///
 if treatment3!=1 & balanced_table==1,  a(consecutivo) cl(consecutivo_c)

	}
		
esttab using investment_decision_b.tex, replace label b(3) se(3) parentheses gaps booktabs fragment star(* 0.10 ** 0.05 *** 0.01) r2 ar2 
est clear

 // Control means

foreach outcome in w11_tamano per_forest per_no_used per_fallow {

sum `outcome'  if treatment1==0 & treatment3!=1 & balanced_table==1 & ola3==0

}	
	