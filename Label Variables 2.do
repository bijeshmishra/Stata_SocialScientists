********************************************************************************
* Title: Label, Define and Describe Variables.
* Short title: Label Variables.do
* Created by: Bijesh Mishra
* Created on: December 22, 2020
* Purpose: This [Label Variables.do] file contain code to label variables, define them and describe variables in a dataset and develop a codebook. This file has codes to label binary, likert scale, and continuous variables, define and describe them. This file also has code to develop codebook after labeling variables.
* Improvement Needed: Learn how to export codebook in a pdf format. 
/* Modification Documentation */
* Modified on (Date):
* Modified by (Person):
* Modifications:
********************************************************************************

/* Label The Data: Variable, Values */
/* Define Labels: This step only defines labels of variables. Attach this levels to Variables */
label define datatech 1 "Katelyn" 2 "Madison" 3 "Bijesh"
label define surveylot 1 "Before first postcard follow up" 2 "After first postcard follow up" 3 "After Second Lot Survey Mailing" 4 "After second lot postcard follow up"
label define binary 1 "Yes" 0 "No" /*Label defined as "binary" but not attached with variable. */
label define sixscale 0 "Not Important" 1 "Least Important" 2 "Slightly Important" 3 "Moderately Important" 4 "very Important" 5 "Extremly Important"
label define fivescale 1 "Strongly Disagree" 2 "Disagree" 3 "Neutral" 4 "Agree" 5 "Strongly Agree"
label define education 1 "Less than High School" 2 "High School or GED" 3 "Some College" 4 "Bachelor's Degree" 5 "Associate or Technical Degree" 6 "Graduate Degree"
label define income2018 1 "Below $25K" 2 "25K to 50K" 3 "50K to 75K" 4 "75K to 100K" 5 "100K to 125K" 6 "125K to 150K" 7 "150K to 200K" 8 "Above 200K" 0 "No Answer"
label define yourrace 1 "White American" 2 "African American" 3 "Native American" 4 "Others" 5 "More than One"
label define yourgender 1 "Female" 0 "Male"

