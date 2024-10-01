/*****************************************
Last edited: Sept 10th
Project: Beyond Infancy and Before Adulthood: The impacts of immigration raids on pediatric healthcare use
Created on: Sept 10, 2024
Last edited: Sept 28th, 2024
*****************************************/


clear all



**# Bookmark #1
**************** Setting the working directory**********************************
********************************************************************************
********************************************************************************

* For Tati 
*cd "/Users/tatianapadilla/Desktop/Research/PadillaHuang/Data/"

* For Stanley
cd "/Users/stanleyhuang/Desktop/01 Projects/PadillaHuang/Data"


*********************Importing the SIPPS Data***********************************
********************************************************************************

* 2014 wave 3 data
use "Original Data/pu2014w3_13.dta"
keep swave ssuid swave shhadid spanel ebiodadus abiomomus abiodadus ebornus abornus ecitizen acitizen ehdedpln1 ahdedpln1 ehdedpln2 ahdedpln2 ehltstat ahltstat emdsubs amdsubs enoinchk anoinchk enoindnt anoindnt enoindoc anoindoc eorigin aorigin epar1typ apar1typ epar2typ apar2typ epnpar1 apnpar1 epnpar2 apnpar2 erace arace esex asex rhiyngkd ahiyngkd rhlthmth ahlthmth tage aage adaysick tdaysick tdaysick_med tdaysick_std timstat aimstat trace arace tvisdoc avisdoc tvisdoc_med tvisdoc_std ssuid swave shhadid spanel erp pnum eclub edinrop edinrpar elesson eoutingsrop eoutingsrpar ereadcwb erelig ebiomomus tvisdent tdocnum 

** Added tvisdent (visits to dentist), tdocnum (how many of the visits included contact to physicians) 


save "Created Data/clean2014w3.dta", replace

* 2014 wave 4 data 
use "Original Data/pu2014w4_13.dta"
keep swave ssuid swave shhadid spanel ebiodadus abiomomus abiodadus ebornus abornus ecitizen acitizen ehdedpln1 ahdedpln1 ehdedpln2 ahdedpln2 ehltstat ahltstat emdsubs amdsubs enoinchk anoinchk enoindnt anoindnt enoindoc anoindoc eorigin aorigin epar1typ apar1typ epar2typ apar2typ epnpar1 apnpar1 epnpar2 apnpar2 erace arace esex asex rhiyngkd ahiyngkd rhlthmth ahlthmth tage aage adaysick tdaysick tdaysick_med tdaysick_std timstat aimstat trace arace tvisdoc avisdoc tvisdoc_med tvisdoc_std ssuid swave shhadid spanel erp pnum eclub edinrop edinrpar elesson eoutingsrop eoutingsrpar ereadcwb erelig ebiomomus tvisdent

save "Created Data/clean2014w4.dta", replace

*********************Appending the data sets************************************
********************************************************************************

append using "Created Data/clean2014w3" "Created Data/clean2014w4"

save "Created Data/appended13_14.dta", replace


use "Created Data/appended13_14.dta"









**# Bookmark #2:         
*************************RENAME & RECODE THE DATASET****************************
********************************************************************************
********************************************************************************

recode eorigin (2 = 0) (1 = 1), gen(hisp) //1 = hisp/span/latinx, 0 = not hisp
recode tage (19/90 = 0) (0/18 = 1), gen(child) //1 = under 18, 0 = over 18
recode esex (1 = 0)(2 = 1), gen(female) // 1 = female, 0 = male
recode ebornus (1 = 1)(2 = 0), gen(us_born) // 1 = us born, 0 = no
recode ebiomomus (1 = 1)(2 = 0), gen(biomom_us) //1 = mom born in us, 0 = no
recode ebiodadus (1 = 1)(2 = 0), gen(biodad_us) //1 = dad born in us, 0 = no
recode timstat (1 = 1)(2 = 0), gen(permanent) //1 = permanent, 0 = no
recode ecitizen (1 = 1)(2 = 0), gen(citizen) //1 = citizen, 0 = no
recode ehltstat (1/3 = 1)(4/5 = 0), gen(health_status) //1 = good, 0 = poor
recode rhlthmth (1 = 1)(2 = 0), gen(insured) // 1= insured, 0 = no 
recode erp (1 = 1)(2 = 0), gen(ref_parent) //1= ref parent, 2 = no
rename tvisdoc doctor_visits
cap rename tvisdent dentist_visits
rename tdaysick days_sick

gen mixed_status= 0
replace mixed_status=1 if biodad_us==1 & biomom_us==0
replace mixed_status=1 if biodad_us==0 & biomom_us==1

