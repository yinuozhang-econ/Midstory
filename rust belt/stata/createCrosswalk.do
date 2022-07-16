set more off
cap log close
clear all
log using "$work/createCrosswalk.log", text replace
cd "$work"

use "$work/crossWalk.dta", clear

log close
