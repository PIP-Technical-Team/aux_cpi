
// make sure you change to wherever the aux_cpi repo is stored in your machine
// In profile.do I set the global wb_dir in my computer for general use
cd "${wb_dir}\DECDG\PIP\aux_cpi\"
global dlw_dir "\\wbgfscifs01\GPWG-GMD\Datalib\GMD-DLW\Support\Support_2005_CPI\"

local cpidirs: dir "${dlw_dir}" dirs "*_A_GMD", respectcase
local cpivins "0"
foreach cpidir of local cpidirs {
	if regexm("`cpidir'", "CPI_[Vv]([0-9]+)_M") local cpivin = regexs(1)
	local cpivins "`cpivins', `cpivin'"
}
local cpivin = max(`cpivins')
disp "`cpivin'"


use "${dlw_dir}/Support_2005_CPI_v0`cpivin'_M_v01_A_GMD/Support_2005_CPI_v0`cpivin'_M_v01_A_GMD_CPI.dta", clear

* Add cpi_id "CPI_v0`cpivin'_M_v01_A"

gen cpi_id = "CPI_v0`cpivin'_M_v01_A"

cap noi datasignature confirm using "cpi", strict
if (_rc) {
	datasignature set, reset saving("cpi", replace)
  export delimited  "cpi.csv" , replace
}


