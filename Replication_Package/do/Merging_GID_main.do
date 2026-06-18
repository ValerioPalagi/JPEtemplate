*******************************************************
* Merge GID-PRO parent-child mapping to ALL PSID vars
* + add Income_clean (inc_*) and Earnings_clean (earn_*)
*******************************************************
clear all
do "../Setup.do"

*-----------------------
* Prepare Main PSID for Merge (ALL variables)
*-----------------------
use "$DTA\Minimal_PSID.dta", clear

* create ID to merge
capture drop id
gen long id = ER30001*1000 + ER30002
order id

* Save full PSID as temp (all vars kept)
tempfile psid_full
save "`psid_full'", replace

* Parents PSID full (all vars)
tempfile psid_parents
preserve
    use "`psid_full'", clear
    rename id p_id
    save "`psid_parents'", replace
restore

* Children PSID full (all vars)
tempfile psid_children
preserve
    use "`psid_full'", clear
    rename id c_id
    save "`psid_children'", replace
restore

*-----------------------
* Prepare Income/Earnings prefixed datasets for parent/child
*-----------------------
tempfile inc_parents inc_children earn_parents earn_children

preserve
    use "$DTA\Income_clean.dta", clear
    capture confirm variable id
    if _rc {
        di as err "Income_clean.dta must contain variable id"
        exit 198
    }
    rename id p_id
    ds p_id, not
    foreach v of varlist `r(varlist)' {
        rename `v' p_`v'
    }
    save "`inc_parents'", replace
restore

preserve
    use "$DTA\Income_clean.dta", clear
    capture confirm variable id
    if _rc {
        di as err "Income_clean.dta must contain variable id"
        exit 198
    }
    rename id c_id
    ds c_id, not
    foreach v of varlist `r(varlist)' {
        rename `v' c_`v'
    }
    save "`inc_children'", replace
restore

preserve
    use "$DTA\Earnings_clean.dta", clear
    capture confirm variable id
    if _rc {
        di as err "Earnings_clean.dta must contain variable id"
        exit 198
    }
    rename id p_id
    ds p_id, not
    foreach v of varlist `r(varlist)' {
        rename `v' p_`v'
    }
    save "`earn_parents'", replace
restore

preserve
    use "$DTA\Earnings_clean.dta", clear
    capture confirm variable id
    if _rc {
        di as err "Earnings_clean.dta must contain variable id"
        exit 198
    }
    rename id c_id
    ds c_id, not
    foreach v of varlist `r(varlist)' {
        rename `v' c_`v'
    }
    save "`earn_children'", replace
restore

*-----------------------
* Open GID PRO
*-----------------------
use "$DTA\Gid_pro_clean", clear

*-----------------------
* MERGING: Parents (ALL PSID vars)
*-----------------------
merge m:1 p_id using "`psid_parents'", keep(match master)
rename _merge p__merge

* prefix parent variables (exclude keys + original linkage vars)
ds p_id c_id, not
foreach v of varlist `r(varlist)' {
    rename `v' p_`v'
}

* Add parent income and earnings
merge m:1 p_id using "`inc_parents'", keep(match master)
drop _merge
merge m:1 p_id using "`earn_parents'", keep(match master)
drop _merge

*-----------------------
* MERGING: Children (ALL PSID vars)
*-----------------------
merge m:1 c_id using "`psid_children'", keep(match master)
rename _merge c__merge

* prefix child variables (only the newly merged-in vars, not keys nor p_ vars)
ds p_id c_id p_*, not
foreach v of varlist `r(varlist)' {
    rename `v' c_`v'
}

* Add child income and earnings
merge m:1 c_id using "`inc_children'", keep(match master)
drop _merge
merge m:1 c_id using "`earn_children'", keep(match master)
drop _merge

*-----------------------------------------------------
* Keep only merges for which I have PSID survey records
*-----------------------------------------------------
keep if p_p__merge==3 & c_c__merge==3
drop p_p__merge  c_c__merge

*-----------------------
* Save result
*-----------------------
save "$DTA\parent_child_PSID.dta", replace
