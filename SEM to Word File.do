********************************************************************************
* Title: Export Structural Equation Modeling Results in Stata to word file.
* Short title: SEM to Word File.do
* Created by: Bijesh Mishra
* Created on: December 22, 2020
* Purpose: This [SEM to Word File.do] file contain code to export Strutural Equation Modeling result to word file directly.
* Improvement Needed: This file generates goodness of fit, and indirect effect tables as well. But those tables should be typed into word file manually. 
/* Modification Documentation */
* Modified on (Date):
* Modified by (Person):
* Modifications:
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
estat gof, stat(all) /* Goodness of Fit Statistics */
estat teffects, standardized /* Direct and Indirect Effects */
estat ginvariant /* Group Variance of Paraameters, if multiple groups */

/* SEM Model 2 */
sem () /* Paste code for second SEM Model in this line after deleting this line. The code should start with "sem" or "gsem". */

putdocx paragraph, halign(center)
putdocx text ("Give a name to the table"), bold
putdocx table results = etable
est store sem2 /* Store estimate of above model as sem2 table */
estat gof, stat(all) /* Goodness of Fit Statistics */
estat teffects, standardized /* Direct and Indirect Effects */
estat ginvariant /* Group Variance of Paraameters, if multiple groups */

/* SEM Model 3 */
sem () /* Paste code for third SEM Model in this line after deleting this line. The code should start with "sem" or "gsem". */

putdocx paragraph, halign(center)
putdocx text ("Give a name to the table"), bold
putdocx table results = etable
est store sem3 /* Store estimate of above model as sem3 table */
estat gof, stat(all) /* Goodness of Fit Statistics */
estat teffects, standardized /* Direct and Indirect Effects */
estat ginvariant /* Group Variance of Paraameters, if multiple groups */

putdocx paragraph, halign(center)
putdocx text ("Side by Side Comparison of Coefficient Estimates from Above Three Models."), bold
putdocx paragraph, halign(center)
putdocx text ("sem1 = Name, sem2 = Name sem3 = Name")
estimates table sem1 sem2 sem3, star /* One table for sem1, sem2 & sem3 */
putdocx table results = etable /* Print above table into word file */
putdocx paragraph, halign(center)
putdocx text ("Legend: * = p < 0.05; ** = p<0.01; *** = p<0.001"), bold

putdocx save WordFileName.docx, replace  /* Name Word File */
