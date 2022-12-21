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
***********************  Table F_1_Balance_Analysis           *******************
*********************************************************************************

gen treat_dif= treatment1==1
replace treat_dif= 0 if treatment3==1
replace treat_dif=. if treatment1==0 & treatment3==0 
replace treat_dif=. if treatment1==. & treatment3==.

********* Difference of 2010 & 2013 *******************

*** Estimates of means and average differences

balancetable (mean if treatment1==0 & treatment3==0) ///
             (diff treatment3 if treatment1==0)  (diff treat_dif ) ///
             vr_gtos_mensuales vr_gtos_mens_alim riqueza_pca pcountmonth t_personas  ///
			w1_farm_inv_1000 w11_tamano per_permanentes per_short per_live per_fallow ///
			propietario leasing ilegal ///
			murders kidnappings very_bad_infra  if comp_ola==1 & a==1 & b!=1 & balanced2==1 & balanced3==1 using "balance_baseline_general_both_neighbors.tex" ///
			, varlabels nolines displayformat postfoot("") format(%15.2fc) replace	

			
*** Estimates of Standar Errors at cluster level

foreach var in vr_gtos_mensuales vr_gtos_mens_alim riqueza_pca pcountmonth t_personas  ///
			w1_farm_inv_1000 w11_tamano per_permanentes per_short per_live per_fallow ///
			propietario leasing ilegal ///
			murders kidnappings very_bad_infra ///
			{
reg `var' treatment3 if treatment1==0 & comp_ola==1 & a==1 & b!=1 & balanced2==1 & balanced3==1 , cl(consecutivo_c)
reg `var' treat_dif if  comp_ola==1 & a==1 & b!=1 & balanced2==1 & balanced3==1 , cl(consecutivo_c)

    }

	
********* Difference of 2016 *******************
*** Estimates of means and average differences

balancetable (mean if treatment1==0 & treatment3==0) ///
             (diff treatment3 if treatment1==0) (diff treat_dif ) ///
             vr_gtos_mensuales vr_gtos_mens_alim riqueza_pca pcountmonth t_personas  ///
			w1_farm_inv_1000 w11_tamano per_permanentes per_short per_live per_fallow ///
			propietario leasing ilegal ///
			murders kidnappings very_bad_infra  if ola==3 & a==1 & b!=1 & balanced2==1 & balanced3==1 using "balance_baseline_general_2016_neighbors.tex" ///
			, varlabels nolines displayformat postfoot("") format(%15.2fc) replace		
	
*** Estimates of Standar Errors at cluster level

foreach var in vr_gtos_mensuales vr_gtos_mens_alim riqueza_pca pcountmonth t_personas  ///
			w1_farm_inv_1000 w11_tamano per_permanentes per_short per_live per_fallow ///
			propietario leasing ilegal ///
			murders kidnappings very_bad_infra  /// 
			{
reg `var' treatment3 if treatment1==0 & ola==3 & a==1 & b!=1 & balanced2==1 & balanced3==1 , cl(consecutivo_c)
reg `var' treat_dif if ola==3 & a==1 & b!=1 & balanced2==1 & balanced3==1 , cl(consecutivo_c)
    }
