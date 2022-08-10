/* Report Result in Word File Using Putdocx command in Stata */
/* Clear all active stuffs in stata, set up working directory, and import desired datafile to work with. */
clear all
cd "C:\Users\Path\to\data\file" /* Change Working Directory */
import delimited "C:\Users\path\to\data\file\datafilename.csv" /* Import Data */

/* Clear all active word file in the system and activate new word file to put results that are going to be created later on */

putdocx clear
putdocx begin

/* Paste your model code after this line */
sem (SUBNORM -> e1value e1diverse e1support e1livable,) ///
	(PBCONT -> e1resource e1commun e1improve,) /// 
	(ATTITUDE -> e3manage e3effort e3wilder e3overall,) ///
	(ACTMGMT -> a1hunted a2huntyrs a6deer a8travel c3active,) ///
	(ACTMGMT -> SUBNORM PBCONT ATTITUDE,), iterate(50) ///
	latent(SUBNORM PBCONT ATTITUDE ACTMGMT ) ///
	cov(e.SUBNORM*e.PBCONT e.SUBNORM*e.ATTITUDE e.PBCONT*e.ATTITUDE)
/* End of Model Code */
putdocx paragraph, halign(center)
/* Give Heading to the Model Developed Above */
putdocx text ("Active Management: Theory of Planned Behavior without Moral Norms."), bold
putdocx table results = etable /* Saves model as table in word file */
/* Note: Everytime you write a new model and want to develop a seperate table for each model in word file, you have to repeat above codes. */
estat gof, stat(all) /* Goodness of Fit Statistics */
/* Note: The Goodness of Fit should be estimated after running code to put above model into word file. */
/* This is complete code for above model. You may have to manually develop GOF table in word after exporting above model into word. I am still exploring method to export GOF table into word using stata */
est store sem1 /* Store estimate of above model as sem1 table */
/* Above line of codes helps to compare two models simultaneously in single table. Follow the code to know more details*/ 

/* This code below repeats same procedure as above but for another model. */
sem (SUBNORM -> e1value e1diverse e1support e1livable,) ///
	(MORAL -> e2harvest e2respect e2maintain e2invest,) ///
	(PBCONT -> e1resource e1commun e1improve,) /// 
	(ATTITUDE -> e3manage e3effort e3wilder e3overall,) ///
	(ACTMGMT -> a1hunted a2huntyrs a6deer a8travel c3active,) ///
	(ACTMGMT -> SUBNORM MORAL PBCONT ATTITUDE,), iterate(50) ///
	latent(SUBNORM MORAL PBCONT ATTITUDE ACTMGMT) ///
	cov(e.SUBNORM*e.MORAL e.SUBNORM*e.PBCONT e.SUBNORM*e.ATTITUDE ///
	e.MORAL*e.PBCONT e.MORAL*e.ATTITUDE)
putdocx paragraph, halign(center)
putdocx text ("Active Management: Theory of Planned Behavior with Moral Norms."), bold
putdocx table results = etable /* Saves model as table in word file */
estat gof, stat(all) /* Goodness of Fit Statistics */
est store sem2 /* Store estimate of above model as sem2 table */
/* This code line was repeated above and the estimate table was stored as sem1. Here it is stored as sem2. */
/* The code below put sem1 and sem2 models in single table along with variable names, stars indicating significant or not significant */
putdocx paragraph, halign(center)
putdocx text ("Side by Side Comparison of Coefficient Estimates from Above Two Models."), bold
estimates table sem1 sem2, eform star /* Develop single table for sem1 & sem2 */
putdocx table results = etable /* Print above tables (sem1 & sem2) into word file */
/* This code below print meaning of stars below the table comparing estimated coefficients of two models. Everytime you want to create a new paragraph, you have to repeat codes below. */
putdocx paragraph, halign(center)
putdocx text ("Legend: * = p < 0.05; ** = p<0.01; *** = p<0.001"), bold
/* Save all results and tables generated above in word file, close word file and save into current working directory. */
putdocx save exportintoword.docx, replace


/* Exports Models and required statistics in one table using esttaab*/

* Theory of Reasoned Action, Modified (ATTITUDE to DHUNT) (SEM Builder: TRAModif)
eststo: quietly /// /* Run model quietly and store */
sem (SUBNORM -> e1value e1diverse e1support e1livable, ) ///
	(SUBNORM -> INTENT, ) ///
	(ATTITUDE -> e3manage e3effort e3wilder e3overall, ) ///
	(ATTITUDE -> DHUNT, ) ///
	(ATTITUDE -> INTENT, ) ///
	(DHUNT -> a1hunted a2huntyrs a8travel a3pgame , ) ///
	(INTENT -> DHUNT, ) ///
	(INTENT -> a9altdist a7wtp c6interest , ), ///
	covstruct(_lexogenous, diagonal) ///
	latent(SUBNORM ATTITUDE DHUNT INTENT ) ///
	cov( SUBNORM*ATTITUDE) nocapslatent

