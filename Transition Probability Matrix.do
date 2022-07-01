/* Assignment 4 */
cd "/path/to/file"
use "/User/data.dta", clear
ds /* List Variable Names */

* Q1: Why MNL:
table y
tab ylag
gen ylag1 = ylag == 1
gen ylag2 = ylag == 2
gen ylag3 = ylag == 3

* Q2: In Paper.

* Q3: Estimate MNL Regression, Report Margin, Measure Fit:
mlogit y ylag2 ylag3
margins, dydx(*)

* Q4: Find Transitional Matix:
forvalues s = 1(1)3 {
qui margins, predict(pr outcome(`s')) noesample  ///
 at((means) _all ylag2 = 1 ylag3 = 0)  ///
 at((means) _all ylag2 = 0 ylag3 = 1) ///
 at((means) _all ylag2 = 0 ylag3 = 0) noatlegend
 
matrix sel_`s' = r(b)
 forvalues j = 1(1)3 {
 local sel_`j'_`s'= sel_`s'[1,`j']
 }
}
mat tprob =  sel_1\ sel_2\ sel_3
mat tprob = tprob'
mat list tprob

* Q5: Long Term Steady State Transition Probability Matrix using Gauss-Sidel covergence Criteria: Report # of Iteration:, Last Iteration's Deviance, Interpret Transitional Matrix:

mata: mata clear  
mata:
/* Initialize */
P = st_matrix("tprob")
C0 = st_matrix("tprob")
collect = C0'
crit = 1e-3
dev  = 1
iter = 0

/* Gauss-Seidel */
while (dev > crit)  { 
		C1 = P' * C0
		dev = max(abs(C0 - C1))
		C0 = C1
		collect  = collect\C1'
		dev
		iter = iter + 1
	}
	st_matrix("LTSSTM", collect)
iter /* Number of Iteration */
end
matrix list LTSSTM /* Long Term Steady State Transition Probability Matrix */

* Q6: Long Term Steady State Profit using Gauss-Seidel Convergence Criteria, Report # of Iteration, Interpret Transitional Matrix:
mat mcost = 7.87\8.12\6.98 /* Marginal Cost */
mat mprice = 9.54\8.24\8.76 /* Sale Unit Price */
mat customers = 20591\40785\39613 /* Customers */
mat profit = 20591*(9.54-7.87)\40785*(8.24-8.12)\39613*(8.76-6.98)/* Profit */
mat cost = (7.87*20591)\(8.12*40785)\(6.98*39613) /* Cost */

mata: mata clear  
mata:
/* Initialize */
P = st_matrix("tprob")
C0 = st_matrix("profit")
collect = C0'
crit = 1e-3
dev  = 1
iter = 0

/* Gauss-Seidel */
while (dev > crit)  { 
		C1 = P'* C0
		dev = max(abs(C0 - C1))
		C0 = C1
		collect  = collect\C1'
		dev
		iter = iter + 1
	}
	st_matrix("Cstar1", collect)
iter /* Number of Iteration */
end
matrix list Cstar1 /* Long Term Steady State Industry Profit Transition Probability Matrix */

* Plot Output:
svmat double Cstar1, name(Profit)
keep if Profit1 != .
gen Period1 = _n
replace Period1 = Period1 - 1
keep Period1 Profit*

label var Profit1 "State 1"
label var Profit2 "State 2"
label var Profit3 "State 3"

save Profit, replace
use Profit, clear
list *, sep(3) /* Optimized Profit */
twoway (line Profit1 Period1) (line Profit2 Period1) (line Profit3 Period1), ytitle(Profit) xtitle(Period)  
graph save Graph "/Users/bmishra/Dropbox/OSU/PhD/Fall 2021/AGEC5233 PDA/Assignment/Assignment4/Profit.gph", replace
