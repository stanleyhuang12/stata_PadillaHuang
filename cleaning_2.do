/*****************************************
Last edited: Sept 10th
Goal: construct a working dataset

Running Log: 
Sept 10th: Instructions for constructing a working dataset
Sept 15th: Construct working dataset for 2014 wave 4 
*****************************************/

clear all

*****************Setting the working directory**************************
******************************************************************************
*For Tati cd "/Users/tatianapadilla/Desktop/Research/PadillaHuang/Data/"

*For Stanley
cd "/Users/stanleyhuang/Desktop/01 Projects/PadillaHuang/Data"


*****************Importing SIPP Data************************************  ******************************************************************************

****set maxvar 10000
****set maxvar 2048

**** 2014 wave 3 data
use "Original Data/pu2014w3_13.dta"

keep ebiomomus ebiodadus abiomomus abiodadus ebornus abornus ecitizen acitizen ehdedpln1 ahdedpln1 ehdedpln2 ahdedpln2 ehltstat ahltstat emdsubs amdsubs enoinchk anoinchk enoindnt anoindnt enoindoc anoindoc eorigin aorigin epar1typ apar1typ epar2typ apar2typ epnpar1 apnpar1 epnpar2 apnpar2 erace arace esex asex rhiyngkd ahiyngkd rhlthmth ahlthmth tage aage adaysick tdaysick tdaysick_med tdaysick_std timstat aimstat trace arace tvisdoc avisdoc tvisdoc_med tvisdoc_std ssuid swave shhadid spanel erp pnum eclub edinrop edinrpar elesson eoutingsrop eoutingsrpar ereadcwb erelig

* Q: arace appears twice

tab tage,m
keep if tage<19
tab tage,m

save "Created Data/clean2014w3.dta", replace

**** 2014 wave 4 data 
use "Original Data/pu2014w4_13.dta"

keep ebiomomus ebiodadus abiomomus abiodadus ebornus abornus ecitizen acitizen ehdedpln1 ahdedpln1 ehdedpln2 ahdedpln2 ehltstat ahltstat emdsubs amdsubs enoinchk anoinchk enoindnt anoindnt enoindoc anoindoc eorigin aorigin epar1typ apar1typ epar2typ apar2typ epnpar1 apnpar1 epnpar2 apnpar2 erace arace esex asex rhiyngkd ahiyngkd rhlthmth ahlthmth tage aage adaysick tdaysick tdaysick_med tdaysick_std timstat aimstat trace arace tvisdoc avisdoc tvisdoc_med tvisdoc_std ssuid swave shhadid spanel erp pnum eclub edinrop edinrpar elesson eoutingsrop eoutingsrpar ereadcwb erelig


tab tage,m
keep if tage<19
tab tage,m

save "Created Data/clean2014w4.dta", replace

*****************Appending the dataset****************************** **************************************************************************

append using "Created Data/clean2014w3" "Created Data/clean2014w4"

save "Created Data/appended13_14.dta", replace

*****************Descriptive Statisticst****************************** **************************************************************************

tab ecitizen
tab eorigin
tab ecitizen eorigin

sum ecitizen ebornus eorigin esex tage

reg enoinchk tdaysick ecitizen eorigin esex tage

*****************Univariate Checks ****************************** **************************************************************************

* The idea of univariate checks is to review the data for missingness. 

use "Created Data/appended13_14.dta"

tab ssuid
sum ssuid
* No missingness
 
tab swave, nolabel
sum swave
* No missingness

tab shhadid
tab shhadid, m
tab shhadid, nolabel
sum shhadid
* No missingness
 
tab spanel, nolabel
sum spanel
* No missingness
 
tab pnum, nolabel
sum pnum
* No missingness
 
tab aage
tab aage, m
tab aage, nolabel
tabstat aage, statistics(median, mean, min, max)
* Status Flag for tage, 1 or 2 

tab tage 
tab tage if (tage >= 15) & (tage <= 18), m nolabel
tabstat tage, statistics(median, mean, min, max)
* No missingness, 85k observations 

