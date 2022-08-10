/* Looping to import multiple datasheet from a single excel sheet */
cd "/Users/bmishra/Dropbox/OSU/PhD/Dissertation Project/Survey Part/Survey Data/Katelyn Jeffries Work"
import excel "Data Files/SurveyData04012020.xlsx", describe
forvalues sheet=1/`=r(N_worksheet)' {
  local sheetname=r(worksheet_`sheet')
  import excel "Data Files/SurveyData04012020.xlsx", sheet("`sheetname'") clear firstrow
  save "Data Files/SurveyData04012020_`sheet'", replace
}
forvalues i = 1/7{
	 use  "Data Files/SurveyData04012020_`i'", clear
	 capture drop if SurveyNo==0 | missing(SurveyNo)
	 save  "Data Files/SurveyData04012020_`i'", replace

}
use "Data Files/SurveyData04012020_1.dta" , clear
forvalues i = 2/7{
	 merge 1:1 SurveyNo using  "Data Files/SurveyData04012020_`i'", gen(_`i')

}
/* looping complete */
