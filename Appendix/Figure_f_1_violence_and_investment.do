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

gen treat= treatment3==1
replace treat=2 if treatment1==1
replace treat=. if treatment1==.|treatment3==.

foreach var in murders  {

capture xtreg `var' ola##i.treat 
margins ola#i.treat
marginsplot, recastci(rline) ciopts(color(*.5) lpattern(dash)) ytitle(Average) xtitle("") title(`var') legend(row(1) position(6) order(4 "No" 5 "Neighbors" 6 "Presence")) ///
				xlabel(1 "2010" 2 "2013" 3 "2016") yline(0, lcolor("black"))
	graph export violence_neigh_`var'.png, replace		
}

foreach var in w1_farm_inv_1000  {

capture xtreg `var' ola##i.treat 
margins ola#i.treat
marginsplot, recastci(rline) ciopts(color(*.5) lpattern(dash)) ytitle(Average) xtitle("") title(`var') legend(row(1) position(6) order(4 "No" 5 "Neighbors" 6 "Presence")) ///
				xlabel(1 "2010" 2 "2013" 3 "2016") yline(0, lcolor("black"))
	graph export investment_neigh_`var'.png, replace		
}



