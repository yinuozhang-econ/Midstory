**********************************************
set more off
clear all
macro drop _all
clear matrix
drop _all
cap log close
********************************************
***     PATH SPECIFICATIONS : DATA
********************************************

* Location for CENSUS data - you'd have to change this path to your local path where you store your data
global data "/Users/yinuozhang/Dropbox/Personal/Midstory/rust belt"

********************************************
***     PATH SPECIFICATIONS : WORK
********************************************

* Location for working directory - you'd have to
global work "/Users/yinuozhang/Dropbox/Personal/Midstory/rust belt/stata"
