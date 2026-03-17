global DATA "/Users/andrezconz/energy-data/DATA/energy_data_release_2021oct21/DATA"
global OUTPUT "/Users/andrezconz/energy-code-release-2020-GPICA/output"
global model "TINV_clim"

use "$DATA/regression/GMFD_$model_regsort.dta", clear

* Esta es la regresión pesada (Figura 1C)
reghdfe FD_load_pc c.tmean_all##c.loggdppc c.tmean_all_sq##c.loggdppc, absorb(i.flow_i#i.product_i#i.year#i.subregionid) cluster(region_i)

* Guardar el archivo .ster
estimates save "$OUTPUT/sters/FD_FGLS_interacted_$model", replace
