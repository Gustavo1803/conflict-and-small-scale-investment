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
*********************** Panel A. Effect on Welfare  *****************************
*********************************************************************************	

foreach outcome in ln_gastos_t ln_gastos_a riqueza_pca  {

eststo: areg `outcome' i.treatment1##ola3 ola2##c.ln_gastos_t_1 ola2##c.riqueza_pca_1 ola2##c.t_personas_1 ///
 if  treatment3!=1 & balanced_table==1,  a(consecutivo) cl(consecutivo_c)
	}	
	
esttab using consumption.tex, replace label b(2) se(2) parentheses gaps booktabs fragment star(* 0.10 ** 0.05 *** 0.01) r2 ar2 
est clear


 // Control means

foreach outcome in vr_gtos_mensuales vr_gtos_mens_alim riqueza_pca {

sum `outcome'  if treatment1==0 & treatment3!=1 & balanced_table==1 & ola3==0

}	
 

*********************************************************************************
*********************** Panel B. Effect on Saving and Debt***********************
*********************************************************************************
	
foreach outcome in ihs_vr_ahorro ihs_debth_value prop_sav w1_prop {

eststo: areg `outcome' i.treatment1##ola3  ola2##c.ln_gastos_t_1 ola2##c.riqueza_pca_1 ola2##c.t_personas_1 ///
               if treatment3!=1 & balanced_table==1 ,  a(consecutivo_c) cl(consecutivo_c)
}

  esttab using saving_debt.tex, replace label b(2) se(2) parentheses gaps booktabs fragment star(* 0.10 ** 0.05 *** 0.01) ar2 
est clear	

foreach outcome in vr_ahorro debth_value prop_sav w1_prop {

sum `outcome'  if treatment1==0 & treatment3!=1 & balanced_table==1 & ola3==0

}	


