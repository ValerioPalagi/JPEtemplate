clear all
do "../Setup.do"

use "$DTA\parent_child_PSID.dta", clear

*-----------------------------------------------------
* DEFLATE 100=2023 - run frist as loads necessary data
*-----------------------------------------------------

do "$DO/Deflate.do"

*-----------------------------
* CREATE BIRTH YEAR VARIABLE
*-----------------------------

* Recode invalid age values to missing (PSID nonresponse codes)
foreach v of varlist p_ER30004 p_ER30023 p_ER30046 p_ER30070 p_ER30094 p_ER30120 ///
                     p_ER30141 p_ER30163 p_ER30191 p_ER30220 p_ER30249 p_ER30286 ///
                     p_ER30316 p_ER30346 p_ER30376 p_ER30402 p_ER30432 p_ER30466 ///
                     p_ER30501 p_ER30538 p_ER30573 p_ER30609 p_ER30645 p_ER30692 ///
                     p_ER30736 p_ER30809 p_ER33104 p_ER33204 p_ER33304 p_ER33404 ///
                     p_ER33504 p_ER33604 p_ER33704 p_ER33804 p_ER33904 p_ER34004 ///
                     p_ER34104 p_ER34204 p_ER34305 p_ER34504 p_ER34704 p_ER34904 ///
                     p_ER35104 ///
                     c_ER30004 c_ER30023 c_ER30046 c_ER30070 c_ER30094 c_ER30120 ///
                     c_ER30141 c_ER30163 c_ER30191 c_ER30220 c_ER30249 c_ER30286 ///
                     c_ER30316 c_ER30346 c_ER30376 c_ER30402 c_ER30432 c_ER30466 ///
                     c_ER30501 c_ER30538 c_ER30573 c_ER30609 c_ER30645 c_ER30692 ///
                     c_ER30736 c_ER30809 c_ER33104 c_ER33204 c_ER33304 c_ER33404 ///
                     c_ER33504 c_ER33604 c_ER33704 c_ER33804 c_ER33904 c_ER34004 ///
                     c_ER34104 c_ER34204 c_ER34305 c_ER34504 c_ER34704 c_ER34904 ///
                     c_ER35104 {
    replace `v' = . if inlist(`v', 0, 999)
}

* Parent/child birth year from first nonmissing age, using year parsed from interview-number var label

* Wave-specific interview-number vars and matching age vars (PSID core)
local intvars ER30001 ER30020 ER30043 ER30067 ER30091 ER30117 ER30138 ER30160 ER30188 ER30217 ///
             ER30246 ER30283 ER30313 ER30343 ER30373 ER30399 ER30429 ER30463 ER30498 ER30535 ///
             ER30570 ER30606 ER30642 ER30689 ER30733 ER30806 ER33101 ER33201 ER33301 ER33401 ///
             ER33501 ER33601 ER33701 ER33801 ER33901 ER34001 ER34101 ER34201 ER34301 ER34501 ///
             ER34701 ER34901 ER35101

local agevars ER30004 ER30023 ER30046 ER30070 ER30094 ER30120 ER30141 ER30163 ER30191 ER30220 ///
             ER30249 ER30286 ER30316 ER30346 ER30376 ER30402 ER30432 ER30466 ER30501 ER30538 ///
             ER30573 ER30609 ER30645 ER30692 ER30736 ER30809 ER33104 ER33204 ER33304 ER33404 ///
             ER33504 ER33604 ER33704 ER33804 ER33904 ER34004 ER34104 ER34204 ER34305 ER34504 ///
             ER34704 ER34904 ER35104

capture drop p_birth c_birth
gen int p_birth = .
gen int c_birth = .

* ----- Parents
local i = 1
foreach ivar of local intvars {
    local avar : word `i' of `agevars'

    local lab : variable label p_`ivar'
    if regexm("`lab'", "([12][0-9]{3})") {
        local yr = real(regexs(1))
        quietly replace p_birth = `yr' - p_`avar' if missing(p_birth) & !missing(p_`avar')
    }
    local ++i
}

