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
****************  Figure F_2_parallel_trend_validation           ****************
*********************************************************************************

gen treat= treatment3==1
replace treat=2 if treatment1==1
replace treat=. if treatment1==.|treatment3==.
 
foreach var in ihs_w1_farm_inv_1000 kidnappings w11_tamano per_permanentes per_short per_live per_fallow {

gen treatdid=treat
areg `var'  i.treatdid##ola2 ola2  ola2##c.ln_gastos_t_1 ola2##c.riqueza_pca_1 ola2##c.t_personas_1 ola2##c.t_personas_1  ///
                    if balanced_table==1 , a(consecutivo) cl(consecutivo_c)
 
estimates store neighbors

drop treatdid
gen treatdid=1 if treat==2
replace treatdid=2 if treat==1
replace treatdid=0 if treat==0

areg `var' i.treatdid##ola2 ola2  ola2##c.ln_gastos_t_1 ola2##c.riqueza_pca_1 ola2##c.t_personas_1 ola2##very_bad_infra_1 ///
               if balanced_table==1, a(consecutivo) cl(consecutivo_c)
 

estimates store presence

coefplot(neighbors,label(Neighbors)) (presence,label(Presence)), baselevel vertical keep(1.treatdid#1.ola2 0.treatdid 1.treatdid#2.ola2)  yline(0) ///
                                      order(1.treatdid#1.ola2 0.treatdid 1.treatdid#2.ola2) xline(2.4, lpattern("-##") lcolor(black)) title(`var') ///
									  mlabel(cond(@pval<.05, "**", cond(@pval<.1, "*", cond(@pval<.05, "", "")))) levels(90) xlab( 1 "2010" 2 "2013" 3 "2016")
drop treatdid

graph export `var'_parallel_trend.png, replace
}

