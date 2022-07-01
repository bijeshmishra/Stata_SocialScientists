/* Assignment 3 */
cd "/path/to/file"
use data.dta, clear

label variable vote " Accepted Tax = 1"
label variable male "male (=1)"
label variable male "male (=1)"
label variable confident "Condfidence Rating 1-10"
label variable resvisit "Visited reservior this year"
label variable income "Annual Household Income"
label variable cost " Hypothetical Tax ($)"
label variable college "Graduated college = 1"
label variable hhsize "# of Persons in House"
label variable own "Owns house = 1"
label variable attentive "Attentive respondent = 1"
label variable farm "Farmed = 1"
label variable lakerecreate "Used reservior =1"

gen income1 = -1 * income
label variable income1 "-ve Annual Household Income"
gen cost1 = cost * (-1)
label variable cost1 " -Ve Hypothetical Tax ($)"
gen y = vote
label variable y "Vote"

/* Define global Macro Variables */
global x age college own cost1 income1
global y vote

/* Q4(a): Linear WTS Model */
/* Linear logit Model */
* Step 1: Use predict to generate the linear predictor, zi:
logit $y  $x, robust
margins, dydx (age college) /* Q5 */
estimates store EstLogit /* Store Estimates as Table wlogit */
fitstat /* Fit Statistics */

predict zilin, xb /* Predict new var zi containing beta coefficients */

* Linear WTS Premium for Age, College and Home Ownership:
nlcom (Age: _b[age]/_b[cost1]) (College: _b[college]/_b[cost1]) (Ownership: _b[own]/_b[cost1]), noheader level(90)

/* WTS Distribution */
gen Lwtp =   zilin/_b[cost1] - cost1 /* LPM WTP */
summarize Lwtp /* Summarize Linear WTP */

/* Q4(b): Exponential WTS Model */
gen lncost = -1 * log(cost)
global Ex age male confident resvisit income1 lncost college hhsize own attentive farm lakerecreate
logit $y  $Ex, robust
estimates store EstExp
fitstat /* Fit Statistics */
predict zi2, xb
replace zi2 =   zi2/_b[lncost] - lncost /* WTP before Exp */
gen ExpWTP = exp(zi2) /* Exponential WTP */
summarize ExpWTP /* Summarize Exponential WTP */

* Exponential WTS Premium for Age, College and Home Ownership:
nlcom (Age: (_b[age]/_b[lncost])) (College: (_b[college]/_b[lncost])) (Ownership: (_b[own]/_b[lncost])), noheader level(90)

/* Q4 #2 */
/* Plot Both WTP Together */
kdensity Lwtp, xtitle("Linear WTP") plot(kdensity ExpWTP if ExpWTP < 4900, legend(label(1 "Linear WTP") label (2 "Exponential WTP"))) /* Single Figure */
ksmirnov Lwtp = ExpWTP /* Komolgorov-Smirnoff (KS) Test */
tabstat Lwtp ExpWTP, stat( mean median sd) /* Mean, Median, St. Dev. */

/* Q6 (1): Optimal Tax For All respondent in sample (Imp. Cost = $20) */
gen constant = 1
label variable constant "Constant"
matrix mc = 20
qui logit y cost1 income1 age male confident resvisit college hhsize ///
own attentive farm lakerecreate, robust
mat beta = e(b)
mat covB = e(V)
mata: mata clear
mata: mata set matastrict off
mata: 
mata:
void fxn( real scalar todo, 
		  real scalar p, 
		  real scalar mc, 
		  real matrix X, 
		  real vector betas, 
		  real scalar bm, profit, g, H )
		 {
			real vector xb
			real scalar n
			n = rows(X)
			xb = X*betas
			profit = sum(( p[1] - mc ) :* exp( xb :- bm * p[1] ) :/ (exp( xb :- bm * p[1] ) :+ 1 ) )/n
		 }
end

set seed 123

mata:

	mc = st_matrix("mc") 
	b0 = st_matrix("beta")
	VC = st_matrix("covB")
	k  = length(b0)
	L  = cholesky(VC)
	collect = J(1000,1,0)

for (i = 1; i <= 1000; i++) { 
		
		z     = rnormal(k, 1, 0, 1)
		bstar = b0' + L*z 
		bm    = bstar[1]
		betas = bstar[2..k]
		X     = st_data(., "income1 age male confident resvisit college hhsize own attentive farm lakerecreate constant")
		
		S = optimize_init()
		optimize_init_evaluator(S, &fxn())
		optimize_init_which(S, "max")
		optimize_init_technique(S, "nr")
		optimize_init_argument(S, 1, mc)
		optimize_init_argument(S, 2, X)
		optimize_init_argument(S, 3, betas)
		optimize_init_argument(S, 4, bm)
		optimize_init_params(S,  mc)
		pstar = optimize(S) 
		
		collect[i] = pstar
	}
	
	st_matrix("pstar", collect)
	
end
preserve
svmat double pstar, name(optprice)
keep optprice1
egen index = seq()
save sim1.dta, replace
restore

/* Q6 (2): Optimal Tax For Home Owners with college degree (Imp. Cost = $20) */
matrix mc = 20
qui logit y cost1 income1 age male confident resvisit college hhsize ///
own attentive farm lakerecreate, robust
keep if own == 1 & college == 1
mat beta = e(b)
mat covB = e(V)
mata: mata clear
mata: mata set matastrict off
mata: 
mata:
void fxn( real scalar todo, 
		  real scalar p, 
		  real scalar mc, 
		  real matrix X, 
		  real vector betas, 
		  real scalar bm, profit, g, H )
		 {
			real vector xb
			real scalar n
			n = rows(X)
			xb = X*betas
			profit = sum(( p[1] - mc ) :* exp( xb :- bm * p[1] ) :/ (exp( xb :- bm * p[1] ) :+ 1 ) )/n
		 }
end

set seed 123

mata:

	mc = st_matrix("mc") 
	b0 = st_matrix("beta")
	VC = st_matrix("covB")
	k  = length(b0)
	L  = cholesky(VC)
	collect = J(1000,1,0)

for (i = 1; i <= 1000; i++) { 
		
		z     = rnormal(k, 1, 0, 1)
		bstar = b0' + L*z 
		bm    = bstar[1]
		betas = bstar[2..k]
		X     = st_data(., "income1 age male confident resvisit college  hhsize own attentive farm lakerecreate constant")
		
		S = optimize_init()
		optimize_init_evaluator(S, &fxn())
		optimize_init_which(S, "max")
		optimize_init_technique(S, "nr")
		optimize_init_argument(S, 1, mc)
		optimize_init_argument(S, 2, X)
		optimize_init_argument(S, 3, betas)
		optimize_init_argument(S, 4, bm)
		optimize_init_params(S,  mc)
		pstar = optimize(S) 
		
		collect[i] = pstar
	}
	
	st_matrix("pstar", collect)
	
end

/* Q6 For Home Owners with College Degree (Title from above) */
svmat double pstar, name(optprice2)
keep optprice2
egen index = seq()
save sim2.dta, replace
merge 1:1 index using sim1.dta
describe
save simCombo.dta, replace
preserve
use simCombo.dta, clear
tabstat optprice1 optprice2, stat(mean median sd)
kdensity optprice1, xtitle("Optimal Price") plot(kdensity optprice2, legend(label(1 "All Sample") label (2 "Home Owners and College")))
ksmirnov optprice1 = optprice2
restore