* ----- Children
local i = 1
foreach ivar of local intvars {
    local avar : word `i' of `agevars'

    local lab : variable label c_`ivar'
    if regexm("`lab'", "([12][0-9]{3})") {
        local yr = real(regexs(1))
        quietly replace c_birth = `yr' - c_`avar' if missing(c_birth) & !missing(c_`avar')
    }
    local ++i
}

*---------------------------------------------------------
* RESTRICT TO MOTHERS INSIDE THE SPECIFIC birtyear range
*---------------------------------------------------------

drop if p_G1TYPE== "M" & (p_birth<1950 | p_birth>1955) // with larger brackets we have 1171 mother child obs // 

 
*------------------------
* RESTRICT TO FIRST CHILD (mother OR father) + drop twins
*------------------------
* Keeps children who are first-born for at least one observed parent (M or F).
* Flags twins/multiple births within that parent's earliest birth year.
* Then drops any child flagged as twin by either parent (conservative).
*
* Assumes:
*   - p_id identifies the parent
*   - c_id identifies the child
*   - p_G1TYPE == "M" for mothers, "F" for fathers
*   - c_birth is child birth year

preserve
    * Keep only rows where parent type is M or F and child birth is observed
    keep if inlist(p_G1TYPE,"M","F")
    drop if missing(c_birth)

    * Earliest child birth year observed for each parent
    bysort p_G1TYPE p_id: egen first_birth = min(c_birth)

    * Keep children born in that earliest year
    keep if c_birth == first_birth

    * Flag twins/multiple births among those first-birth-year children for each parent
    bysort p_G1TYPE p_id c_birth: gen twins_parent = (_N > 1)

    * Keep only what we need to merge back
    keep c_id twins
    duplicates drop c_id, force

    tempfile firstkids_union
    save "`firstkids_union'", replace
restore

* Keep all rows (mother + father rows) for children who are first-born for >=1 parent
merge m:1 c_id using "`firstkids_union'", keep(match) nogen

* Drop twins (if either parent indicates the child is part of a multiple birth in the first-birth year)
count if twins_parent==1
drop if twins_parent==1
drop twins

*---------------------------
* RESTRICT TO NON ADOPTIONS
*---------------------------

bysort c_id: gen n_cid = _N
summarize n_cid, meanonly
display "Max repetitions of c_id = " r(max) // 3 indicates that there is at least one adoptive parent
drop if n_cid == r(max)

* Count n of mothers
count

*--------------------- 
*CHILD STATE OF BIRTH
*--------------------- 
*c_state_birth = earliest observed state of residence for child (proxy for state of birth) 
local c_statevars /// 
c_V93 c_V537 c_V1103 c_V1803 c_V2403 c_V3003 c_V3403 c_V3803 /// 
c_V4303 c_V5203 c_V5703 c_V6303 c_V6903 c_V7503 c_V8203 c_V8803 /// 
c_V10003 c_V11103 c_V12503 c_V13703 c_V14803 c_V16303 c_V17703 /// 
c_V19003 c_V20303 c_V21603 c_ER4156 c_ER6996 c_ER9247 c_ER12221 ///
c_ER13004 c_ER17004 c_ER21003 c_ER25003 c_ER36003 c_ER42003 ///
c_ER47303 c_ER53003 c_ER60003 c_ER66003 c_ER72003 c_ER78003 c_ER82003
 
capture drop c_state_birth 
gen int c_state_birth = . 

foreach v of local c_statevars { 
	quietly replace c_state_birth = `v' /// 
		if missing(c_state_birth) & !missing(`v') 
} 

replace c_state_birth = . if inlist(c_state_birth, 0, 99)

*------------------------------------------------------------------------
* Build role based variables: 
* income of Head of HH and Wife based on "relationship to head variable"
* race of respondent based on "who respondent" variable
*------------------------------------------------------------------------

do "$DO\Role_related_variables.do"


*-----------------------------------------------------
* Build instrument: pill_at_XX
*-----------------------------------------------------

do "$DO\Pill_IV"


*----------------------------
* RESHAPE 1 CHILD PER ROW
*----------------------------

*==============================================================
* Reshape parent-child long -> one row per child
* Mothers:   p_*  -> m_*
* Fathers:   p_*  -> f_*
* Child vars (c_*) stay as they are
* Keeps one row per child, with missing if mom or dad absent
*==============================================================

