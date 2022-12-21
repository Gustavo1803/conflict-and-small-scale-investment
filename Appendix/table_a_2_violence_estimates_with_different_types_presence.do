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
******** Table A.3 Violence Estimates Different Types of Presence****************
*********************************************************************************

gen treatment3_FARC_min = treatment3* FARC_min

foreach var in murders kidnappings {
eststo: areg `var' i.FARC_min##ola3 ola2##c.ln_gastos_t_1 ola2##c.riqueza_pca_1 ola2##c.t_personas_1  ///
               if balanced_table==1,  a(consecutivo) cl(consecutivo_c)
			   
}

foreach var in murders kidnappings {
eststo: areg `var' i.treatment1##ola3 ola2  ola2##c.ln_gastos_t_1 ola2##c.riqueza_pca_1 ola2##c.t_personas_1 ///
           if treatment3!=1 & balanced_table==1,  a(consecutivo_c) cl(consecutivo_c)
			   
}

esttab using table_investment_FARC_min.tex, replace label b(2) se(2) parentheses gaps booktabs fragment star(* 0.10 ** 0.05 *** 0.01) r2 ar2
est clear
