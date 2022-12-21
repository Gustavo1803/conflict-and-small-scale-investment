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
**** Table D.1 Robustness Test for Parallel Trends and Synthetic Control ********
*********************************************************************************	

// Robustness Tests

// Placebo Test

 foreach outcome in ihs_w1_farm_inv_1000  {

eststo: areg `outcome' i.treatment1##ola  ///
               if  treatment3!=1 & balanced_table==1,  a(consecutivo) cl(consecutivo_c)

eststo: areg `outcome' i.treatment1##ola ola##c.riqueza_pca_1 ola##c.t_personas_1 ola##c.ln_gastos_t_1   ///
                if treatment3!=1 & balanced_table==1,  a(consecutivo) cl(consecutivo_c)

eststo: areg `outcome' i.treatment1##ola ola##c.ln_gastos_t_1 ola##c.riqueza_pca_1 ola##c.t_personas_1  ola##c.very_bad_infra_1 ///
                if  treatment3!=1 & balanced_table==1,  a(consecutivo) cl(consecutivo_c)
}

esttab using placebo_a.tex, replace label b(2) se(2) parentheses gaps booktabs fragment star(* 0.10 ** 0.05 *** 0.01) r2 ar2 
est clear	 




