use "C:\Users\nhuang\Downloads\finaldata2.dta"
// creating deskjob dummy variable
tab indgen
gen deskjob = . 
replace deskjob = 1 if inlist(indgen, 110,112,120,130,140)
replace deskjob = 0 if inlist(indgen, 10,20,30,40,50,60,70,80,90,95)
label define deskjob_lbl 0 "Active job" 1 "Sedentary job"
label values deskjob deskjob_lbl
tab deskjob
// married dummy variable
gen byte married = .
replace married = 1 if marst == 2
replace married = 0 if inlist(marst,1,3,4)
label define married_lbl 0 "Not married" 1 "Married/in union"
label values married married_lbl
drop if married == .
codebook married
// eldest child older than 13 dummy variable 
drop if eldch == 99
gen byte eldest13 = .
replace eldest13 = 1 if eldch >= 13
replace eldest13 = 0 if eldch < 13
label define eldest13_lbl 0 "Eldest < 13" 1 "Eldest 13+"
label values eldest13 eldest13_lbl
codebook eldest13
// eldestchild13 x married interaction term
gen byte eldest13_notmarried = eldest13 * (1 - married)
label define eldest13_nm_lbl 0 "Other households" 1 "13+ child x not married"
label values eldest13_notmarried eldest13_nm_lbl
tab eldest13_notmarried
// education dummy variable
codebook edattain
drop if edattain == 9
gen byte highedu = .
replace highedu = 0 if edattain == 1 | edattain == 2
replace highedu = 1 if edattain == 3 | edattain == 4
label define highedu_lbl 0 "Lower education" 1 "Higher education"
label values highedu highedu_lbl
tab highedu
// empstat dummy
codebook empstat
drop if empstat == 9
gen byte working = .
replace working = 1 if empstat == 1
replace working = 0 if empstat == 2 | empstat == 3
label define working_lbl 0 "Not working" 1 "Working"
label values working working_lbl
tab working

// running the regression for each country 
// Mexico
logit working nchild eldest13 married eldest13_notmarried highedu age if country == 484, vce(robust)
// US
logit working nchild eldest13 married eldest13_notmarried highedu age if country == 840, vce(robust)