/*  Recodes Not Included In Analysis
recode eclub (2 = 0)(1 = 1)(missing=.), gen(club)
recode edinrop (0 = 0)(1/7 = 1)(missing = .), gen(num_days_dinner_2)
recode edinrpar (0 = 0)(1/7 = 1)(missing = .), gen(num_days_dinner)
recode elesson (1 = 1)(2 = 0)(missing = .), gen(lesson)
recode eoutingsrop (0 = 0)(1/7 = 1)(missing = .), gen(outing_2)
recode eoutingsrpar (0 = 0)(1/7 = 1)(missing = .), gen(outing)
recode ereadcwb (0 = 0)(1/7 = 1)(missing =.), gen(daily_read)
recode erelig (1/2 = 0)(3/5=1)(missing =.), gen(religious)
*/










**# Bookmark #3
***************************Univariate checks************************************
********************************************************************************
********************************************************************************

/* Checks for data that are not immediately used (miscellaneous, topcoded, std, and other data that are no longer useful)


* Miscellaneous data 
sum ssuid
tab swave, m nolabel
tab shhadid, m nolabel
tab spanel, m nolabel
tab pnum, m nolabel
tab race, m nolab
tab race_2, m nolab
tab ref_parent

* Not used median, std variables
tab tdaysick_med, m nolabel
tab tdaysick_std, m nolabel 
tab tvisdoc_med, m nolabel
tab tvisdoc_std, m nolabel

tab eclub, m nolabel
tab eclub if tage > 18, m nolabel
tab eclub erp, column m nolabel 
* tab eclub if erp == 1 & tage >= 6 & tage < 18, m nolabel // need more discussion
sum eclub
* There are SOME amount of missing (n = 12864, 21.94%) for this dataset if person is a reference parent that has at least 1 child. 
* For people older than 18 yo, the number of missing data on reference parents whose children participate in clubs or organizations after school is 334,219 (87.96%), 14,136 answered yes and 31,632 answered no.

tab edinrop, m 
tab edinrop erp, column m nolabel
* There are SOME amount of missingness (n = 264, 0.45%) for this dataset if the person is a reference parent that has at least 1 child (see tab edinrop erp, m)

tab edinrpar, m
tab edinrpar erp, column m nolabel
* There are SOME amount of missingness (n = 264, 0.45%) for this dataset if the person is a reference parent that has at least 1 child (see tab edinrpar erp, m)

tab elesson, m 
tab elesson erp, column m nolabel
* There are SOME amount a lot of missingness (n = 12864, 21.94%) for this dataset if the person is a reference parent that has at least 1 child (see tab elesson erp, m)

tab eoutingsrop, m
tab eoutingsrop erp, column m nolabel
* There is A LOT of missing data (n = 34512, 58.85%) for this dataset if the person is a reference parent that has at least 1 child (see tab eoutingsrop erp, m)
 
tab eoutingsrpar, m
tab eoutingsrpar erp, column m nolabel
* There is A LOT of missing data (n = 34512, 58.85%) for this dataset if the person is a reference parent that has at least 1 child (see tab eoutingsrpar erp, m)

tab ereadcwb, m
tab ereadcwb erp, column m nolabel 
* There is A LOT of missing data (n = 34512, 58.85%) for this dataset if the person is a reference parent that has at least 1 child (see tab ereadcwb erp, m)
 
tab erelig, m 
tab erelig erp, column m nolabel
* There are SOME amount of missing data (n = 12864, 21.94%) for this dataset if the person is a reference parent that has at least 1 child (see tab ereadcwb erp, m)

tab epnpar2, m nolabel
* LARGE AMOUNT OF MISSINGNESS: Person number of Parent 2
* There are 494,900 (65.63%) missing data.

tab epnpar1, m nolabel 
* LARGE AMOUNT OF MISSINGNESS: Person number of Parent 1
* There are 359,680 (47.40%) missing data.
 
tab epar1typ, m nolabel
* LARGE AMOUNT OF MISSINGNESS: Type of relationship to parent 1 {Biological parent, stepparent, adoptive parent}
* There are 359,680 (47.40%) missing data (same as epnpar1)

tab epar2typ, m nolabel
* LARGE AMOUNT OF MISSINGNESS: Type of relationship to parent 2 {Biological parent, stepparent, adoptive parent}
* There are 494,900 (65.63%) missing data (same as epnpar2)
 
tab ehdedpln1, m nolabel
* LARGE AMOUNT OF MISSINGNESS: Identifies whether the private health insurance plan is a high deductible plan. 
* There are 330,108 (43.78%) missing data.
* Recode 1 into 1 and 2 into 0  

tab ehdedpln2, m nolabel
sum ehdedpln2
* LARGE AMOUNT OF MISSINGNESS: Identifies whether the private health insurance plan is a high deductible plan (line 2).
* There are 737,681 (97.82%) missing data.
 
tab emdsubs, m nolabel
sum emdsubs
* LARGE AMOUNT OF MISSINGNESS: Premium subsidy status of Medicaid/Medicaid Assistance
* There are 741,818 (98.37%) missing data

tab rhiyngkd, m nolabel
sum rhiyngkd
* LARGE AMOUNT OF MISSINGNESS: Recode - indicates if child under 18 outside the household was covered by this insurance plan (comparable to prior SIPP Panels)
* There are 746,460 (98.99) missing data

tab na_ins_dentist, m nolabel 
*  LARGE AMOUNT OF MISSINGNESS: During the month(s), person was not covered by any health insurance, did they go to the dentist or dentist professional?
* There are 730,996 (96.94%) missing data.
* This is because the Universe status is restricted for THHLDSTATUS=(1,2) & TVISDENT>=1 & TAGE>=15 & (RHLTHMTH=2 in any month of the reference period)
* Description: New or returning household members, who were age 15 or older at time of interview, were uninsured for at least one month of the reference period, and had at least 1 dental visit during the reference period

tab na_ins_doc, m nolabel
*  LARGE AMOUNT OF MISSINGNESS: During the month(s), person was not covered by any health insurance, did they go to a doctor, nurse, or other medical provider?
* There are 726,976 (96.40%) missing data.
* This is because THHLDSTATUS=(1,2) & TVISDOC>=1 & TAGE>=15 & (RHLTHMTH=2 in any month of the reference period)
*  Description: New or returning household members, who were age 15 or older at time of interview, were uninsured for at least one month of the reference period, and had at least 1 medical provider visit during the reference period

tab na_ins_checkup, m nolabel
* LARGE AMOUNT OF MISSINGNESS: Did ... receive any routine or preventative care?
* There are 736,108 (97.70%) missing data. 
* This is because ENOINDOC=1
* Description: Respondent who visited a doctor, nurse or some other medical provider during the months(s) the person didn't have any health insurance coverage.

*/ 
 
