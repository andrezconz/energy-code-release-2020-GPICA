global DATA "/Users/andrezconz/energy-data/DATA/energy_data_release_2021oct21/DATA"
global OUTPUT "/Users/andrezconz/energy-code-release-2020-GPICA/output"
local model "TINV_clim"

/*

Purpose: Estimate stacked income decile regression (generate sters)

*/

****** Set Model Specification Locals ******************************************

global model "TINV_clim"
			
********************************************************************************
*Step 1: Load Data
********************************************************************************
		
use "/Users/andrezconz/energy-data/DATA/energy_data_release_2021oct21/DATA/regression/GMFD_TINV_clim_regsort.dta", clear

********************************************************************************
* Step 2: Prepare Regressors and Run Regression
********************************************************************************

* set fixed effect

* set time
sort region_i year 
xtset region_i year

* income decile dummies

forval pg=1/2 {
	forval lg=1/10 {
		qui gen DumIncG`lg'F1P`pg' = (ind`lg'- L1.ind`lg') * indf1 * indp`pg'
	}
}

* income decile x temp

local income_decile_temp_r = ""

forval pg = 1/2 {
	forval lg = 1/10 {
		forval k = 1/2 {
			local income_decile_temp_r = "`income_decile_temp_r' c.indp`pg'#c.indf1#c.FD_I`lg'temp`k'_GMFD"
		}
	}		
}	

* precip

local precip_r = ""

forval pg=1/2 {
	forval k = 1/2 {
		local precip_r = "`precip_r' c.indp`pg'#c.indf1#c.FD_precip`k'_GMFD"
	}		
}
	
* run first stage regression
reghdfe FD_load_pc `income_decile_temp_r' `precip_r' DumInc*, absorb(i.flow_i#i.product_i#i.year#i.subregionid) cluster(region_i) residuals(resid)
estimates save "$OUTPUT/sters/FD_income_decile_`model'", replace	
			
* calculating weigts for FGLS
drop if resid==.
bysort region_i: egen omega = var(resid)
qui gen weight = 1/omega
				
* run second stage FGLS regression
reghdfe FD_load_pc `income_decile_temp_r' `precip_r' DumInc* [pw=weight], absorb(i.flow_i#i.product_i#i.year#i.subregionid) cluster(region_i)
estimates save "/Users/andrezconz/energy-code-release-2020-GPICA/output/sters/FD_FGLS_income_decile_TINV_clim", replace

