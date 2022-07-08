* run setup.do first
do readData.do
save `"$work/cleaning.dta"', replace

do cleaning.do