/* Collapsable section for status flags, not renamed yet
tab asex, m 
tab aorigin, m 
tab arace, m
tab abiomomus, m 
tab abiodadus, m 
tab acitizen, m 
tab aimstat, m 
tab aimstat, m 
tab abornus, m 
tab ahltstat, m 
tab avisdoc, m nolabel
tab adaysick, m nolabel
tab anoindnt, m nolabel
tab anoinchk, m nolabel
tab apar1typ, m nolabel
tab apnpar2, m nolabel
tab apnpar1, m nolabel
tab ahdedpln1, m nolabel
tab apar2typ, m nolabel
tab ahdedpln2, m nolabel
tab amdsubs, m nolabel
tab ahlthmth, m nolabel
tab ahiyngkd, m nolabel
tab aage, m
tab anoindoc, m nolabel
*/



tab hisp, m nolab
tab child, m nolab
tab female, m nolab
tab us_born, m nolab
tab biomom_us, m nolab
tab biodad_us, m nolab
tab mixed_status, m nolab
tab citizen, m nolab

tab insured, m nolab // monthly 
cap tab dentist_visits, m nolab


******************** Missing At Random *****************************

tab doctor_visits, m nolab
* 2.84% missingness
tab doctor_visits if child ==1, m nolab
* 2.89% missingness

tab health_status, m nolab
*2.43% missingness
tab health_status if child == 1, m nolab
* 2.05% missingness

******************** Missing Not At Random **************************

*Q: How do you tell the missingness for a group under 18... without setting people over 18 as missing? 

tab permanent, m nolab
*91.63% missingness
tab permanent if child == 1, m nolabel
*96.84% missingness


tab days_sick, m nolab
* 40% missingness 
tab days_sick if child == 1, m nolabel
* 77.78% missingness










**# Bookmark #4
***************************SET UNIVERSE ****************************************
********************************************************************************
********************************************************************************


duplicates drop
* Duplicates in terms of all variables (333,285 observations deleted)
* I got 249,105 observations deleted


drop if health_status == . 
*(13972 observations deleted)

drop if doctor_visits == .
*(1400 observations deleted)

cap drop if dentist_visits == .
*( observations deleted)

drop permanent
drop days_sick 




**# Bookmark #5
****************************** ANALYSIS ****************************************
********************************************************************************
********************************************************************************



***** Outcome variables: health status, doctor visits, dentist visits
***** Covariates: gender, mixed-status families, nativity, citizenship, insurance status 

* Q: We don't have data to look at preventative care because variable enoinchk is for a restricted sample with no health insurance. 
* What can we do? 


reg doctor_visits health_status female child mixed_status us_born citizen insured
reg health_status female child mixed_status us_born citizen
probit health_status female child mixed_status us_born citizen
reg insured female child mixed_status 
probit insured female child mixed_status 