tab esex
tab esex, m
tab esex, nolabel
sum esex*
* No missingness, 750k observations balanced 
 
tab asex
tab asex, m
tab asex, nolabel
sum 
* Status Flag for esex
 
tab eorigin
tab eorigin, m
tab eorigin, nolabel
sum eorigin
* No missingness, 750k observations, 152k are Spanish, Hispanic, or Latino (20% of sample)
* Need to recode, 2 => 0, 1 => 1
 
tab aorigin
tab aorigin, m
tab aorigin, nolabel
sum aorigin
* Status Flag for aorigin

tab arace
tab arace, m
tab arace, nolabel
sum arace
* Status Flag for arace 

tab erace
tab erace, m
tab erace, nolabel
sum erace
* No missingness, Likely won't use
 
tab abornus
tab abornus, m
tab abornus, nolabel
sum abornus
* Status Flag for abornus

tab ebornus
tab ebornus, m
tab ebornus, nolabel
sum ebornus
* No missingness
 
 
tab ebiomomus
tab ebiomomus, m
tab ebiomomus, nolabel
sum ebiomomus
* No missingness
 
tab ebiodadus
tab ebiodadus, m
tab ebiodadus, nolabel
sum ebiodadus
* No missingness

tab abiomomus
tab abiomomus, m
tab abiomomus, nolabel
sum abiomomus
* Status Flag for ebiomomus
 
tab abiodadus
tab abiodadus, m
tab abiodadus, nolabel
sum abiodadus
* Status Flag for ebiodadus
 
tab acitizen
tab acitizen, m nolabel
sum acitizen
* Status Flag for ecitizen
 
tab ecitizen
tab ecitizen, m nolabel
tab ecitizen, nolabel
sum ecitizen
* No missingness
 

tab aimstat
tab aimstat, m nolabel
* Status Flag for timstat
 
tab timstat
tab timstat, m nolabel
tab timstat if (tage >= 15)  & (tage <= 18), m nolabel
tab timstat if tage <= 18, m nolabel
sum timstat
* LARGE AMOUNT OF MISSINGNESS: What was the person's immigration status when they first moved to the US? 
* There are 691,001 (91.63%) missing data.
* There are 5,498 observations (6.47%) for people between 15 and 18 inclusive.
* There are nearly 11,825 observations (3.16%) for people under age 18. 

tab ahltstat
tab ahltstat, m
tab ahltstat, nolabel
sum ahltstat
* Status Flag for ehltstat

tab ehltstat
tab ehltstat, m nolabel
tabstat ehltstat, statistics(mean, median, min, max)
graph bar (count), over(ehltstat)

tab ehltstat if eorigin == 1, m nolabel
tab ehltstat if eorigin == 2, m nolabel

ttest ehltstat, by(eorigin)

cap prtest eorigin, by(ehltstat == 1)
cap prtest eorigin, by(ehltstat == 2)
cap prtest eorigin, by(ehltstat == 3)
cap prtest eorigin, by(ehltstat == 4)
cap prtest eorigin, by(ehltstat == 5) 

tab ehltstat eorigin, column chi2
tab ehltstat eorigin, column nofreq chi2

* Some missingness: What is the person's health status?
* There are 18,289 (2.43%) missing data.
* A majority (n = 498,146, 66.06^) of people have excellent or good health.
* I attempted to do a multiple proportions test (chi2), unfortunately Stata does it by frequency even if we suppress count. After figuring this out, we can do a post-hoc Marascuilo procedure: https://itl.nist.gov/div898/handbook/prc/section4/prc464.htm


tab avisdoc
tab avisdoc, m
tab avisdoc, nolabel
sum avisdoc
* Status Flag for tvisdoc
 
