set more off
cap log close
clear all
log using "$work/cleaning.log", text replace
cd "$work"
use "$work/cleaning.dta", clear

desc

*******************************************************************
* Keep only private sector workers
* From Alder etal 21
*******************************************************************

*******************************************************************
* identify manufacture workers
*******************************************************************
* Feryer etal: primary metals (33) and transportation (37), respec- tively. The bulk of the employment in these SICs falls within the steel and auto industries, as seen by looking at the four-digit industries within SICs 33 and 37, which are summarized in appendix A.
* SIC 33: as late as 1993, 70 per- cent of total employment was within steel and iron foundries, steel rolling mills, and steel and iron pipe factories.
* SIC 37: the bulk of employment was directly in the production of cars, trucks, buses, and motor homes.
*******************************************************************
gen nondurb = 0
/* replace manu = 1 if (ind1990 == 270) | /// * Blast furnaces, steelworks, rolling and finishing mills
(ind1990 == 271) | /// * Iron and steel foundries
(ind1990 == 272) | /// * primary aluminum industries
(ind1990 == 280) | /// * Other primary metal industries
(ind1990 == 281) | /// * Cutlery, handtools, and general hardware
(ind1990 == 282) | /// * Fabricated structural metal products
(ind1990 == 291) | /// * Metal forgings and stampings
(ind1990 == 292) | /// * Ordnance
(ind1990 == 300) | /// * Misc fabricated metal products
(ind1990 == 301)  /* Metal industries, n.s.*/
*/

* nondurable + mining + construction
replace nondurb = 1 if (ind1990 >= 40) & (ind1990<= 222)

gen durb = 0
/* replace equip = 1 if (ind1990 == 310) | /// * Engines and turbines
(ind1990 == 311) | /// * Farm machinery and equipment
(ind1990 == 312) | /// * Construction and material handling machines
(ind1990 == 320) | /// * Metalworking machineary
(ind1990 == 351) | /// * Motor vehicles and motor vehicle equipment
(ind1990 == 361)  /* Railroad locomotives and equipment */
*/

* durable
replace durb = 1 if (ind1990 >=230) & (ind1990 <= 350)
* “Mining” or “Extractive industries” or “Manufacturing” or “Construction”. From growth and structural transformation handbook chapter, Appendix A on sector assignments
*******************************************************************
* identify rustbelt region
* Indiana, Illinois, Michigan, New York, Ohio, Wisconsin, Pennsylvania, and West Virginia
* Definition coming from Alder etal 21
*******************************************************************
gen rb = 0
replace rb = 1 if (statefip == 17 ) | /// * Indiana
(statefip == 18) | /// * Illinois
(statefip == 26) | /// * Michigan
(statefip == 36) | /// * New York
(statefip == 39) | /// * Ohio
(statefip == 55) | /// * Wisconsin
(statefip == 42) | /// * Pennsylvania
(statefip == 54) /* West Virginia */

* drop
drop if (empstatd == 0) | /// * N/A
(empstatd == 13) | /// * Armed forces
(empstatd == 14) | /// * Armed forces--at work
(empstatd == 15) /* Armed forces--not at work but with job */
gen empl = 0
replace empl = 1 if empstat == 1


* collapse by perwt
collapse (sum) perwt, by(year rb nondurb durb empstat)
gsort year empstat nondurb durb rb
* only keeping the employeed
keep if empstat == 1

bysort year: egen totalEmp = total(perwt)
bysort year rb: egen rb_totalEmp = total(perwt)

gen pop_nondurb = perwt if nondurb == 1
bysort year rb: egen pop_nondurb_and_durb = total(perwt) if (nondurb == 1 | durb == 1)

drop perwt durb

* only keep the sector specifics numbers to empstat == 1
gsort year rb empstat pop_nondurb
bysort year rb: replace pop_nondurb = pop_nondurb[_n-1] if empstat == 1 & missing(pop_nondurb)
replace pop_nondurb = 0 if missing(pop_nondurb)

gsort year rb empstat pop_nondurb_and_durb
bysort year rb: replace pop_nondurb_and_durb = pop_nondurb_and_durb[_n-1] if empstat == 1 & missing(pop_nondurb_and_durb)
replace pop_nondurb_and_durb = 0 if missing(pop_nondurb_and_durb)
duplicates drop
gsort year rb empstat
order year rb empstat nondurb

reshape wide pop*, i(year rb empstat) j(nondurb)
drop *1
rename ( pop_by_empstat0 pop_by_empstat_rb0 pop_nondurb0 pop_nondurb_and_durb0) ( totalEmp rb_totalEmp pop_nondurb pop_nondurb_and_durb)

drop if empstat != 1
bysort year: egen pop_nondurb_national = total(pop_nondurb)
bysort year: egen pop_nondurb_durb_national = total(pop_nondurb_and_durb)
gen nondurb_r_nation = pop_nondurb_national/pop_by_empstat
gen nondurb_durb_r_nation = pop_nondurb_durb_national/pop_by_empstat

gen nondurb_r_rb = pop_nondurb/rb_totalEmp if rb == 1
gen nondurb_durb_r_rb = pop_nondurb_and_durb/rb_totalEmp if rb == 1

tab year nondurb_durb_r_nation
tab year nondurb_durb_r_rb

tab year nondurb_r_nation
tab year nondurb_r_rb

drop empstat pop*

gsort year -rb
bysort year: replace nondurb_r_rb = nondurb_r_rb[_n-1] if missing(nondurb_r_rb)

bysort year: replace nondurb_durb_r_rb = nondurb_durb_r_rb[_n-1] if missing(nondurb_durb_r_rb)

drop rb
duplicates drop
keep year *_durb_*

rename (nondurb_durb_r_nation nondurb_durb_r_rb) (nationalRate rustbeltRate)

outsheet using "$work/output.csv", comma replace

log close
