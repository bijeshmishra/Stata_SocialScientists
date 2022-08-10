********************************************************************************
* Title: PhD Dissertation Objective 3: Structural Equation Modeling
* Short title: BMishra DO03.do
* Created by: Bijesh Mishra
* Created on: July 10, 2020
* Purpose: This [BMishra DO03.do] files does contain codes that analyze data for my PhD Dissertation objective 3.

********************************************************************************
clear all
/* Set up Working Directory and Import Data: */
cd "/Users/bmishra/Dropbox/Professional/PhD/Dissertation/Survey/Data/FinalData/Objective3" /* Change Working Directory */
import delimited "/Users/bmishra/Dropbox/Professional/PhD/Dissertation/Survey/Data/FinalData/SurveyData02192021.csv" /* Import Data */
********************************************************************************

********************************************************************************
/* Variable Managment */
/*reverse coding e1govt */
*use reverse (e1govt)
recode e1govt (1 = 5) (2 = 4) (3 = 3) (4 = 2) (1 = 5) (. = .), generate (r_e1govt)
label variable r_e1govt "e1govt Reverse coded " /* Name Variable */
tab e1govt r_e1govt /* Re-coding Verification */

/*reverse coding e1commun */
recode e1commun (1 = 5) (2 = 4) (3 = 3) (4 = 2) (1 = 5) (. = .), generate (r_e1commun)
label variable r_e1commun "e1commun reverse coded " /* Name Variable */
tab e1commun r_e1commun /* Re-coding Verification */

/* WTP Per Deer observed in Dollar Value */
recode a7dwtp (0 = 0) (1 = 25) (2 = 50) (3 = 100) (4 = 150) (5 = 200) (6 = 250) (7 = 300) (8 = 350) (9 = 400) (. = .), generate (a7wtp)
label variable a7wtp "WTP ($/Acres) " /* Name Variable */
tab a7wtp a7dwtp /* Re-coding Verification */

generate wtp_deer = a7wtp/a6deer /* WTP per deer observed */
label variable wtp_deer "WTP($)/Deer/Acres" /* Name Variable */
sum wtp_deer, detail
* hist wtp_deer, freq
* graph box wtp_deer

gen wtp_deer_lg = log(wtp_deer) /* log transformation of wtp_deer */
label variable wtp_deer "WTP Per Deer (Log)" /* Name Variable */
sum wtp_deer_lg, detail
* hist wtp_deer_lg, freq

sum wtp* a7* a6*, detail /* Summarize */
sum wtp_deer, detail
********************************************************************************

********************************************************************************
* Outlier Detection: 
tab a7wtp
drop if a9altdist > 100
tab a9altdist
tab c6interest
********************************************************************************

********************************************************************************
/* Variable Standarization */
* Standardize a7wtp:
egen mean_a7wtp = mean(a7wtp)
egen sd_a7wtp = sd(a7wtp)
gen sa7wtp = (a7wtp - mean_a7wtp)/sd_a7wtp
drop mean_a7wtp sd_a7wtp

* Standardize a9altdist:
egen mean_a9altdist = mean(a9altdist)
egen sd_a9altdist = sd(a9altdist)
gen sa9altdist = (a9altdist - mean_a9altdist)/sd_a9altdist
drop mean_a9altdist sd_a9altdist

* Standardize C6interest:
egen mean_c6interest = mean(c6interest)
egen sd_c6interest = sd(c6interest)
gen sc6interest = (c6interest - mean_c6interest)/sd_c6interest
drop mean_c6interest sd_c6interest
********************************************************************************

********************************************************************************
sum a7wtp a9altdist c6interest
* graph matrix a7wtp a9altdist c6interest, half
sum sa7wtp sa9altdist sc6interest 
* graph matrix sa7wtp sa9altdist sc6interest, ///
* diagonal ("a7wtp" "a9altdist" "c6interest")
********************************************************************************

********************************************************************************
sum e*
* Subjective Norms:
tab e1value, missing
tab e1diverse, missing
tab e1support, missing
tab e1livable, missing

* Perceived Behavior Control
tab e1resource, missing
tab e1govt, missing
tab e1commun, missing
tab e1improve, missing

* Moral Norms
tab e2harvest, missing
tab e2respect, missing
tab e2maintain, missing
tab e2invest, missing

* Attitude:
tab e3manage, missing
tab e3effort, missing
tab e3wilder, missing
tab e3overall, missing