tab tvisdoc
tab tvisdoc, m nolabel
graph bar (count), over(tvisdoc) 
tabstat tvisdoc, statistics(mean, median, min, max)
* Some missingness: How many times did person see or talk to a doctor, nurse, or other type of medical personnel?
* There are 21,429 (2.84%) missing data. 
* NUmber of visits with doctors or nurse shows a log distribution 

tab adaysick
tab adaysick, m
tab adaysick, nolabel
sum adaysick
* Status Flag for tdaysick

tab tdaysick
tab tdaysick, m nolabel
tabstat tdaysick, statistics(mean, p25, median, p75, min, max)

codebook tdaysick
histogram tdaysick, width(3)
* LARGE AMOUNT OF MISSINGNESS: How many days did illnesss or injury keep person in bed more than half of the day?
* There are 301,576 (39.99%) missing data. 
* While the data ranges from 0 days to 348 days and there are 134 unique values, 75% of the result fall below 2 days. Most people are not sick often. 

tab anoindnt
tab anoindnt, m nolabel
sum anoindnt
* Status Flag for anoindnt

 
tab enoindnt
tab enoindnt, m nolabel 
sum enoindnt
*  LARGE AMOUNT OF MISSINGNESS: During the month(s), person was not covered by any health insurance, did they go to the dentist or dentist professional?
* There are 730,996 (96.94%) missing data.
* This is because the Universe status is restricted for THHLDSTATUS=(1,2) & TVISDENT>=1 & TAGE>=15 & (RHLTHMTH=2 in any month of the reference period)
* Description: New or returning household members, who were age 15 or older at time of interview, were uninsured for at least one month of the reference period, and had at least 1 dental visit during the reference period
 
tab anoindoc
tab anoindoc, m nolabel
sum anoindoc
* Status Flag for enoindoc
 
tab enoindoc
tab enoindoc, m nolabel
sum enoindoc
*  LARGE AMOUNT OF MISSINGNESS: During the month(s), person was not covered by any health insurance, did they go to a doctor, nurse, or other medical provider?
* There are 726,976 (96.40%) missing data.
* This is because THHLDSTATUS=(1,2) & TVISDOC>=1 & TAGE>=15 & (RHLTHMTH=2 in any month of the reference period)
*  Description: New or returning household members, who were age 15 or older at time of interview, were uninsured for at least one month of the reference period, and had at least 1 medical provider visit during the reference period
 
tab anoinchk
tab anoinchk, m nolabel
sum anoinchk
* Status Flag for enoinchk
 
tab enoinchk
tab enoinchk, m nolabel
sum enoinchk
* LARGE AMOUNT OF MISSINGNESS: Did ... receive any routine or preventative care?
* There are 736,108 (97.70%) missing data. 
* This is because ENOINDOC=1
* Description: Respondent who visited a doctor, nurse or some other medical provider during the months(s) the person didn't have any health insurance coverage.

tab erp
tab erp, m nolabel
tab erp if tage > 18, m 
sum erp
* LARGE AMOUNT OF MISSINGNESS: Identifies if adult is a reference parent to any household children under 18 years old?
* There are 307,084 (40.72%) missing data.
* This is because the TAGE > 15. 

tab apnpar2
tab apnpar2, m nolabel
sum apnpar2
* Status Flag for epnpar2
 
tab epnpar2
tab epnpar2, m nolabel
* LARGE AMOUNT OF MISSINGNESS: Person number of Parent 2
* There are 494,900 (65.63%) missing data.
 
tab apnpar1
tab apnpar1, m nolabel
sum apnpar1
* Status Flag for epnpar1

tab epnpar1
tab epnpar1, m nolabel 
sum epnpar1
* LARGE AMOUNT OF MISSINGNESS: Person number of Parent 1
* There are 359,680 (47.40%) missing data.



tab apar1typ
tab apar1typ, m nolabel
sum apar1typ
* Status Flag for epar1typ
 
tab epar1typ
tab epar1typ, m
tab epar1typ, nolabel
sum epar1typ
* LARGE AMOUNT OF MISSINGNESS: Type of relationship to parent 1 {Biological parent, stepparent, adoptive parent}
* There are 359,680 (47.40%) missing data (same as epnpar1)