* Theory of Reasoned Action with Moral Norms (SEM Builder: TRAMoral)
eststo: quietly ///
sem (SUBNORM -> e1value e1diverse e1support e1livable, ) ///
	(SUBNORM -> MORAL, ) ///
	(SUBNORM -> INTENT, ) ///
	(MORAL -> e2harvest e2respect e2maintain e2invest, ) ///
	(MORAL -> INTENT, ) ///
	(ATTITUDE -> MORAL, ) ///
	(ATTITUDE -> e3manage e3effort e3wilder e3overall, ) ///
	(ATTITUDE -> DHUNT, ) ///
	(ATTITUDE -> INTENT, ) ///
	(DHUNT -> a1hunted a2huntyrs a8travel a3pgame , ) ///
	(INTENT -> DHUNT, ) ///
	(INTENT -> a9altdist a7wtp c6interest, ), ///
	covstruct(_lexogenous, diagonal) ///
	latent(SUBNORM MORAL ATTITUDE DHUNT INTENT ) ///
	cov( SUBNORM*ATTITUDE) nocapslatent

/*
esttab using TRA.rtf, wide se replace ///
	star(* 0.10 ** 0.05) ///
	nonumbers mtitle ("TRA" "TRA-moral") ///
	title ("Theory of Reasoned Action without and with Moral Norms") ///
	addnote ("Data Source: PhD Dissertation Survey Data 2020")
eststo clear /* Removes models stored in the memory */
*/

* Theory of Planned Behvaior, Modified (PBC to DHUNT) (SEM Builder: TPBModif)
eststo: quietly ///
sem (SUBNORM -> e1value e1diverse e1support e1livable, ) ///
	(SUBNORM -> INTENT, ) ///
	(PBC -> e1resource e1commun e1improve, ) ///
	(PBC -> DHUNT, ) ///
	(PBC -> INTENT, ) ///
	(ATTITUDE -> e3manage e3effort e3wilder e3overall, ) ///
	(ATTITUDE -> INTENT, ) ///
	(DHUNT -> a1hunted a2huntyrs a8travel a3pgame, ) ///
	(INTENT -> DHUNT, ) ///
	(INTENT -> a9altdist a7wtp c6interest, ), ///
	covstruct(_lexogenous, diagonal) ///
	latent(SUBNORM PBC ATTITUDE DHUNT INTENT PBC) ///
	cov( SUBNORM*ATTITUDE PBC*SUBNORM PBC*ATTITUDE) nocapslatent

* Theory of Planned Behvaior with Moral Norms (PBC, SN to MORAL, ATTITUDE to DHUNT) (SEM Builder: TPBMoral2).
eststo: quietly ///
sem (SUBNORM -> e1value e1diverse e1support e1livable, ) ///
	(SUBNORM -> INTENT, ) ///
	(SUBNORM -> MORAL, ) ///
	(PBC -> e1resource e1commun e1improve, ) ///
	(PBC -> INTENT, ) ///
	(PBC -> MORAL, ) ///
	(ATTITUDE -> e3manage e3effort e3wilder e3overall, ) ///
	(ATTITUDE -> DHUNT, ) ///
	(ATTITUDE -> INTENT, ) ///
	(DHUNT -> a1hunted a2huntyrs a8travel a3pgame, ) ///
	(INTENT -> DHUNT, ) ///
	(INTENT -> a9altdist a7wtp c6interest, ) ///
	(MORAL -> INTENT, ) ///
	(MORAL -> e2harvest e2respect e2maintain e2invest, ), ///
	covstruct(_lexogenous, diagonal) ///
	latent(SUBNORM PBC ATTITUDE DHUNT INTENT MORAL ) ///
	cov( SUBNORM*ATTITUDE PBC*SUBNORM PBC*ATTITUDE) nocapslatent
/*
esttab using TPB.rtf, wide se replace ///
	star(* 0.10 ** 0.05) ///
	nonumbers mtitle ("TPB" "TPB-moral") ///
	title ("Theory of Planned Behavior without and With Moral Norms") ///
	addnote ("Data Source: PhD Dissertation Survey Data 2020")
eststo clear
*/

esttab using TRA_TPB_z.rtf, wide z onecell replace ///
scalars(F df_m df_r) /// 
star(* 0.10 ** 0.05) ///
nonumbers mtitle ("TRA" "TRA-moral" "TPB" "TPB-moral") ///
title ("Theory of Planned Behavior and Theory of Reasoned Action without and With Moral Norms") ///
addnote ("Data Source: PhD Dissertation Survey Data 2020.")

esttab using TRA_TPB_se.rtf, wide se replace /// /* se, z, p, ci, and aux() */
scalars(F df_m df_r) /// 
star(* 0.10 ** 0.05) ///
nonumbers mtitle ("TRA" "TRA-moral" "TPB" "TPB-moral") ///
title ("Theory of Planned Behavior and Theory of Reasoned Action without and With Moral Norms") ///
addnote ("Data Source: PhD Dissertation Survey Data 2020.")

eststo clear

