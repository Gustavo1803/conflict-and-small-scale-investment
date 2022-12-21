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
**** Table D.2 Robustness Test for Effect of Government Support          ********
*********************************************************************************	
 // Support programs 
 
 replace ayu_oi_vr=0 if ayu_oi_vr==.
replace ayu_ong_vr=0 if ayu_ong_vr==.
gen ayu_inter_tot = ayu_oi_vr + ayu_ong_vr
gen inter = 1 if ayu_inter_tot>0
replace inter =0 if inter==.

gen ayu_inter_tot_0 = ayu_oi_vr_0 + ayu_ong_vr_0
gen inter_0 = 1 if ayu_inter_tot_0>0
replace inter_0 =0 if inter_0==.


 
 foreach outcome in ihs_w1_farm_inv_1000  {


eststo: areg `outcome' i.treatment1##ola3 i.ola2 i.support i.inter ///
               if treatment3!=1 & balanced_table==1,  a(consecutivo) cl(consecutivo_c)

eststo: areg `outcome' i.treatment1##ola3 ola2##c.riqueza_pca_1 ola2##c.t_personas_1 ola2##c.ln_gastos_t_1 i.support i.inter  ///
               if treatment3!=1 & balanced_table==1,  a(consecutivo) cl(consecutivo_c)

eststo: areg `outcome' i.treatment1##ola3 ola2##c.ln_gastos_t_1 ola2##c.riqueza_pca_1 ola2##c.t_personas_1  ola2##c.very_bad_infra_1  i.support i.inter ///
               if treatment3!=1 & balanced_table==1,  a(consecutivo) cl(consecutivo_c)
}



 foreach var in support tit_baldios prg_tierras inter {
eststo: areg `var' i.treatment1##ola3 ola2##c.ln_gastos_t_0 ola2##c.riqueza_pca_0 ola2##c.t_personas_0 ola2##c.t_personas_0 ///
        if  treatment3!=1 & balanced_table==1, a(consecutivo)	cl(consecutivo_c)
	}	
	
foreach outcome in support tit_baldios prg_tierras  {

sum `outcome' if treatment3!=1 & balanced_table==1. 

}

esttab using placebo_b.tex, replace label b(2) se(2) parentheses gaps booktabs fragment star(* 0.10 ** 0.05 *** 0.01) r2 ar2 
est clear	
