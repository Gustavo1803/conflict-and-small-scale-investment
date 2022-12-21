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
****************     Table C.3 Debt Decision          ***************************
*********************************************************************************	

winsor tamano_1, p(.01) gen(w1_tamano_1)

 foreach outcome in bank supplier_debt informal_debt {

eststo: areg `outcome' i.treatment1##ola3  ola##c.ln_gastos_t_1 ola##c.riqueza_pca_1 ola##c.t_personas_1 i.support ///
               if treatment3!=1 & balanced_table==1 ,  a(consecutivo_c) cl(consecutivo_c)
}

esttab using debt_a.tex, replace label b(2) se(2) parentheses gaps booktabs fragment star(* 0.10 ** 0.05 *** 0.01) r2 ar2 
est clear

   foreach outcome in bank supplier_debt informal_debt {

eststo: areg `outcome' i.treatment1##c.w1_tamano_1##ola3 ola2##c.ln_gastos_t_1 ola2##c.riqueza_pca_1 ola2##c.t_personas_1 ///
 if treatment3!=1 & balanced_table==1 , a(consecutivo) cl(consecutivo_c)
}	

esttab using debt_b.tex, replace label b(2) se(2) parentheses gaps booktabs fragment star(* 0.10 ** 0.05 *** 0.01) r2 ar2 
est clear

foreach outcome in bank supplier_debt informal_debt{

sum `outcome'  if treatment1==0  & ola3==0 & treatment3!=1 & balanced_table==1
}
