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
* Table E.1 Complementary Estimates controlling by Suppport Programs ************
*********************************************************************************

 // Support as Control
 
 foreach outcome in murder kidnappings w11_tamano  {

eststo: areg `outcome' i.treatment1##ola3  ola##c.ln_gastos_t_1 ola##c.riqueza_pca_1 ola##c.t_personas_1 i.support ///
               if treatment3!=1 & balanced_table==1,  a(consecutivo_c) cl(consecutivo_c)

}

esttab using support_programs_A.tex, replace label b(2) se(2) parentheses gaps booktabs fragment star(* 0.10 ** 0.05 *** 0.01) r2 ar2 
est clear	 

 foreach outcome in per_permanentes per_short per_live per_productive per_fallow {

eststo: areg `outcome' i.treatment1##ola3  ola##c.ln_gastos_t_1 ola##c.riqueza_pca_1 ola##c.t_personas_1 i.support ///
               if treatment3!=1 & balanced_table==1,  a(consecutivo_c) cl(consecutivo_c)

}

esttab using support_programs_B.tex, replace label b(2) se(2) parentheses gaps booktabs fragment star(* 0.10 ** 0.05 *** 0.01) r2 ar2 
est clear	 


 foreach outcome in ln_gastos_t ln_gastos_a riqueza_pca  {

eststo: areg `outcome' i.treatment1##ola3  ola##c.ln_gastos_t_1 ola##c.riqueza_pca_1 ola##c.t_personas_1 i.support ///
               if treatment3!=1 & balanced_table==1,  a(consecutivo_c) cl(consecutivo_c)

}

esttab using support_programs_C.tex, replace label b(2) se(2) parentheses gaps booktabs fragment star(* 0.10 ** 0.05 *** 0.01) r2 ar2 
est clear
