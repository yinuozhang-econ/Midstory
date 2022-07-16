* run setup.do first
do readData.do
save `"$work/cleaning.dta"', replace

do createCrosswalk.do
do cleaning.do
