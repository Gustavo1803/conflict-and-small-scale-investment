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
********************* Table B.1 Balance Table       *****************************
*********************************************************************************


			
balancetable (mean if treatment1==0 & treatment3==0) ///
             (mean if treatment1==1) (diff treatment1 if treatment3==0 ) ///
             vr_gtos_mensuales  riqueza_pca pcountmonth t_personas  ///
			w1_farm_inv_1000 w11_tamano per_permanentes per_short per_live per_fallow ///
			propietario leasing ilegal ///
			murders kidnappings very_bad_infra ///
			 if comp_ola==1 & balanced_table==1 &  murders!=. using "balance_baseline_general_both.tex" ///
			, varlabels nolines displayformat postfoot("") format(%15.2fc) replace			
			
	
foreach var in vr_gtos_mensuales  riqueza_pca pcountmonth t_personas  ///
			w1_farm_inv_1000 w11_tamano per_permanentes per_short per_live per_fallow ///
			propietario leasing ilegal ///
			murders kidnappings very_bad_infra ///
			{
reg `var' treatment1 if treatment3==0 & comp_ola==1 &  balance_table==1 &  murders!=., cl(consecutivo_c)

    }

balancetable (mean if treatment1==0 & treatment3==0) ///
             (mean if treatment1==1) (diff treatment1 if treatment3==0  ) ///
             vr_gtos_mensuales  riqueza_pca pcountmonth t_personas  ///
			w1_farm_inv_1000 w11_tamano per_permanentes per_short per_live per_fallow ///
			propietario leasing ilegal ///
			murders kidnappings very_bad_infra ///
			if ola==3 &  balanced_table==1 & murders!=. using "balance_baseline_general_2016.tex" ///
			, varlabels nolines displayformat postfoot("") format(%15.2fc) replace						
			

foreach var in vr_gtos_mensuales  riqueza_pca pcountmonth t_personas  ///
			w1_farm_inv_1000 w11_tamano per_permanentes per_short per_live per_fallow ///
			propietario leasing ilegal ///
			murders kidnappings very_bad_infra ///
			{
reg `var' treatment1 if ola==3 &  balanced_table==1 & murders!=. , cl(consecutivo_c)

    }
	
