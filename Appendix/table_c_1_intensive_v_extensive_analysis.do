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
************ Table C.1 Intensive vs Extensive Analysis     **********************
*********************************************************************************	

 ///Investment 
  
 // No inclusion of 0s
 
gen count_farm=1 if farm_inv>0
replace count_farm=0 if farm_inv==0
replace count_farm=. if farm_inv==.
gen count1=count_farm if ola3==0
gen count2=count_farm if ola3==1
	
bysort consecutivo(count1): replace count1 = count1[1]
bysort consecutivo(count2): replace count2 = count2[1]

gen invested = 1 if count1==0 & count2==1
replace invested= 0  if invested==.
replace invested= . if count1==.
replace invested=. if count2==.


sum count1 if relevant==1 & ola==3 & error_gr!=1 & error_con!=1 & a==1 & b!=1 & balanced2==1 & balanced3==1

eststo: areg count_farm i.treatment1##ola3 ola2##c.riqueza_pca_1 ola2##c.t_personas_1 ola2##c.ln_gastos_t_1 ///
               if treatment3!=1 & balanced_table==1 , a(consecutivo) cl(consecutivo_c)

eststo: areg ihs_w1_farm_inv_1000 i.treatment1##ola3 ola2##c.riqueza_pca_1 ola2##c.t_personas_1 ola2##c.ln_gastos_t_1 ///
               if treatment3!=1 & balanced_table==1 & count_farm==1 ,  a(consecutivo) cl(consecutivo_c)
			   
eststo: tobit ihs_w1_farm_inv_1000 i.treatment1##ola3 ola2##c.riqueza_pca_1 ola2##c.t_personas_1 ola2##c.ln_gastos_t_1  ///
               if treatment3!=1 & balanced_table==1 
				   
esttab using investment_zero_int_vs_ext.tex, replace label b(2) se(2) parentheses gaps booktabs fragment star(* 0.10 ** 0.05 *** 0.01) r2 ar2 
est clear		
	   
// Control Mean	


sum count_farm  if treatment1==0 & treatment3!=1 & balanced_table==1  & ola3==0 & count1==0 
sum w1_farm_inv_1000  if treatment1==0 & treatment3!=1 & balanced_table==1  & ola3==0 & count_farm==1 
