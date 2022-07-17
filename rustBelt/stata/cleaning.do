set more off
cap log close
clear all
log using "$work/cleaning.log", text replace
cd "$work"
use "$work/cleaning.dta", clear

desc

do selectVar.do

gsort year empstat manu rb
* only keeping the employeed
keep if empstat == 1

bysort year: egen totalEmp = total(perwt)
bysort year rb: egen rb_totalEmp = total(perwt) if rb == 1
gsort year -rb
bysort year: replace rb_totalEmp = rb_totalEmp[_n-1] if missing(rb_totalEmp)

bysort year manu: egen manu_totalEmp = total(perwt) if manu == 1
gsort year -manu
bysort year: replace manu_totalEmp = manu_totalEmp[_n-1] if missing(manu_totalEmp)

gen manu_rb_totalEmp = perwt if rb == 1 & manu == 1
gsort year -manu -rb
bysort year: replace manu_rb_totalEmp = manu_rb_totalEmp[_n-1] if missing(manu_rb_totalEmp)

drop empstat manu rb perwt
duplicates drop

* nationalRate rustbeltRate
gen nationalRate = manu_totalEmp/totalEmp
gen rustBeltRate = manu_rb_totalEmp/manu_totalEmp
tab year nationalRate
tab year rustBeltRate

outsheet using "$work/output.csv", comma replace

log close