* Values and Beliefs (Not Reported in Manuscript and Model)
tab e3benefit, missing
tab e3human, missing
tab e3restrict, missing
tab e3time, missing
tab e3balance, missing
tab e3connect, missing
tab e3environ, missing
tab e3noneed, missing

* Response Bias Check
tab datalot f2age, chi
tab datalot f3race, chi
tab datalot f4gender, chi
tab datalot f5job, chi
tab datalot f6educ, chi
tab datalot f7income, chi
********************************************************************************

********************************************************************************
* Variables in Survey (All variables are not used in SEM):
/* Subjective Norms: (Pairwise) Correlations, Covariances */
correlate e1value e1diverse e1support e1livable 
correlate e1value e1diverse e1support e1livable, covariance 
pwcorr e1value e1diverse e1support e1livable, obs sig star(0.05)
pwcorr e1value e1diverse e1support e1livable, obs sig star(0.05) bonferroni
* strongly and positively correlated with each other.

/* Perceived Behavioral Control: (Pairwise) Correlations, Covariances */
correlate e1resource e1govt e1commun e1improve 
correlate e1resource e1govt e1commun e1improve, covariance
pwcorr e1resource e1govt e1commun e1improve, obs sig star(0.05)
pwcorr e1resource e1govt e1commun e1improve, obs sig star(0.05) bonferroni

/* Moral and Ethical Norms: (Pairwise) Correlations, Covariances */
correlate e2*
correlate e2*, covariance
pwcorr e2*, obs sig star(0.05)
pwcorr e2*, obs sig star(0.05) bonferroni
* Moderately correlated.

/* Values and Beliefs (Break down):(Pairwise) Correlations, Covariances */
corr e3benefit e3human e3restrict e3time e3balance e3connect e3environ e3noneed
corr e3benefit e3human e3restrict e3time e3balance e3connect e3environ e3noneed, covariance
pwcorr e3benefit e3human e3restrict e3time e3balance e3connect e3environ e3noneed, obs sig star(0.05)
pwcorr e3benefit e3human e3restrict e3time e3balance e3connect e3environ e3noneed, obs sig star(0.05)bonferroni

/* Attitude: (Pairwise) Correlations, Covariances */
corr e3manage e3effort e3wilder e3overall
corr e3manage e3effort e3wilder e3overall, covariance
pwcorr e3manage e3effort e3wilder e3overall, obs sig star(0.05)
pwcorr e3manage e3effort e3wilder e3overall, obs sig star(0.05) bonferroni

/* Factor Analysis */
factor e1* e2* e3*, factors(6) mineigen(0.5) /* Principle factor analysis; Retain Six factors */
factor e1* e2* e3*, pf /* Principle factor analysis, default */
factor e1* e2* e3*, pcf /* Principle component factor analysis */
factor e1* e2* e3*, ml /*maximum likelihood factor analysis */
factor e1* e2* e3*, ml factors(6) protect(50) seed(439285) /*maximum likelihood factor analysis, perform 50 maximizations with different starting values, set seed for reproducibility */
*******************************************************************************

********************************************************************************
/* Structural Equation Modeling */
/*
Fit measures:
Tucker and Lewis Index (TLI): No smaller than 0.158.
Comparative Fit Index (CFI): 1 or 0. Should be above 0.90 to 1.
RMSEA: 0.01 = Excellent, 0.05 = Good, 0.08 = Mediocre fit. Confidence interval close to zero and no greater than 0.1
SRMR: Perfect fit = 0. Value less than 0.08 is generally considered as a good fit.
AIC, BIC, SABIC, Hoelter Index (# of min. sample for non-significant Chi-squared). Smaller is better.
pclose: Ho: RMSEA = 0.05 & Ha: RMSEA > 0.05. Look for p > 0.05 implies close to fit model.

If model does not fit modify following
	1. Number of variables.
	2. Sample size if possible.
	3. Model Complexity i.e. number of parameters to be estimated.
	4. Check and adjust normality.

/* SEM Model Result Reporting Format:
* Fit Indicators:
	LR Chi2_ms = 
	LR Chi2_ms, p > chi2 = 
	LR Chi2_bs = 
	LR Chi2_bs, p > chi2 = 
	RMSEA (< 0.05:good, <0.08:Mediocre) = 
	pclose (> 0.05, good) = 
	AIC (Smaller, better) = 
	BIC (Smaller, better) = 
	CFI (> 0.90) = 
	TLI (> 0.158)= 
	SRMR (< 0.08, ideally 0) = 	
	CD = 
Description: 
*/
*/
********************************************************************************

