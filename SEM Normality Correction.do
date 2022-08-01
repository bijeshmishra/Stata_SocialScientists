********************************************************************************
* Title: Sem Normality Correction
* Created by: Bijesh Mishra
* Purpose: Code for normality correction for small and large sample data in Structural Equation Modeling.
********************************************************************************

********************************************************************************
clear all
/* Set up Working Directory and Import Data: */
cd "/path/to/data" /* Change Working Directory */
import delimited "/import/data.csv" /* Import Data */
********************************************************************************

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

  *calculate Swain q
  local swain_q = (sqrt(1+4*(`no_vars')*(`no_vars'+1)-8*`df')-1)/2

* Calculating Swain correction:
  local swain = 1 - ((`no_vars')*(2*(`no_vars'^2) + 3*(`no_vars') - 1) - ///
                `swain_q'*(2*(`swain_q'^2)+3*(`swain_q')-1))/ ///
				(12*`df'*(`N'-1))
			
* Calculating Swain Chi-squared, Yian Chi-squared and p-value:
  local swain_chi = `swain'*`chi'  
  local p_swain = chi2tail(`df',`swain_chi') 
  local f_test = `chi'/`df'
  local f_test_p = Ftail(`df',`N'-1,`f_test')
  local yuan_chi = (`N'-(2.381 + 0.367*`no_vars' + 0.003*((`no_vars'*(`no_vars'+1)/2)-`df'-2*`no_vars')))*`chi'/(`N'-1)
  local yuan_p = chi2tail(`df',`yuan_chi') 

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
  return scalar f_test = `f_test'
  return scalar f_test_p = `f_test_p'
  return scalar yuan_chi = `yuan_chi'
  return scalar yuan_p = `yuan_p'
  
  * Calculation of the TLI, CFI and RMSEA fit indices
  * Under Multinormal Distribution Assumption
  local tli_e1 = `chi_bs' / `df_bs'   
  local tli_e2 = `swain_chi' / `df'
  local swain_tli = (`tli_e1' - `tli_e2') / (`tli_e1' - 1)
  local cfi_e1 = `chi_bs' - `df_bs'  
  local cfi_e2 = `swain_chi'-`df'
  local swain_cfi = (`cfi_e1' - `cfi_e2') / `cfi_e1'
  local swain_rmsea = sqrt((`swain_chi'-`df') / (`N'*`df'))

  return scalar swain_tli = `swain_tli'
  return scalar swain_cfi = `swain_cfi'
  return scalar swain_rmsea = `swain_rmsea'
  
  * Under violation of Multinormal Distribution: Satorra-Bentler corrected chi2-values
  local tli_sb_e1 = `chi_sb_bs' / `df_bs'
  local tli_sb_e2 = `swain_chi_sb' / `df' 
  local swain_tli_sb=(`tli_sb_e1' - `tli_sb_e2') / (`tli_sb_e1' - 1)  
  local cfi_sb_e1 = `chi_sb_bs' - `df_bs'
  local cfi_sb_e2 = `swain_chi_sb'-`df'
  local swain_cfi_sb = (`cfi_sb_e1' - `cfi_sb_e2') / `cfi_sb_e1'
  local swain_rmsea_sb = sqrt((`swain_chi_sb' - `df') / (`N'*`df'))	
  
  return scalar swain_tli_sb = `swain_tli_sb'
  return scalar swain_cfi_sb = `swain_cfi_sb'
  return scalar swain_rmsea_sb = `swain_rmsea_sb'
	
  dis ""
  dis "Fit indices under assumption of multivariate normal distribution:"
  dis ""
  dis in result "Swain correction factor = " as result %6.4f `swain' 
  dis "Swain corrected chi-square = " `swain_chi' 
  dis "p-value of Swain corrected chi-square  = " as result %6.4f `p_swain' 
  dis ""
  dis "Swain correction fit statistics:"
  dis "Swain corrected Tucker Lewis Index = " as result %6.4f `swain_tli'
  dis "Swain corrected Comparative Fit Index = " as result %6.4f `swain_cfi'
  dis "Swain correct RMSEA = " as result %6.4f `swain_rmsea'
  dis ""
  dis "Fit indices under violation of multivariate normal distribution"
  dis "" 
  dis "Satorra-Bentler-corrected statistics: "
  dis "Swain-Satorra-Bentler corrected Chi-square = " `swain_chi_sb'
  dis "p-value of Swain Satorra Bentler corrected chi-square = " ///
      as result %6.4f `p_swain_chi_sb'
  dis ""
  dis "Swain Satorra Bentler corrected Tucker Lewis Index = " as result %6.4f `swain_tli_sb'
  dis "Swain Satorra Bentler corrected Comparative Fit Index = " as result %6.4f `swain_cfi_sb'
  dis "Swain Satorra Bentler correct RMSEA = " as result %6.4f `swain_rmsea_sb'
  dis ""
  dis in result"Empirical correction statistics"
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
swain_gof /* swain_gof.ado for small sample */
robust_gof /* robust_gof.ado for large sample */
estat framework, standardized /* Latent Constructs */
estat eqgof /* Equation level goodness of Fit */
********************************************************************************
References:
Small Sample:
https://langer.soziologie.uni-halle.de/stata/index.html
https://langer.soziologie.uni-halle.de/stata/pdf/Langer-German-Stata-Users-Group-Meeting-2018.pdf
https://langer.soziologie.uni-halle.de/stata/ado/swain_gof.sthlp
https://langer.soziologie.uni-halle.de/stata/ado/swain_gof.ado
https://econpapers.repec.org/software/bocbocode/s457617.htm

Large Sample:
https://langer.soziologie.uni-halle.de/stata/pdf/Langer-German-Stata-Users-Group-Meeting-2019.pdf
https://langer.soziologie.uni-halle.de/stata/ado/robust_gof.sthlp
https://langer.soziologie.uni-halle.de/stata/ado/robust_gof.ado