tab apar2typ
tab apar2typ, m nolabel
sum apar2typ
* Status Flag for epar2typ

tab epar2typ
tab epar2typ, m nolabel
sum epar2typ
* LARGE AMOUNT OF MISSINGNESS: Type of relationship to parent 2 {Biological parent, stepparent, adoptive parent}
* There are 494,900 (65.63%) missing data (same as epnpar2)
 
tab ahdedpln1
tab ahdedpln1, m nolabel
sum ahdedpln1
* Status Flag for ehdedpln1

tab ehdedpln1
tab ehdedpln1, m nolabel
sum ehdedpln1
* LARGE AMOUNT OF MISSINGNESS: Identifies whether the private health insurance plan is a high deductible plan. 
* There are 330,108 (43.78%) missing data.
* Recode 1 into 1 and 2 into 0  

tab ahdedpln2
tab ahdedpln2, m nolabel
sum ahdedpln2
* Status Flag for ehdedpln2
 
tab ehdedpln2
tab ehdedpln2, m nolabel
sum ehdedpln2
* LARGE AMOUNT OF MISSINGNESS: Identifies whether the private health insurance plan is a high deductible plan (line 2).
* There are 737,681 (97.82%) missing data.
 
tab amdsubs
tab amdsubs, m nolabel
sum amdsubs
* Status Flag for emdsubs
 
tab emdsubs
tab emdsubs, m nolabel
sum emdsubs
* LARGE AMOUNT OF MISSINGNESS: Premium subsidy status of Medicaid/Medicaid Assistance
* There are 741,818 (98.37%) missing data.

tab ahiyngkd
tab ahiyngkd, m nolabel
sum ahiyngkd
* Status Flag for rhiyngkd

tab rhiyngkd
tab rhiyngkd, m nolabel
sum rhiyngkd
* LARGE AMOUNT OF MISSINGNESS: Recode - indicates if child under 18 outside the household was covered by this insurance plan (comparable to prior SIPP Panels)
* There are 746,460 (98.99) missing data

tab ahlthmth
tab ahlthmth, m nolabel
sum ahlthmth
* Status Flag for rhlthmth
 
tab rhlthmth
tab rhlthmth, m nolabel
sum rhlthmth
* No missingness (indicates if person is insured)
 
tab trace
tab trace, m nolabel
sum trace
* No missingness

 
tab tdaysick_med
tab tdaysick_med, m nolabel
sum tdaysick_med
* LARGE AMOUNT OF MISSINGNESS:  Median of topcoded values for  TDAYSICK
* NA 
 
tab tdaysick_std
tab tdaysick_std, m nolabel 
sum tdaysick_std
* LARGE AMOUNT OF MISSINGNESS:  Standard deviation of topcoded values for TDAYSICK
* NA 

 
tab tvisdoc_med
tab tvisdoc_med, m nolabel
sum tvisdoc_med
* LARGE AMOUNT OF MISSINGNESS: Median of topcoded values for TVISDOC
* NA 

tab tvisdoc_std
tab tvisdoc_std, m
tab tvisdoc_std, nolabel
sum tvisdoc_std
* LARGE AMOUNT OF MISSINGNESS: Standard deviation of topcoded values for TVISDOC
* NA
 
tab index
tab index, m nolabel
sum index
codebook index
* No missingness
 
tab eclub
tab eclub, m nolabel
tab eclub if tage > 18, m nolabel
tab eclub erp, m nolabel
tab eclub erp, column m nolabel 
* tab eclub if erp == 1 & tage >= 6 & tage < 18, m nolabel // need more discussion
sum eclub

* There are SOME amount of missing (n = 12864, 21.94%) for this dataset if person is a reference parent that has at least 1 child. 
* For people older than 18 yo, the number of missing data on reference parents whose children participate in clubs or organizations after school is 334,219 (87.96%), 14,136 answered yes and 31,632 answered no.