********************************************************************************
/* Variables only used in SEM */
/* Validity/Reliability Test using Cronbach's Alpha */
* Used Cronbach's Alpha. 
* Item = item-test and intem-rest correlations.
* details = list individual interitem correlations and covariances.
* reverse = reverse the sign of these variables.

alpha e1value e1diverse e1support e1livable, item detail /* Subjective Norms */
corr e1value e1diverse e1support e1livable /* Subjective Norms */

alpha e1resource e1improve, item detail /* Perceived Behaviour Control*/
corr e1resource e1improve
* r_e1commun gives a better SEM model but nothing else changes.

alpha e2respect e2maintain e2invest, item detail /* Moral Norms */
corr e2harvest e2respect e2maintain e2invest /* Moral Norms */

alpha e3manage e3effort e3wilder e3overall, item detail /* Attitude */
corr e3manage e3effort e3wilder e3overall /* Attitude */

alpha sa7wtp sa9altdist sc6interest, item detail /* Intent */
corr a9altdist a7wtp c6interest /* Intent */
corr sc6interest sa9altdist sa7wtp /* Standardized Intent */
********************************************************************************

********************************************************************************
/* PhD Dissertation: Objective III */

/* Set up Working Directory for result outputs */
* Office Computer:
* cd "C:\Users\bmishra\Dropbox\OSU\PhD\Dissertation\Survey\Data\FinalData\Objective3\TPBTRA" 

/* Macbook */
cd "/Users/bmishra/Dropbox/Professional/PhD/Dissertation/Survey/Data/FinalData/Objective3" 
save "/Users/bmishra/Dropbox/Professional/PhD/Dissertation/Survey/Data/FinalData/Objective3/SEMData.dta", replace
********************************************************************************

********************************************************************************
/* SEM Command with non-normal data: A new normality correction for the RMSEA, CFI, and TLI for n > 200 */
capture program drop robust_gof
program define robust_gof, rclass
version 15

if "`e(cmd)'"!= "sem" {
dis in red "This command only works after sem."
exit 198
}

if "`e(vce)'"!= "sbentler"{
dis in red "This command only works with sem, vce(sbentler) option"
exit 198
}

if "`e(N)'" <= "200" {
dis in red "Sample size is less than 200 in your SEM model. Use swain_gof.ado."
exit 198
}

