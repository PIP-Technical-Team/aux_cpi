if ("`c(username)'" == "wb327173") {
	global auxout c:\Users\wb327173\OneDrive - WBG\Downloads\ECA\GPWG\PIP_repo\
	
}
else if ("`c(username)'" == "wb384996"){
	global auxout "C:\Users\wb384996\OneDrive - WBG\WorldBank\DECDG\PIP\aux_data"
}
cd "${auxout}\aux_cpi\"
copy cpi.dta vintage/cpi_20250306.dta // do NOT user replace

use cpi.dta, clear
keep if code == "IND"
// keep just one copy 
keep if cpi_data_level == "1"
// data lavel is now national
replace cpi_data_level = "2"
replace cpi_domain = 1
// it should 1 already, but just in case (comparing with IDN)
replace cpi_domain_value = 1

tempfile ind 
save `ind', replace

// append to the main file
use cpi.dta, clear
keep if code != "IND"
append using `ind'

// sort and check id
local sortvar code year survname cpi_domain cpi_domain_value
sort `sortvar'
isid `sortvar'

cap noi datasignature confirm using "cpi", strict
cap noi datasignature confirm using "cpi"
if (_rc) {
  datasignature set, reset saving("cpi", replace)
  export delimited  "cpi.csv" , replace
}

save cpi.dta, replace


