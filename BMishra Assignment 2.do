/* Assignment 2 */
* putdocx begin
cd "/Users/bmishra/Dropbox/OSU/PhD/Fall 2021/AGEC5233 PDA/Assignment/Assignment2"
use assignment2.dta, clear

* ereturn list

* Question 1:
* a)
gen yield1 = yield*100 /* Yield in Kg/Ha */
mean yield

* b)
gen d1 = topography == 1 /* Dummy for tpopgraphy = 1 */
gen d2 = topography == 2 /* Dummy for tpopgraphy = 2 */
replace d2 = d2 - d1
gen d3 = topography == 3 /* Dummy for tpopgraphy = 3 */
replace d3 = d3 - d1
gen d4 = topography == 4 /* Dummy for tpopgraphy = 4 */
replace d4 = d4 - d1
tabstat d2 d3 d4, stats(mean) /* Mean of Dummies */

* c) 
* Write a design matrix.
gen nsq = n*n
gen nd2 = n*d2
gen nd3 = n*d3
gen nd4 = n*d4
gen nsqd2 = nsq*d2
gen nsqd3 = nsq*d3
gen nsqd4 = nsq*d4

* d) Design Matrix:
/* 
Cons d2 d3 d4 n nd2 nd3 nd4 nsq nsqd2 nsqd3 nsqd4 /* Variables*/
1    -1 -1 -1 n -n  -n  -n  n^2 -n^2  -n^2  -n^2
1     1  0  0 n  n   0   0  n^2  n^2   0     0
1     0  1  0 n  0   n   0  n^2  0     n^2   0
1     0  0  1 n  0   0   n  n^2  0     0     n^2
*/

* d)
regress yield1 n nsq d2 d3 d4 nd2 nd3 nd4 nsqd2 nsqd3 nsqd4     /* Regression */
estimates store model1

* e)
gen sqrtn = sqrt(n)
gen sqrtnd2 = sqrtn*d2
gen sqrtnd3 = sqrtn*d3
gen sqrtnd4 = sqrtn*d4
regress yield1 n sqrtn d2 d3 d4 nd2 nd3 nd4 sqrtnd2 sqrtnd3 sqrtnd4 /* Reg */
estimates store model2

* f)
estimates table model1 model2, b(%9.3f) se t stats(aic, rmse)
* Smaller AIC works better, Model 2 is selected.

* Quesiton 2:
* a) 
bootstrap, reps(1000) mse seed(125) strata(topography) nodots: /// 
regress yield1 n sqrtn d2 d3 d4 nd2 nd3 nd4 sqrtnd2 sqrtnd3 sqrtnd4
estat bootstrap, percentile
estimates store model3
predict u0, residual

* b) Because the variation can be observed among topographies. If we sample considering all topographies as one, we are ignoring the variation among topographies.

* c)
bysort topo: egen u1 = sd(u0) /* Generate standard deviation by topography */
gen double grpwt = 1/(u1^2) /* Generate Analytical Weight */
regress yield1 n sqrtn d2 d3 d4 nd2 nd3 nd4 sqrtnd2 sqrtnd3 sqrtnd4 ///
[aweight = grpwt] /* Regression applying Analytical weight */
estimates store model4

* d)
hetregress yield1 n sqrtn d2 d3 d4 nd2 nd3 nd4 sqrtnd2 sqrtnd3 sqrtnd4, het(topography) /*  Groupwise heteroskadastic model */
estimates store model5

* e)
estimates table model2 model3 model4 model5, b(%9.3f) se t stats(aic, rmse)

* Quesiton 3:
* a) 
qui bootstrap, reps(1000) mse seed(125) strata(topography) nodots: /// 
regress yield1 n sqrtn d2 d3 d4 nd2 nd3 nd4 sqrtnd2 sqrtnd3 sqrtnd4
test n = sqrtn = d2 = d3 = d4 = nd2 = nd3 = nd4 = sqrtnd2 = sqrtnd3 = sqrtnd4 = 0 /* Test for yield response is not different between topography zones */

* b) /* Ho: Yield response to the first Kg of N is Topo 1 is not different from the whole field average:
test sqrtnd2 + sqrtnd3 + sqrtnd4 = 0

* c)
global rN = 0.435 /* Price of Nitrogen */
global p = 6.85/ 100 /* Price of Corn */

nlcom ((_b[sqrtn] - _b[sqrtnd2] - _b[sqrtnd3] - _b[sqrtnd4]) / (2 * ($rN/$p - (_b[n] - _b[nd2] - _b[nd3] - _b[nd4]))))^2 - ((_b[sqrtn] + _b[sqrtnd4]) / (2*($rN/$p - (_b[n] + _b[nd4]))))^2