tab edinrop
tab edinrop, m nolabel
tab edinrop erp, column m nolabel
sum edinrop
* There are SOME amount of missingness (n = 264, 0.45%) for this dataset if the person is a reference parent that has at least 1 child (see tab edinrop erp, m)

 
tab edinrpar
tab edinrpar, m nolabel
tab edinrpar erp, column m nolabel
sum edinrpar
* There are SOME amount of missingness (n = 264, 0.45%) for this dataset if the person is a reference parent that has at least 1 child (see tab edinrpar erp, m)
 
tab elesson
tab elesson erp, column m nolabel
sum elesson
* There are SOME amount a lot of missingness (n = 12864, 21.94%) for this dataset if the person is a reference parent that has at least 1 child (see tab elesson erp, m)
 
tab eoutingsrop
tab eoutingsrop erp, column m nolabel
sum eoutingsrop
* There is A LOT of missing data (n = 34512, 58.85%) for this dataset if the person is a reference parent that has at least 1 child (see tab eoutingsrop erp, m)
 
tab eoutingsrpar
tab eoutingsrpar erp, column m nolabel
sum eoutingsrpar
* There is A LOT of missing data (n = 34512, 58.85%) for this dataset if the person is a reference parent that has at least 1 child (see tab eoutingsrpar erp, m)
 
tab ereadcwb
tab ereadcwb erp, column m nolabel 
sum ereadcwb
* There is A LOT of missing data (n = 34512, 58.85%) for this dataset if the person is a reference parent that has at least 1 child (see tab ereadcwb erp, m)
 
tab erelig
tab erelig erp, column m nolabel
sum erelig
* There are SOME amount of missing data (n = 12864, 21.94%) for this dataset if the person is a reference parent that has at least 1 child (see tab ereadcwb erp, m)


*****************Recoding the Dataset****************************** *******************************************************************

* Recode Hispanic/Spanish/Latino dichotomous indicator

recode eorigin (2 = 0) (1 = 1), gen(hisp)
tab eorigin 
tab hisp

* Convert age into a binary variable to indicate if someone is a children

recode tage (19/90 = 0) (0/18 = 1), gen(child)
tab tage if tage >= 19
tab child if child == 0

* Recode sex category 

recode esex (1 = 0)(2 = 1), gen(sex)
tab esex 
tab sex

* Recode indicator for whether someone was born in the US

recode ebornus (1 = 0)(2 = 1), gen(nonusborn)
tab ebornus
tab nonusborn

* Recode indicator for whether someone is a citizen 

recode ecitizen (1 = 0)(2 = 1), gen(citizen)
tab ecitizen
tab citizen

* Create an indicator of whether the household is a "mixed-status family":
drop biodad_us
drop biomom_us
cap recode ebiodadus (1 = 1)(2 = 0), gen(biodad_us) 
cap recode ebiomomus (1 = 1)(2 = 0), gen(biomom_us) 

tab ebiodadus, m
tab biodad_us, m
tab ebiomomus, m
tab biomom_us, m

drop mixed_status
gen mixed_status = biodad_us * biomom_us 
replace mixed_status (1=)

* Recode health status (Excellent, Very Good, Good = 0, Fair, Poor = 1)

recode ehltstat (1/3 = 0) (4/5 = 1), gen(health_status)
tab ehltstat if ehltstat < 4
tab health_status

* Recode "timstat": Immigration Status after initial move to the US 

recode timstat (1 = 0)(2 = 1), gen(imm_status)
		/*I am not sure about this one because there are other statuses (e.g. DACA 	
		 Recipients, people who stay on visa) that is not captured in this 	
		 variable.*/

* Recode if person has health coverage this months

recode rhlthmth (1=0)(2=1), gen(not_insured_mo)

* Recode person's race

recode trace (1=0)(2/10 = 1), gen(non_white)

* Recode eclub 
recode eclub (2 = 0)(1 = 1)(missing=.), gen(club)
drop if club == . 