/* Define the variable and also attach above defined labels as values to variables */
label variable datalot "Lot of Survey Received"
label variable dataentry "Person entering data"
label variable datalot "timing of survey received"
label variable surveyno "Survey number given to each respondent"
label variable a1hunted "Have you hunted in Oklahoma in the last five years?" /* Describe Variable */
label variable a2huntyrs "How long have you hunting in Oklahoma?"
label variable a3pgame "Is deer often your primary gaming species in Oklahoma?"
label variable a4lease "Do you lease land for deer hunting?"
label variable a5lacr "If you lease land for deer hunting, how much do you currently lease?"
label variable a6deer "How many deer do you generally observe per visit in your regular hunting site?"
label variable a7dwtp "Assume that you do not observe any deer in your regular hunting site. How many dollar per acre are you willing to spend to maintain the deer population you genrally observe in that site to receive desired hunting experience?"
label variable a8travel "How many miles do you travel one way to go to your regular deer hunting site?"
label variable a9altdist "If you could not go to the site that you regularly hunt deer, how far would you drive one way to to to another deer hunting site of about the same quality?"
label variable c1ownyrs "How long have you/your family owned the forest or range (Eg. Bush, grazing lands)?"
label variable c2livprod "How important is Livestock Production as an objective of forest, rangeland and deer habitat management for you?"
label variable c2rhunt "How important is Recreational Hunting as an objective of forest, rangeland and deer habitat management for you?"
label variable c2rnhunt "How important is Recreational but not Hunting as an objective of forest, rangeland and deer habitat management for you?"
label variable c2tour "How important is Tourism as an objective of forest, rangeland and deer habitat management for you?"
label variable c2lndinv "How important is Land Investment as an objective of forest, rangeland and deer habitat management for you?"
label variable c2ntfp "How important is Non-timber Forest Product as an objective of forest, rangeland and deer habitat management for you?"
label variable c2wildlife "How important is Wildlife Management as an objective of forest, rangeland and deer habitat management for you?"
label variable c2timber "How important is Timber production as an objective of forest, rangeland and deer habitat management for you?"
label variable c2biodiv "How important is Enhance plant and animal diversity (Biodiversity) as an objective of forest, rangeland and deer habitat management for you?"
label variable c3active "Have you conducted active management of your foret or rangeland that involves the removal of unwanted trees, weed control, and prescribed burn?"
label variable c4cost "Cost as major obstacle in implementing active management"
label variable c4time "Time as major obstacle in implementing active management"
label variable c4fire "Fire as major obstacle in implementing active management"
label variable c4herb "Herbicidal risk as major obstacle in implementing active management"
label variable c4know "Knowledge as major obstacle in implementing active management"
label variable c4govt "Governmental policy as major obstacle in implementing active management"
label variable c4noben "Economic benefit as major obstacle in implementing active management"
label variable c4noprac "Practability as major obstacle in implementing active management"
label variable c4rent "Property Rented as major obstacle in implementing active management"
label variable c4live "Living Away as major obstacle in implementing active management"
label variable c4others "Other major obstacle in implementing active management"
label variable c5aware "Are you aware that active management can enhance fodder, forage and timber production in your forest or rangeland?"
label variable c6interest "Are you interested in knowing more about active forest or rangeland management in Oklahaoma?"
label variable c7fact "Fact sheet as source of information about active management"
label variable c7conf "Conference,workshop or field day as source of information about active management"
label variable c7network "Networking with professionals as source of information about active management"
label variable c7meeting "One to one meeting with an expert as source of information about active management"
label variable c7internet "Internet, email and e-newsletter as source of information about active management"
label variable c7family "Information sharing with friends/family as source of information about active management"
label variable c7usda "USDA, NRCS, and US Forest Service as source of information about active management"
label variable c7uni "Universities, schools and research institutes as source of information about active management"
label variable c7radio "Radio TV and podcasts as source of information about active management"
label variable c7smedia "Social Media (Facebook & Twitter) as source of information about active management"
label variable d1remove "Have you ever removed dead trees or branches destroyed by wind, tornado or snow?"
label variable d1barrier "Have you ever built a barrier to manage flash floods?"
label variable d1irrigate "Have you ever irrigated rangeland or forest following a severe drought?"
label variable d1fence "Have you ever build fencing or planted windbreaks to protect property from severe winds?"
label variable d1plant "Have you ever changed trees, plants or species to adjust to changing weather?"
label variable d1aband "Have you ever abandoned forest or rangeland for a short or long time after damage?"
label variable d1restore "Have you ever replated or restored forest and rangeland following severe damage?"
label variable d1others "Other resons (Specify)"
label variable d2drought "How much drought and erratic rainfall pattern influence your forest, rangeland and deer habitat management decision?"
label variable d2flood "How much severe rainfall and flash flooding influence your forest, rangeland and deer habitat management decision?"
label variable d2temp "How much rise in temperature influence your forest, rangeland and deer habitat management decision?"
label variable d2wind "How much erratic wind velocity and direction influence your forest, rangeland and deer habitat management decision?"
label variable d2snow "How much frequent snowfall influence your forest, rangeland and deer habitat management decision?"
label variable d2wfire "How much frequent wildfire influence your forest, rangeland and deer habitat management decision?"
label variable d2tornado "How much tornado and wind damages influence your forest, rangeland and deer habitat management decision?"
label variable e1value "sustainable management of forest, rangeland and deer habitat is important to the people I value most."
label variable e1diverse "My family and friends think that forest, rangeland and deer habitat management could enhance plant and animal diversity."
label variable e1support "My family and friends are supportive of forest, rangeland and deer habitat management activities."
label variable e1livable "My family and friends think that forest, rangeland and deer habitat management would make our environment livable"
label variable e1resource "I have resources and opportunities to manage my land for forest, rangeland and deer habitat management."
label variable e1govt "It would be difficult to conduct forest, rangeland and deer habitat management without government support."
label variable e1commun "It would be difficult to conduct forest, rangeland and deer habitat management without support from the community."
label variable e1improve "I think that I can improve forest, rangeland and deer habitat on my property by actively managing them."
label variable e2harvest "Excessive harvesting of natural resource may limit their use for the future generation."
label variable e2respect "I give respect and courtesy to people who are involved in forest, rangeland and deer habitat management."
label variable e2maintain "I feel that I should actively manage forest, rangeland and deer habitat on my property to maintain habitat for deer and wildlife."
label variable e2invest "I feel honored to invest money, time and resources to manage forest, rangeland and deer habitat for deer and wildlife."
label variable e3benefit "Active forest, rangeland and deer habitat management can bring economic as well as environmental benefits."
label variable e3human "The primary use of forest, rangeland and deer habitat management should be to benefit human beings."
label variable e3restrict "Restricting excessive use of forest, rangeland and deer habitat can enhance recreational opportunities."
label variable e3time "It is important to spend time managing forest, rangeland and deer habitat."
label variable e3balance "Sustainable management of forest, rangeland and deer habitat is important to amintain balance and idversity in the natural environment."
label variable e3connect "I feel connected with nature when I get involved in forest, rangeland and deer habitat management."
label variable e3environ "The primary use for forest, rangeland, and deer habitat management should be to benefit the environment."
label variable e3manage "I am satisfied with the overall characterisitcs of forest, rangeland and deer habitat that I manage on my property."
label variable e3effort "I am satisifed with the number of deer and wildlife that I observed with the management effort that I puit in my property."
label variable e3wilder "I am satisfied with the wilderness of forest, rangeland and deer habitat that I maintain."
label variable e3overall "I am satisfied with the overall benefits I am getting from forest, rangeland and deer habitat management."
label variable e3noneed "There is no need for active forest, rangeland and deer habitat management."
label variable f1forest  "Acres of forestland"
label variable f1agland  "Acres of Agriculture Cropland"
label variable f1range  "Acres of Rangeland"
label variable f1resid  "Acres of Residential Area"
label variable f2age "Age at the end of 2019."
label variable f3race "Race."
label variable f4gender "Gender."
label variable f5job "Primary Occupation."
label variable f6educ "Highest level of education."
label variable f7income "Gross income before tax in 2018."
label variable f8comment "Additional Comments"
label variable f5job_reported "Job as reported on Survey"

/* Attach values of levels to variables */
label values datalot surveylot
label values dataentry datatech
label values a1hunted binary
label values a3pgame binary
label values a4lease binary
label values b1site binary
label values b2site binary
label values b3site binary
label values b4site binary
label values b5site binary
label values b6site binary
label values c3active binary
label values c4cost binary
label values c4time binary
label values c4fire binary
label values c4herb binary
label values c4know binary
label values c4govt binary
label values c4noben binary
label values c4noprac binary
label values c4rent binary
label values c4live binary
label values c5aware binary
label values c6interest binary
label values d1remove binary
label values d1barrier binary
label values d1irrigate binary
label values d1fence binary
label values d1plant binary
label values d1aband binary
label values d1restore binary
label values f3race yourrace
label values f4gender yourgender
label values f6educ education
label values f7income income2018
label values e* fivescale
label values c2* sixscale
label values d2* sixscale
label values c7* sixscale
describe
codebook


*******************************************************************************
*******************************************************************************
