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
gen manu = 0
replace manu = 1 if (ind1990 == 270) | /// * Blast furnaces, steelworks, rolling and finishing mills
(ind1990 == 271) | /// * Iron and steel foundries
(ind1990 == 272) | /// * primary aluminum industries
(ind1990 == 280) | /// * Other primary metal industries
(ind1990 == 281) | /// * Cutlery, handtools, and general hardware
(ind1990 == 282) | /// * Fabricated structural metal products
(ind1990 == 291) | /// * Metal forgings and stampings
(ind1990 == 292) | /// * Ordnance
(ind1990 == 300) | /// * Misc fabricated metal products
(ind1990 == 301)  /* Metal industries, n.s.*/

gen equip = 0
replace equip = 1 if (ind1990 == 310) | /// * Engines and turbines
(ind1990 == 311) | /// * Farm machinery and equipment
(ind1990 == 312) | /// * Construction and material handling machines
(ind1990 == 320) | /// * Metalworking machineary
(ind1990 == 351) | /// * Motor vehicles and motor vehicle equipment
(ind1990 == 361)  /* Railroad locomotives and equipment */

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
collapse (sum) perwt, by(year rb manu equip empstat)
gsort year empstat manu equip rb
drop if (empstat != 1) & (manu!= 0 | equip!= 0)
* bysort year: egen pop_national = total(perwt)
* bysort year rb: egen pop_total = total(perwt)
bysort year empstat: egen pop_by_empstat = total(perwt)
bysort year empstat rb: egen pop_by_empstat_rb = total(perwt)

gen pop_manu = perwt if manu == 1
bysort year rb: egen pop_manu_and_equip = total(perwt) if (manu == 1 | equip == 1)

drop perwt equip

* only keep the sector specifics numbers to empstat == 1
gsort year rb empstat pop_manu
bysort year rb: replace pop_manu = pop_manu[_n-1] if empstat == 1 & missing(pop_manu)
replace pop_manu = 0 if missing(pop_manu)

gsort year rb empstat pop_manu_and_equip
bysort year rb: replace pop_manu_and_equip = pop_manu_and_equip[_n-1] if empstat == 1 & missing(pop_manu_and_equip)
replace pop_manu_and_equip = 0 if missing(pop_manu_and_equip)
duplicates drop
gsort year rb empstat
order year rb empstat manu

reshape wide pop*, i(year rb empstat) j(manu)
drop *1
* rename (pop_national0 pop_total0 pop_by_empstat0 pop_manu0 pop_manu_and_equip0) (pop_national pop_total pop_by_empstat pop_manu pop_manu_and_equip)
rename ( pop_by_empstat0 pop_by_empstat_rb0 pop_manu0 pop_manu_and_equip0) ( pop_by_empstat pop_by_empstat_rb  pop_manu pop_manu_and_equip)

drop if empstat != 1
bysort year: egen pop_manu_national = total(pop_manu)
bysort year: egen pop_manu_equip_national = total(pop_manu_and_equip)
gen manu_r_nation = pop_manu_national/pop_by_empstat
gen manu_equip_r_nation = pop_manu_equip_national/pop_by_empstat


log close
