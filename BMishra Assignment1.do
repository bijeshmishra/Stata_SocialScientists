/* Primary Data Analysis */
* Assignment 1:
* Set Working Directory:
cd "/Users/bmishra/Dropbox/OSU/PhD/Fall 2021/AGEC5233 PDA/Assignment/Assignment1"

* Question 1:
* a:
* Import Data:
use "data_1.dta", clear
append using data_2.dta /* Append data_2.dta to data_1.dta */
list statename in 1/2 /* First two */
list statename in 1522/1523 /* Last Two */

* b:
merge m:m frmclass statename using classes.dta
drop _merge

* c:
preserve
qui import excel "cottonac.xlsx", sheet("Sheet1") firstrow clear
save cottonac.dta, replace
restore

* d:
gen id = _n /* Generate ID */
label variable id "record identifier"

* e:
gen weight = cenfarms07/svyfarms
label variable weight "Proportional Stratification Weight "
list weight in 24/25 /* Asked: 12/13 ( 20.58/10.15) */

* f: The weight reflects how many individual falling into each strata is represented by an observation in the dataset we have. Higher weight is given to the strata that has lower sample count and lower weight is given to strata that has higher sample count so as to make sampe representative of the study population.

/* Q2: */
*a:
bysort statename frmclass: egen avgha = mean(hectares)
label variable avgha "Avg. hectare by state, sizes"
list avgha in 24/25 /* Asked: 12/13 ( 48.09092/170.35) */

*b:
preserve
keep if statename == "TN" | statename == "NC"| statename == "SC"
drop if incfarm == . | experience == . | ocrops == . | yvar == . | hectares == .
drop id
gen id = _n /* Generate ID */
label variable id "record identifier"
list id statename in 1/2
list id statename in 97/98
list id statename in 305/306
restore

/* Q3: */
* a:
global xvar incfarm experience image handheld electric ymmap college hectares 
global yvar vrtplan

* b:
tabstat $xvar $yvar, stat(count mean p50 sd min max) col(stat)

* c: 
mean $xvar $yvar /* Unweighted Mean */
estimates store unweighted
mean $xvar $yvar [pweight = weight] /* Weighted Mean */
estimates store weighted 
estimates table weighted unweighted, b(%9.4f) se varwidth(30)

* d)
pwcorr $xvar $yvar
pwcorr exper vrtplan, sig star (0.05)

* Experience and vrplan are negatively but significantly correlated but the correlation is not very strong ie. correlation coefficient = 0.1102

* e)
cdfplot experience if statename == "TN"| statename == "NC", saving (exp1, replace)
cdfplot experience if statename == "TN"| statename == "GA", saving (exp2, replace)
cdfplot experience if statename == "NC"| statename == "GA", saving (exp3, replace)
graph combine exp1.gph exp2.gph exp3.gph, rows(1) cols(3)
* graph combine "exp1" "exp2" "exp3", rows(1) cols(3) /* Alternative */

* f)
ksmirnov experience if statename == "TN" | statename == "GA", by (state)
/* 
Ho: Two sample come from same distribution.
Ha: Two sample did not come from same distribution.

Conclusion: Based on th combined K-S result, the p-value (0.121) is > 0.05 which shows that two sample came from same distribution and we failed to reject Ho. */
