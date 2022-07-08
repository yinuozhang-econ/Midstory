set more off
cap log close
clear all
log using "$work/cleaning.log", text replace
cd "$work"
use "$work/cleaning.dta", clear

desc

* Keep only private sector workers
* From Alder etal 21

* identify manufacture workers
* Feryer etal 
* primary metals (33) and transportation (37), respec- tively. The bulk of the employment in these SICs falls within the steel and auto industries, as seen by looking at the four-digit industries within SICs 33 and 37, which are summarized in appendix A.

* identify rustbelt region
* Indiana, Illinois, Michigan, New York, Ohio, Wisconsin, Pennsylvania, and West Virginia
* Definition coming from Alder etal 21
gen rustBelt = 0
replace rb = 1 if (statefip == 17 ) | /// * Indiana
(statefip == 18) | /// * Illinois
(statefip == 26) | /// * Michigan
(statefip == 36) | /// * New York
(statefip == 39) | /// * Ohio
(statefip == 55) | /// * Wisconsin
(statefip == 42) | /// * Pennsylvania
(statefip == 54) /// * West Virginia



log close