*----------------------------
* 0) Safety checks
*----------------------------
capture confirm variable c_id
if _rc {
    di as error "Missing c_id. Cannot reshape."
    exit 198
}
capture confirm variable p_id
if _rc {
    di as error "Missing p_id. Cannot reshape."
    exit 198
}
capture confirm variable p_G1TYPE
if _rc {
    di as error "Missing p_G1TYPE. Cannot split mothers/fathers."
    exit 198
}

* Keep only M/F parent rows (drop other parent types if any)
keep if inlist(p_G1TYPE,"M","F")

* There should be at most one mother row per child and one father row per child.
* If not, you must resolve duplicates before reshaping.
bysort c_id p_G1TYPE: gen _n_par = _N
quietly count if _n_par > 1
if r(N) > 0 {
    di as error "Found children with multiple rows for the same parent type (M or F)."
    di as error "You must collapse/choose one row per (c_id,p_G1TYPE) before reshape."
    tab p_G1TYPE if _n_par>1
    list c_id p_id p_G1TYPE if _n_par>1 in 1/30
    exit 459
}
drop _n_par

*----------------------------
* 1) Ensure child vars are constant within child
*----------------------------
ds c_*, has(type numeric)
local cvars_num `r(varlist)'
ds c_*, has(type string)
local cvars_str `r(varlist)'