* Satorra-Bentler-Corrected Statistics
local chi2_ms = `r(chi2_ms)'
local chi2_bs = `r(chi2_bs)'
local chi2sb_ms = `r(chi2sb_ms)'
local chi2sb_bs = `r(chi2sb_bs)'
local df_bs = `r(df_bs)'
local df_ms = `r(df_ms)'
local nobs = `e(N)'
local lb90_rmsea = `r(lb90_rmsea)'
local ub90_rmsea = `r(ub90_rmsea)'

* Calculation of Satorra-Bentler correction factor c_ms und c_bs
local c_ms = `e(sbc_ms)'
local c_bs = `e(sbc_bs)'

* Calculation of robust CFI, TLI, RMSEA
local cfi = `r(cfi)'
local tli = `r(tli)'
local cfi_sb = `r(cfi_sb)'
local tli_sb = `r(tli_sb)'
local rmsea = `r(rmsea)'
local rmsea_sb = `r(rmsea_sb)'
local robust_cfi = 1 - ((`c_ms'/`c_bs')*(1 - `cfi_sb'))
local robust_tli = 1 - ((`c_ms'/`c_bs')*(1 - `tli_sb'))
local robust_rmsea = sqrt(`c_ms')*`rmsea_sb'

* Stores saved resuts in r()
return scalar robust_rmsea = `robust_rmsea'
return scalar robust_cfi = `robust_cfi'
return scalar robust_tli = `robust_tli'

* Display robust fit indices
dis as text "Root Mean Squared Error of Approximation:"
* dis ""
dis as text "MVN-based RMSEA = " as result %6.4f `rmsea'
dis as text "90% Confidence Interval for MVN-based RMSEA:"
dis as text "MVN-based Lower Bound (90%) = " as result %6.4f `lb90_rmsea'
dis as text "MVN-based Upper Bound (90%) = " as result %6.4f `ub90_rmsea'
dis ""
dis as text "Satorra-Bentler Corrected RMSEA = " as result %6.4f `rmsea_sb'
dis ""
dis as text "Robust RMSEA = " as result %6.4f `robust_rmsea'
* dis as text "90% Confidence Interval for robust RMSEA:"
* dis as text "Robust Lower Bound (5%) = " as result %6.4 `rob_rmsea_lb90'
* dis as text "Robust Upper Bound (95%) = " as result %6.4 `rob_rmsea_ub90'
dis ""
dis as text "Incremental Fit-Indices:"
*dis""
dis as text "MVN-based Tucker Lewis Index (TLI) = " as result %6.4f `tli'
dis as text "Satorra-Bentler Corrected TLI = " as result %6.4f `tli_sb'
dis as text "Robust Tucker Lewis Index (TLI) = " as result %6.4f `robust_tli'
dis ""
dis as text "MVN-based Comparative Fit Index (CFI) = " as result %6.4f `cfi'
dis as text "satorra Bentler Corrected CFI = " as result %6.4f `cfi_sb'
dis as text "Robust Comparative Fit Index (CFI) = " as result %6.4f `robust_cfi'
dis ""
end
exit
********************************************************************************

********************************************************************************
/* SEM Command with non-normal data: A new normality correction for the RMSEA, CFI, and TLI for n < 200 */

*! Swain V1, 15 March 2013
*! Authors: John Antonakis & Nicolas Bastardoz, University of Lausanne
*! swain_gof V1, 11 July 2017
*! Modification: Wolfgang Langer 23.08.2018

* swain can be installed using "ssc install". But this package can be installed only in Stata 16.1. I modified swain_gof written by Antonakis and Bastardoz (2013) by adding code from swain ado that can be installed in stata using "ssc install swain" 
* Link: https://econpapers.repec.org/software/bocbocode/s457617.htm

*! Modification: Bijesh Mishra. August 01, 2022. Combined swain_gof and swain into swain_combo (proposed name).which can be installed in Stata 16.1 using "ssc install swain" command. * SWAIN: Stata module to correct the SEM chi-square overidentification test in small sample sizes or complex models

capture program drop swain_combo
  program define swain_combo, rclass
 version 15
    if "`e(cmd)'"!="sem" {
	di in red "This command only works after sem"
	exit 198
	}

  *obtain residuals
  qui: estat residuals
  
  *save residuals as a matrix 
  mat r = r(res_cov)
  
  *count the rows of the matrix (to give number of variables)
  local no_vars = rowsof(r)
  
  *sample size of model
  local N = e(N) 
  
  *df of model
  local df = e(df_ms)
  
  *Chi-square of models
  local chi = e(chi2_ms)  
  local chi_bs = e(chi2_bs)

/* Swain Correction */
  *calculate Swain q
  local swain_q = (sqrt(1+4*(`no_vars')*(`no_vars'+1)-8*`df')-1)/2

* Calculating Swain correction:
  local swain = 1 - ((`no_vars')*(2*(`no_vars'^2) + 3*(`no_vars') - 1) - ///
                `swain_q'*(2*(`swain_q'^2)+3*(`swain_q')-1))/ ///
				(12*`df'*(`N'-1))
			
* Calculating Swain Chi-squared:
  local swain_chi = `swain'*`chi'  
  local p_swain = chi2tail(`df',`swain_chi')

  * Satorra-Bentler-corrected statistics
  local chi_sb = e(chi2sb_ms)
  local chi_sb_bs = e(chi2sb_bs)
  local df_bs = e(df_bs)
  local swain_chi_sb = `swain'*`chi_sb'
  local p_swain_chi_sb = chi2tail(`df',`swain_chi_sb')
  
  *stores saved results in r()
  return scalar swain_p = `p_swain'
  return scalar swain_chi = `swain_chi'
  return scalar swain_corr = `swain'  
 
  return scalar swain_chi_sb = `swain_chi_sb'
  return scalar swain_sb_p = `p_swain_chi_sb'
    
  * Calculation of the TLI, CFI and RMSEA fit indices
  * Under Multinormal Distribution Assumption
  local tli_e1 = `chi_bs' / `df_bs'   
  local tli_e2 = `swain_chi' / `df'
  local swain_tli = (`tli_e1' - `tli_e2') / (`tli_e1' - 1)
  local cfi_e1 = `chi_bs' - `df_bs'  
  local cfi_e2 = `swain_chi'-`df'
  local swain_cfi = (`cfi_e1' - `cfi_e2') / `cfi_e1'
  local swain_rmsea = sqrt((`swain_chi' - `df')/(`N' * `df'))
  
  return scalar swain_tli = `swain_tli'
  return scalar swain_cfi = `swain_cfi'
  return scalar swain_rmsea = `swain_rmsea'
  
  * Under violation of Multinormal Distribution: Satorra-Bentler corrected chi2-values
  local tli_sb_e1 = `chi_sb_bs' / `df_bs'
  local tli_sb_e2 = `swain_chi_sb' / `df' 
  local swain_tli_sb = (`tli_sb_e1' - `tli_sb_e2') / (`tli_sb_e1' - 1)  
  local cfi_sb_e1 = `chi_sb_bs' - `df_bs'
  local cfi_sb_e2 = `swain_chi_sb'-`df'
  local swain_cfi_sb = (`cfi_sb_e1' - `cfi_sb_e2') / `cfi_sb_e1'
  local swain_rmsea_sb = sqrt((`swain_chi_sb' - `df') / (`N' * `df'))
  local swain_mse_sb = ((`swain_chi_sb' - `df') / (`N' * `df'))
  
  return scalar swain_tli_sb = `swain_tli_sb'
  return scalar swain_cfi_sb = `swain_cfi_sb'
  return scalar swain_rmsea_sb = `swain_rmsea_sb'
  return scalar swain_mse_sb = `swain_mse_sb'

  dis ""
  dis as text "Recap of Data Entered:"
  dis as result "Number of variables in model = "`no_vars'
  dis as result "Df of model = " `df'
  dis as result "Size of model (N) = " `N'
  dis as result "Chi-square of model = " `chi'
  dis as result "p-value of chi-square of model = " chi2tail(`df',`chi')
  dis ""
  dis as text "Fit indices under assumption of multivariate normal distribution:"
  dis as result "Swain correction factor = " %6.4f `swain' 
  dis as result "Swain corrected chi-square = " `swain_chi' 
  dis as result "p-value of Swain corrected chi-square  = " %6.4f `p_swain' 
  dis ""
  dis as text "Swain correction fit statistics:"
  dis as result "Swain corrected Tucker Lewis Index = " %6.4f `swain_tli'
  dis as result "Swain corrected Comparative Fit Index = " %6.4f `swain_cfi'
  dis as result "Swain corrected RMSEA = " %6.4f `swain_rmsea'
  dis ""
  dis as text "Fit indices under violation of multivariate normal distribution"
  dis as text "Satorra Bentler corrected statistics: "
  dis as result "Swain Satorra Bentler corrected Chi-square = " `swain_chi_sb'
  dis as result "p-value of Swain Satorra Bentler corrected Chi-square = " ///
       %6.4f `p_swain_chi_sb'
  dis ""
  dis as result "Swain Satorra Bentler corrected Tucker Lewis Index = " %6.4f `swain_tli_sb'
  dis as result "Swain Satorra Bentler corrected Comparative Fit Index = " %6.4f `swain_cfi_sb'
  dis in result "Swain Satorra Bentler corrected RMSEA = " %6.4f `swain_rmsea_sb'
 dis in result "Swain Satorra Bentler corrected MSE = " %6.4f `swain_mse_sb'

/* F-test */
local f_test = `chi'/`df'
  local f_test_p = Ftail(`df',`N'-1,`f_test')
  local yuan_chi = (`N'-(2.381 + 0.367*`no_vars' + 0.003*((`no_vars'*(`no_vars'+1)/2)-`df'-2*`no_vars')))*`chi'/(`N'-1)
  local yuan_p = chi2tail(`df',`yuan_chi') 

  return scalar f_test = `f_test'
  return scalar f_test_p = `f_test_p'
  return scalar yuan_chi = `yuan_chi'
  return scalar yuan_p = `yuan_p'
  
dis ""
  dis as text "Empirical correction statistics"
  dis in result "Yuan Tian-Yanagihara empirically corrected chi-square = " `yuan_chi'
  dis in result "p-value of Yuan Tian Yanagihara empirically corrected chi-square = "`yuan_p'
  dis ""   
  dis in result "F-test statistics"
  dis in result "F-test value = " `f_test'
  dis in result "p-value of the F-test = " `f_test_p'
dis ""	
  end
  exit
********************************************************************************

********************************************************************************
/* REPORTED MODELS IN MANUSCRIPT: Four Models One Table */
* TRA: (SEM Builder: TRA)
sem (SUBNORM -> e1value e1diverse e1support e1livable, ) ///
    (SUBNORM -> INTENT, ) ///
    (ATTITUDE -> e3manage e3effort e3wilder e3overall, ) ///
    (ATTITUDE -> INTENT, ) ///
    (INTENT -> sc6interest sa9altdist sa7wtp, ), ///
    covstruct(_lexogenous, diagonal) ///
    latent(SUBNORM ATTITUDE INTENT) ///
    cov(SUBNORM*ATTITUDE) nocapslatent standardized vce(sbentler)
estat gof, stat(all) /* Goodness of Fit */
swain_combo
swain_gof
estat framework, standardized /* Latent Constructs */
estat eqgof /* Equation level goodness of Fit */

* TRAMoral: (SEM Builder: TRAMoral)
sem (SUBNORM -> e1value e1diverse e1support e1livable, ) ///
    (SUBNORM -> MORAL, ) ///
    (SUBNORM -> INTENT, ) ///
    (MORAL -> e2respect e2maintain e2invest, ) ///
    (MORAL -> INTENT, ) ///
    (ATTITUDE -> MORAL, ) ///
    (ATTITUDE -> e3manage e3effort e3wilder e3overall, ) ///
    (ATTITUDE -> INTENT, ) ///
    (INTENT -> sc6interest sa9altdist sa7wtp, ), ///
    covstruct(_lexogenous, diagonal) ///
    latent(SUBNORM MORAL ATTITUDE INTENT ) ///
    cov(SUBNORM*ATTITUDE) nocapslatent standardized vce(sbentler)
estat gof, stat(all) /* Goodness of Fit */
swain_combo
estat framework, standardized /* Latent Constructs */
estat eqgof /* Equation level goodness of Fit */

* TPB: (SEM Builder:TPB)
sem (SUBNORM -> e1value e1diverse e1support e1livable, ) ///
    (SUBNORM -> INTENT, ) ///
    (PBC -> e1resource e1improve, ) ///
    (PBC -> INTENT, ) ///
    (ATTITUDE -> e3manage e3effort e3wilder e3overall, ) ///
    (ATTITUDE -> INTENT, ) ///
    (INTENT -> sc6interest sa9altdist sa7wtp, ), ///
    covstruct(_lexogenous, diagonal) ///
    latent(SUBNORM PBC ATTITUDE INTENT ) ///
    cov(SUBNORM*ATTITUDE PBC*SUBNORM PBC*ATTITUDE) nocapslatent ///
    standardized vce(sbentler)
estat gof, stat(all) /* Goodness of Fit */
swain_combo
estat framework, standardized /* Latent Constructs */
estat eqgof /* Equation level goodness of Fit */

* TPBMoral: (SEM Builder: TPBMoral).
sem (SUBNORM -> e1value e1diverse e1support e1livable, ) ///
    (SUBNORM -> INTENT, ) ///
    (SUBNORM -> MORAL, ) ///
    (PBC -> e1resource e1improve, ) ///
    (PBC -> INTENT, ) ///
    (PBC -> MORAL, ) ///
    (ATTITUDE -> e3manage e3effort e3wilder e3overall, ) ///
    (ATTITUDE -> INTENT, ) ///
    (INTENT -> sc6interest sa9altdist sa7wtp, ) ///
    (MORAL -> INTENT, ) ///
    (MORAL -> e2respect e2maintain e2invest, ), ///
    covstruct(_lexogenous, diagonal) ///
    latent(SUBNORM PBC ATTITUDE INTENT MORAL ) ///
    cov( SUBNORM*ATTITUDE PBC*SUBNORM PBC*ATTITUDE) nocapslatent ///
    standardized vce(sbentler)
estat gof, stat(all) /* Goodness of Fit */
robust_gof
swain_combo
keep if e(sample)
sum c6interest a9altdist a7wtp
estat summarize
estat framework, standardized /* Factor loading in Latent Constructs */
estat eqgof /* Equation level goodness of Fit */
********************************************************************************
