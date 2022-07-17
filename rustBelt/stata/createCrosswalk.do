set more off
cap log close
clear all
log using "$work/createCrosswalk.log", text replace
cd "$work"

use "$work/crossWalk.dta", clear
keep ind1990 indnaics
gsort ind1990 indnaics
duplicates drop
save "$work/crossWalk.dta", replace
log close
