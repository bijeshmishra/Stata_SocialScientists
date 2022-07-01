********************************************************************************
* Title: Export Structural Equation Modeling Results in Stata to word file.
* Short title: SEM to Word File.do
* Created by: Bijesh Mishra
* Created on: December 22, 2020
* Purpose: This [SEM to Word File.do] file contain code to export Strutural Equation Modeling result to word file directly. This file also has decision making criteria regarding SEM model fit. But theoritical knowledge about the actual model is very important. Models generating ideal values for model fit does not means the model is right. Theoritical validation of model is important.

* Improvement Needed: This file generates goodness of fit, and indirect effect tables as well. But those tables should be typed into word file manually.
/* Modification Documentation */
* Modified on (Date):
* Modified by (Person):
* Modifications:
********************************************************************************
********************************************************************************

/* Compile SEM Model in a word file and compare three models in single table */

putdocx clear
putdocx begin

/* SEM Model 1 */
sem () /* Paste code for SEM Model in this line after deleting this line. The code should start with "sem" or "gsem". */

putdocx paragraph, halign(center)
putdocx text ("Give a name to the table"), bold
putdocx table results = etable
est store sem1 /* Store estimate of above model as sem1 table */

/* SEM Model 2 */
sem () /* Paste code for second SEM Model in this line after deleting this line. The code should start with "sem" or "gsem". */

putdocx paragraph, halign(center)
putdocx text ("Give a name to the table"), bold
putdocx table results = etable
est store sem2 /* Store estimate of above model as sem2 table */

/* SEM Model 3 */
sem () /* Paste code for third SEM Model in this line after deleting this line. The code should start with "sem" or "gsem". */

putdocx paragraph, halign(center)
putdocx text ("Give a name to the table"), bold
putdocx table results = etable
est store sem3 /* Store estimate of above model as sem3 table */

/*Create a table to compare SEM results from above three models side by side */
putdocx paragraph, halign(center)
putdocx text ("Side by Side Comparison of Coefficient Estimates from Above Three Models."), bold
putdocx paragraph, halign(center)
putdocx text ("sem1 = Name, sem2 = Name sem3 = Name")
estimates table sem1 sem2 sem3, star /* One table for sem1, sem2 & sem3 */
putdocx table results = etable /* Print above table into word file */
putdocx paragraph, halign(center)
putdocx text ("Legend: * = p < 0.05; ** = p<0.01; *** = p<0.001"), bold

putdocx save WordFileName.docx, replace  /* Name Word File */

/* Post Model Estimations for SEM in STATA */
estat eform /* Display exponentiated coefficients with gsem only. */
estat eqgof /* Display equation-level goodness of fit statistics */
estat eqtest /* Equation level test that all coefficients are zero */
estat framework /* Display estimation results in the modeling framework */
estat ggof, stat (all) /* Group level goodness of fit statistics */
estat ginvariant /* Test for invariaance of parameters across group */
estat gof, stat(all) /* Goodness of fit statistics */
estat lcgof /* Latent class goodness of fit statistics */
estat lcmean /* Latent class marginal means */
estat lcprob /* Latent class marginal probabilities */
estat mindices /* Modification Indices */
estat residuals /* Display mean and covariane residuals */
estat socretests /*Score tests */
estat sd /* Dispaly variance components as sandard deviations and correlations */
estat stable /*Check stability of nonrecursive system */
estat stdize /* Test standardized parameters */
estat summarize /* Report summary staistics for estimation sample */
estat teffects /* Decompositin of effects into total, direct and indirect effects */
