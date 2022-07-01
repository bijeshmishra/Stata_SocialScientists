/*Assignment 5*/
cd "/Users/bmishra/Dropbox/OSU/PhD/Fall 2021/AGEC5233 PDA/Assignment/Assignment5"
use LesothoProfitCA.dta, clear

*ssc install psmatch, replace
*ssc install pstest, replace

label var fieldsize "Field Size	(ha)"
label var ca  "Adopt conservation ag."
label var inclivstcksale  "Inc. livestock (percent)"
label var incremittance  "Inc. remittances (percent)"
label var agehh  "Age household head (years)"
label var agtraining  "Received ag. training"
label var highschoolhh  "High school degree"
label var creditloan  "Received credit loan"
label var profit  "Field profit ($/ha)"
ds


* Q2:
/* Use STATA's psmatch2 procedure to estimate ATT using the following matching procedures: */

/* Mahalanobis with five (5) nearest neighbors */
psmatch2 ca agtraining inclivstcksale fieldsize highschoolhh agehh, outcome(profit) neighbor(5) mahalanobis(agtraining inclivstcksale fieldsize highschoolhh agehh)

/* psmatch2 ptest rubin */
pstest agtraining inclivstcksale fieldsize highschoolhh agehh, both rubin treated(ca)

/* psmatch2 Bootstrap */
bootstrap r(att), reps(500) mse nodots: psmatch2 ca agtraining inclivstcksale fieldsize highschoolhh agehh, outcome(profit) neighbor(5) mahalanobis(agtraining inclivstcksale fieldsize highschoolhh agehh)


/* Kernel matching estimator, with a Epanechnikov kernel */
psmatch2 ca agtraining inclivstcksale fieldsize highschoolhh agehh, out (profit) kernel kerneltype(epan) ties warn com logit 

/* Kernel matching estimator, with a Epanechnikov kernel rubin not */
pstest agtraining inclivstcksale fieldsize highschoolhh agehh, both rubin

/* Kernel matching estimator, with a Epanechnikov kernel Bootstrap */
bootstrap r(att), reps(500) mse nodots: psmatch2 ca agtraining inclivstcksale fieldsize highschoolhh agehh, out (profit) kernel kerneltype(epan) ties warn com logit 


/* Kernel matching estimator, with a Normal Kernel */
psmatch2 ca agtraining inclivstcksale fieldsize highschoolhh agehh, out (profit) kernel kerneltype(normal) ties warn com logit 

/* Kernel matching estimator, with a Normal Kernel rubin */
pstest agtraining inclivstcksale fieldsize highschoolhh agehh, both rubin

/* Kernel matching estimator, with a Normal Kernel Rubin Bootstrap */
bootstrap r(att), reps(500) mse nodots: psmatch2 ca agtraining inclivstcksale fieldsize highschoolhh agehh, out (profit) kernel kerneltype(normal) ties warn com logit
