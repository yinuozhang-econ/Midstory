*******************************************************************
* Keep only private sector workers
* From Alder etal 21
*******************************************************************

*******************************************************************
* identify manufacture workers
*******************************************************************
* mining + construction + nondurable manufacture + durable manufacture
gen manu = 0
replace manu = 1 if (ind1990 >= 40) & (ind1990 <= 350)

*******************************************************************
* Feryer etal: primary metals (33) and transportation (37), respec- tively. The bulk of the employment in these SICs falls within the steel and auto industries, as seen by looking at the four-digit industries within SICs 33 and 37, which are summarized in appendix A.
* SIC 33: as late as 1993, 70 per- cent of total employment was within steel and iron foundries, steel rolling mills, and steel and iron pipe factories.
* SIC 37: the bulk of employment was directly in the production of cars, trucks, buses, and motor homes.
*******************************************************************
* gen nondurb = 0
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
* replace nondurb = 1 if (ind1990 >= 40) & (ind1990<= 222)

* gen durb = 0
/* replace equip = 1 if (ind1990 == 310) | /// * Engines and turbines
(ind1990 == 311) | /// * Farm machinery and equipment
(ind1990 == 312) | /// * Construction and material handling machines
(ind1990 == 320) | /// * Metalworking machineary
(ind1990 == 351) | /// * Motor vehicles and motor vehicle equipment
(ind1990 == 361)  /* Railroad locomotives and equipment */
*/

* durable
* replace durb = 1 if (ind1990 >=230) & (ind1990 <= 350)
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
collapse (sum) perwt, by(year rb manu empstat)