* Check constancy for numeric c_ variables
foreach v of local cvars_num {
    bysort c_id: egen __min = min(`v')
    bysort c_id: egen __max = max(`v')
    quietly count if __min != __max & !missing(__min, __max)
    if r(N) > 0 {
        di as error "Child variable `v' is not constant within c_id. Fix this before reshape."
        list c_id p_G1TYPE p_id `v' __min __max if __min!=__max & !missing(__min,__max) in 1/25
        exit 459
    }
    drop __min __max
}

* Check constancy for string c_ variables
foreach v of local cvars_str {
    bysort c_id: egen __tag = tag(c_id `v')
    bysort c_id: egen __n = total(__tag)
    quietly count if __n > 1
    if r(N) > 0 {
        di as error "Child string variable `v' is not constant within c_id. Fix this before reshape."
        list c_id p_G1TYPE p_id `v' if __n>1 in 1/25
        exit 459
    }
    drop __tag __n
}

*----------------------------
* 2) Build suffix for reshape: "M" or "F"
*----------------------------
gen str1 _sexpar = p_G1TYPE

*----------------------------
* 3) Reshape wide
*   - all p_* variables will become p_*M and p_*F
*   - c_* variables will remain in the data but duplicated across rows pre-reshape, ok
*----------------------------
ds p_*
local pvars `r(varlist)'

* p_G1TYPE is used as j() and will be kept as _sexpar; do not reshape it
local pvars : list pvars - p_G1TYPE

drop _stkey age69 age71 age74

reshape wide `pvars', i(c_id) j(_sexpar) string

*----------------------------
* 4) Rename p_*M -> m_*, p_*F -> f_*
*   (and drop the old p_ prefix as requested)
*----------------------------
foreach v of local pvars {
    capture confirm variable `v'M
    if !_rc {
        local base = subinstr("`v'","p_","",1)
        rename `v'M m_`base'
    }
    capture confirm variable `v'F
    if !_rc {
        local base = subinstr("`v'","p_","",1)
        rename `v'F f_`base'
    }
}

* Optional: rename the original parent id vars if present
capture confirm variable p_idM
if !_rc rename p_idM m_id
capture confirm variable p_idF
if !_rc rename p_idF f_id


*----------------------------
* 5) Post-reshape diagnostics
*----------------------------
isid c_id, sort

di as text "Rows (children): " _N
quietly count if missing(m_id) & missing(f_id)
di as text "Children missing BOTH parents in file (should be 0 usually): " r(N)
quietly count if missing(m_id) & !missing(f_id)
di as text "Children with father only: " r(N)
quietly count if !missing(m_id) & missing(f_id)
di as text "Children with mother only: " r(N)
quietly count if !missing(m_id) & !missing(f_id)
di as text "Children with both parents: " r(N)

* Example: confirm the IV is only on mother side
capture confirm variable m_pill_at_18
if !_rc tab m_pill_at_18, missing


**************************************************************************************************
**************************************************************************************************
**************************************************************************************************
**************************************************************************************************
**************************************************************************************************


* -------------------------------------------------------------------------------------------
* Parents hours worked averages over child age bins: 0-5, 6-11, 12-17
* Creates: f_hw_5 f_hw_11 f_hw_17  m_hw_5 m_hw_11 m_hw_17
* Uses: f_work_hours_yy, m_work_hours_yy and c_birth
* -------------------------------------------------------------------------------------------

//
*CHECK IF EQUAL TO m_hw*
avg_by_age , ///
    prefixes("f_work_hours_ m_work_hours_ ") ///
    birthvar(c_birth) ///
    windows("0-5 6-11 12-17") ///
    logs(1) ///
	ihs
// */
	
* ------------------------------------------------------------
* EDUCATION up to AGE: max education observed with inferred age<=AGE
* Works in WIDE data with m_*, f_*, c_* prefixes
* Requires birth years: m_birth f_birth c_birth
* Interview year is inferred from variable label of (e.g.) c_ER30001
* ------------------------------------------------------------

* user choice: cutoff ages (add more as needed)
local educages "30 35 40"

* Waves where an education measure exists, aligned with interview-number vars
local intvars_educ ER30001 ER30043 ER30067 ER30091 ER30117 ER30138 ER30160 ER30188 ER30217 ///
                   ER30246 ER30283 ER30313 ER30343 ER30373 ER30399 ER30429 ER30463 ER30498 ///
                   ER30535 ER30570 ER30606 ER30642 ER30689 ER30733 ER30806 ER33101 ER33201 ///
                   ER33301 ER33401 ER33501 ER33601 ER33701 ER33801 ER33901 ER34001 ER34101 ///
                   ER34201 ER34301 ER34501 ER34701 ER34901 ER35101

local educvars     ER30010 ER30052 ER30076 ER30100 ER30126 ER30147 ER30169 ER30197 ER30226 ///
                   ER30255 ER30296 ER30326 ER30356 ER30384 ER30413 ER30443 ER30478 ER30513 ///
                   ER30549 ER30584 ER30620 ER30657 ER30703 ER30748 ER30820 ER33115 ER33215 ///
                   ER33315 ER33415 ER33516 ER33616 ER33716 ER33817 ER33917 ER34020 ER34119 ///
                   ER34230 ER34349 ER34548 ER34752 ER34952 ER35152

* ------------------------------------------------------------
* 0) Clean common missing codes in all existing stubbed educ vars
* ------------------------------------------------------------
foreach stub in m_ f_ c_ {
    foreach e of local educvars {
        capture confirm variable `stub'`e'
        if !_rc {
            replace `stub'`e' = . if inlist(`stub'`e', 0, 98, 99, 998, 999)
        }
    }
}

* ------------------------------------------------------------
* 1) Create outputs for each cutoff age (initialize to missing)
* ------------------------------------------------------------
foreach A of local educages {
    capture drop m_educ_`A' f_educ_`A' c_educ_`A'
    gen int m_educ_`A' = .
    gen int f_educ_`A' = .
    gen int c_educ_`A' = .
}

* ------------------------------------------------------------
* 2) Loop over waves, infer interview year from label, update maxima
* ------------------------------------------------------------
local i = 1
foreach ivar of local intvars_educ {

    local evar : word `i' of `educvars'

    * infer interview year from label of c_`ivar' (labels shared across stubs)
    local y = .
    capture confirm variable c_`ivar'
    if !_rc {
        local lab : variable label c_`ivar'
        if regexm("`lab'", "([12][0-9]{3})") local y = real(regexs(1))
    }

    * if year cannot be inferred, skip this wave
    if (`y'==.) {
        local ++i
        continue
    }

    foreach stub in m_ f_ c_ {

        local bvar = cond("`stub'"=="m_","m_birth", cond("`stub'"=="f_","f_birth","c_birth"))

        capture confirm variable `stub'`evar'
        if _rc continue

        foreach A of local educages {

            local out = "`stub'educ_`A'"

            quietly replace `out' = max(`out', `stub'`evar') ///
                if !missing(`stub'`evar') ///
                & !missing(`bvar') ///
                & (`y' - `bvar' <= `A')
        }
    }

    local ++i
}

* ------------------------------------------------------------
* 3) Labels
* ------------------------------------------------------------
foreach A of local educages {
    label var m_educ_`A' "Mother education: max observed with inferred age<=`A'"
    label var f_educ_`A' "Father education: max observed with inferred age<=`A'"
    label var c_educ_`A' "Child education: max observed with inferred age<=`A'"
}


* --------------------------
* Parent age at childbirth
* --------------------------

capture drop f_age_birth m_age_birth

gen f_age_birth = . 
gen m_age_birth = .

replace f_age_birth = c_birth - f_birth ///
    if !missing(c_birth) & !missing(f_birth)

replace m_age_birth = c_birth - m_birth ///
    if !missing(c_birth) & !missing(m_birth)

label var f_age_birth "Father age at childbirth"
label var m_age_birth "Mother age at childbirth"

*----------
*CHILD SEX
*----------
rename c_ER32000 c_sex
replace c_sex=0 if c_sex==2

*---------------
*INCOME MEASURES
*---------------
*Following Carinero et al 2021 I will construct a "statistical" definition of permanent income of the family, by using the average of all total family incomes (from all working memebers of household) over the perion in which the child is aged 0-17. In a similar fashion I create average income using 5-years long bins corresponding to age 0-5,6-11,12-17. 

*Rename wage variables
foreach pair in ///
    1968:c_V81  1969:c_V1514 1970:c_V2226 1971:c_V2852 1972:c_V3256 1973:c_V3676 ///
    1974:c_V4154 1975:c_V5029 1976:c_V5626 1977:c_V6173 1978:c_V6766 1979:c_V7412 ///
    1980:c_V8065 1981:c_V8689 1982:c_V9375 1983:c_V11022 1984:c_V12371 1985:c_V13623 ///
    1986:c_V14670 1987:c_V16144 1988:c_V17533 1989:c_V18875 1990:c_V20175 1991:c_V21481 ///
    1992:c_V23322 1993:c_ER4153 1994:c_ER6993 1995:c_ER9244 1996:c_ER12079 1997:c_ER16462 ///
    2000:c_ER20456 2002:c_ER24099 2004:c_ER28037 2006:c_ER41027 2008:c_ER46935 2010:c_ER52343 ///
    2012:c_ER58152 2014:c_ER65349 2016:c_ER71426 2018:c_ER77448 2020:c_ER81775 2022:c_ER85629 {

    local yr  = real(substr("`pair'", 1, strpos("`pair'", ":")-1))
    local var = substr("`pair'", strpos("`pair'", ":")+1, .)

    * last two digits of year
    local yy = substr(string(`yr'),3,2)

    capture confirm variable `var'
    if _rc continue

    rename `var' c_fam_inc_`yy'
}



avg_by_age , ///
    prefixes("m_wage_ f_wage_ m_earn_ f_earn_ m_inc_ f_inc_ fam_inc_ c_fam_inc_") ///
    birthvar(c_birth) ///
    windows("0-17 0-5 6-11 12-17") ///
    logs(1) ///
	ihs

avg_by_age , ///
    prefixes("c_earn_ c_inc_ c_wage_ ") ///
    birthvar(c_birth) ///
    windows("25-35 28-32 29-31 30-50 30-30") ///
    logs(1) ///
	ihs

xtile pct_earn_0_17 = m_ihs_earn_avg_0_17,  nquantiles(5)

egen m_ihs_work_hours_avg_0_17 = rowmean(m_ihs_work_hours_avg_0_5 m_ihs_work_hours_avg_6_11 m_ihs_work_hours_avg_12_17)

egen f_ihs_work_hours_avg_0_17 = rowmean(f_ihs_work_hours_avg_0_5 f_ihs_work_hours_avg_6_11 f_ihs_work_hours_avg_12_17)

save "$DTA\Reshaped.dta", replace
