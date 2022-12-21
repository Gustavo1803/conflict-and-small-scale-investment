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
local tables C:\Users\..... /*Path for export the figures*/

*-------------------------------------------------------------------------------
*2. Load of Base for Estimates
*-------------------------------------------------------------------------------

cd "`base'"

do cleaner

cd "`tables'"


*********************************************************************************
**************** Figure 1. Violence and Investment Trends ***********************
*********************************************************************************	

foreach var in murders  {

capture xtreg `var' ola##i.treatment1 if treatment3!=1 
margins ola#i.treatment1
marginsplot, recastci(rline) ciopts(color(*.5) lpattern(dash)) ytitle(Average) xtitle("") title(`var') legend(row(1) position(6) order(4 "No" 5 "Neighbors")) ///
				xlabel(1 "2010" 2 "2013" 3 "2016") yline(0, lcolor("black"))
	graph export murders.png, replace		
}		

foreach var in w1_farm_inv_1000  {

capture xtreg `var' ola##i.treatment1  if treatment3!=1 
margins ola#i.treatment1
marginsplot, recastci(rline) ciopts(color(*.5) lpattern(dash)) ytitle(Average) xtitle("") title(`var') legend(row(1) position(6) order(4 "No" 5 "Neighbors")) ///
				xlabel(1 "2010" 2 "2013" 3 "2016") yline(0, lcolor("black"))
	graph export Farm_investment.png, replace		
}	
