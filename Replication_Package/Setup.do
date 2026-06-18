clear all
set more off
#delimit cr

*ssc install reghdfe, replace
*ssc install ivreghdfe, replace


global PROJ 	"C:\Users\valer\Desktop\Replication\JPEtemplate\Replication_Marcianò"
global ASCII 	"$PROJ\ASCII"
global DTA   	"$PROJ\dta"
global DO	"$PROJ\do"
global TABLES 	"$PROJ\tex\Tables"
global IMAGES	"$PROJ\tex\Images"


**********
*PROGRAMS*
**********

/****************************************************************************************
PROGRAM: avg_by_age
----------------------------------------------------------------------------------------
Computes the average of main var across age 

avg_by_age, 
	prefixes("m_earn_ f_earn_") // prefixes of the vars to average here vars are sturcutred like m_earn_68, m_earn_70 etc
	series("_nom") // suffixes to the variable if var is something like m_earn_68_nom
	birthvar(c_birth) // variable containing the birthyear that will be used to compute ages
	windows("0-17 0-5 6-11 12-17")  // age windows to average prefixed vars 
	logs(1) // in addition to levels do logs adding one log(x+1)
	ihs // in addition to levele do inverse hyperbolic sign


Can do:
- LOGS() option with optional shift:
		- logs(#)        -> ln(level + #) computed if level >= -# (so argument is a general shift, default 0)
			Example   avg_by_age ..., logs(1)       // ln(x+1)

- IHS option to create inverse hyperbolic sine transforms of the averaged outputs

IHS naming rule:
Insert "ihs_" after first underscore in output name; if none, prefix "ihs_".
Insert "ln_" after first underscore in output name; if none, prefix "ln_".

Examples: 
m_earn_avg_0_17 -> m_ihs_earn_avg_0_17
m_earn_avg_0_17 -> m_ln_earn_avg_0_17
****************************************************************************************/

capture program drop avg_by_age
program define avg_by_age
    version 16
    syntax , PREFIXES(string) BIRTHVAR(name) WINDOWS(string) ///
        [SERIES(string) LOGS(string) IHS]

    if "`series'" == "" local series ""

    local prefixes : list retokenize prefixes
    local winlist `windows'

    local tag ""
    if "`series'" == "_nom" local tag "nom"

    * -------------------------
    * LOGS handling
    * -------------------------
    local do_logs = 0
    local logshift = 0
    if "`logs'" != "" {
        local do_logs = 1
        if "`logs'" == "." local logshift = 0
        else local logshift = real("`logs'")
        if missing(`logshift') {
            di as err "logs() must be numeric, e.g. logs or logs(1) or logs(0.01)"
            exit 198
        }
    }

    * -------------------------
    * IHS handling (flag)
    * -------------------------
    local do_ihs = 0
    if "`ihs'" != "" local do_ihs = 1

    * numeric vars in memory
    ds, has(type numeric)
    local numvars `r(varlist)'

    * --------------------------------------------------
    * 1) Create accumulators and outputs for each (prefix, window)
    * --------------------------------------------------
    foreach pref of local prefixes {
        foreach w of local winlist {
            local dash = strpos("`w'","-")
            if `dash'==0 {
                di as err "Bad window token: `w' (expected a-b)"
                exit 198
            }
            local a = real(substr("`w'", 1, `dash'-1))
            local b = real(substr("`w'", `dash'+1, .))

            local out = "`pref'"
            if "`tag'" != "" local out = "`out'`tag'"
            local out = "`out'avg_`a'_`b'"

            local sname = "__s_`pref'"
            local nname = "__n_`pref'"
            if "`tag'" != "" {
                local sname = "`sname'`tag'_`a'_`b'"
                local nname = "`nname'`tag'_`a'_`b'"
            }
            else {
                local sname = "`sname'_`a'_`b'"
                local nname = "`nname'_`a'_`b'"
            }

            capture drop `out' `sname' `nname'
            gen double `out'   = .
            gen double `sname' = 0
            gen int    `nname' = 0
            label var `out' "Avg `pref'*`series' when child age `a'-`b'"

            * Pre-create ln var if requested (filled after averages computed)
            if `do_logs' {
                local pos = strpos("`out'","_")
                if `pos' > 0 {
                    local lnout = substr("`out'",1,`pos') + "ln_" + substr("`out'",`pos'+1,.)
                }
                else {
                    local lnout = "ln_`out'"
                }
                capture drop `lnout'
                gen double `lnout' = .
                if `logshift' == 0 {
                    label var `lnout' "ln(Avg `pref'*`series') when child age `a'-`b'"
                }
                else {
                    label var `lnout' "ln(Avg `pref'*`series' + `logshift') when child age `a'-`b'"
                }
            }

            * Pre-create ihs var if requested (filled after averages computed)
            if `do_ihs' {
                local pos = strpos("`out'","_")
                if `pos' > 0 {
                    local ihsout = substr("`out'",1,`pos') + "ihs_" + substr("`out'",`pos'+1,.)
                }
                else {
                    local ihsout = "ihs_`out'"
                }
                capture drop `ihsout'
                gen double `ihsout' = .
                label var `ihsout' "asinh(Avg `pref'*`series') when child age `a'-`b'"
            }
        }
    }

    * --------------------------------------------------
    * 2) For each prefix, discover available YY variables and loop over them
    * --------------------------------------------------
    foreach pref of local prefixes {

        local matched

        foreach v of local numvars {
            if "`series'" == "" {
                if regexm("`v'", "^`pref'[0-9][0-9]$") local matched `matched' `v'
            }
            else {
                if regexm("`v'", "^`pref'[0-9][0-9]`series'$") local matched `matched' `v'
            }
        }

        if "`matched'" == "" {
            di as txt "Note: no variables matched prefix `pref' with series(`series'). Skipping."
            continue
        }

        foreach v of local matched {

            local yy = substr("`v'", length("`pref'")+1, 2)
            local yr = cond(real("`yy'") >= 68, 1900 + real("`yy'"), 2000 + real("`yy'"))

            tempvar age
            gen double `age' = `yr' - `birthvar' if !missing(`birthvar')

            foreach w of local winlist {
                local dash = strpos("`w'","-")
                local a = real(substr("`w'", 1, `dash'-1))
                local b = real(substr("`w'", `dash'+1, .))

                local sname = "__s_`pref'"
                local nname = "__n_`pref'"
                if "`tag'" != "" {
                    local sname = "`sname'`tag'_`a'_`b'"
                    local nname = "`nname'`tag'_`a'_`b'"
                }
                else {
                    local sname = "`sname'_`a'_`b'"
                    local nname = "`nname'_`a'_`b'"
                }

                replace `sname' = `sname' + `v' if inrange(`age',`a',`b') & !missing(`v') & !missing(`age')
                replace `nname' = `nname' + 1    if inrange(`age',`a',`b') & !missing(`v') & !missing(`age')
            }

            drop `age'
        }
    }

    * --------------------------------------------------
    * 3) Finalize averages, optionally ln() / ln(+shift), optionally asinh(), and drop accumulators
    * --------------------------------------------------
    foreach pref of local prefixes {
        foreach w of local winlist {
            local dash = strpos("`w'","-")
            local a = real(substr("`w'", 1, `dash'-1))
            local b = real(substr("`w'", `dash'+1, .))

            local out = "`pref'"
            if "`tag'" != "" local out = "`out'`tag'"
            local out = "`out'avg_`a'_`b'"

            local sname = "__s_`pref'"
            local nname = "__n_`pref'"
            if "`tag'" != "" {
                local sname = "`sname'`tag'_`a'_`b'"
                local nname = "`nname'`tag'_`a'_`b'"
            }
            else {
                local sname = "`sname'_`a'_`b'"
                local nname = "`nname'_`a'_`b'"
            }

            capture confirm variable `sname'
            if _rc continue

            replace `out' = `sname' / `nname' if `nname' > 0

            if `do_logs' {
                local pos = strpos("`out'","_")
                if `pos' > 0 {
                    local lnout = substr("`out'",1,`pos') + "ln_" + substr("`out'",`pos'+1,.)
                }
                else {
                    local lnout = "ln_`out'"
                }

                if `logshift' == 0 {
                    replace `lnout' = ln(`out') if !missing(`out') & `out' > 0
                }
                else {
                    replace `lnout' = ln(`out' + `logshift') if !missing(`out') & (`out' + `logshift') > 0
                }
            }

            if `do_ihs' {
                local pos = strpos("`out'","_")
                if `pos' > 0 {
                    local ihsout = substr("`out'",1,`pos') + "ihs_" + substr("`out'",`pos'+1,.)
                }
                else {
                    local ihsout = "ihs_`out'"
                }

                replace `ihsout' = asinh(`out') if !missing(`out')
            }

            drop `sname' `nname'
        }
    }
end


/****************************************************************************************
EXAMPLE USAGE
----------------------------------------------------------------------------------------

1) Levels only:
avg_by_age , prefixes("m_earn_ f_earn_") birthvar(c_birth) windows("0-17 0-5 6-11 12-17")

2) Logs in the standard way (ln(x), requires x>0):
avg_by_age , prefixes("m_earn_ f_earn_") birthvar(c_birth) windows("0-17 0-5 6-11 12-17") logs

3) Logs with +1 shift (ln(x+1), allows zeros):
avg_by_age , prefixes("m_earn_ f_earn_") birthvar(c_birth) windows("0-17 0-5 6-11 12-17") logs(1)

4) Nominal series + ln(x+1):
avg_by_age , prefixes("m_earn_ f_earn_") birthvar(c_birth) windows("0-17 0-5 6-11 12-17") series("_nom") logs(1)

****************************************************************************************/



cap program drop balance_check
program define balance_check, eclass
    syntax varlist, by(varname) groups(numlist min=2 max=2) ///
           [textable(string) savein(string)]

    tokenize "`groups'"
    local g1 = `1'
    local g2 = `2'
    local nvar : word count `varlist'

    tempname smd pval s1lb s1ub s2lb s2ub dummyV
    matrix `smd'  = J(1, `nvar', .)
    matrix `pval' = J(1, `nvar', .)
    matrix `s1lb' = J(1, `nvar', .)
    matrix `s1ub' = J(1, `nvar', .)
    matrix `s2lb' = J(1, `nvar', .)
    matrix `s2ub' = J(1, `nvar', .)
    matrix `dummyV' = I(`nvar')

    local i = 1
    foreach var of local varlist {
        quietly ttest `var' if inlist(`by', `g1', `g2'), by(`by')
        
        * Store CIs for Group 1 and Group 2
        matrix `s1lb'[1, `i'] = r(mu_1) - (invt(r(N_1)-1, 0.975) * r(sd_1) / sqrt(r(N_1)))
        matrix `s1ub'[1, `i'] = r(mu_1) + (invt(r(N_1)-1, 0.975) * r(sd_1) / sqrt(r(N_1)))
        matrix `s2lb'[1, `i'] = r(mu_2) - (invt(r(N_2)-1, 0.975) * r(sd_2) / sqrt(r(N_2)))
        matrix `s2ub'[1, `i'] = r(mu_2) + (invt(r(N_2)-1, 0.975) * r(sd_2) / sqrt(r(N_2)))

        * Calculate SMD
        local pooled_sd = sqrt(((`r(N_1)'-1)*`r(sd_1)'^2 + (`r(N_2)'-1)*`r(sd_2)'^2) / (`r(N_1)'+`r(N_2)'-2))
        local smd_val = (r(mu_1) - r(mu_2)) / `pooled_sd'
        matrix `smd'[1, `i']  = `smd_val'
        
        * USER LOGIC: Find the minimum of the three p-values
        local min_p = min(r(p_l), r(p), r(p_u))
        matrix `pval'[1, `i'] = `min_p'

        * THE TRICK: Calculate a "fake" variance so esttab automatically generates the correct star
        local safe_p = max(1e-15, `min_p')
        local z_val = invnormal(1 - `safe_p'/2)
        local fake_v = (`smd_val' / `z_val')^2
        if `smd_val' == 0 local fake_v = 1 // Safety catch to avoid division by zero
        matrix `dummyV'[`i', `i'] = `fake_v'

        local i = `i' + 1
    }

    * Set Variable Names across all matrices
    foreach m in `smd' `pval' `s1lb' `s1ub' `s2lb' `s2ub' {
        matrix colnames `m' = `varlist'
    }
    matrix colnames `dummyV' = `varlist'
    matrix rownames `dummyV' = `varlist'
    
    * Post the SMD and our newly engineered variance matrix
    ereturn post `smd' `dummyV'
    
    ereturn matrix mypvals = `pval'
    ereturn matrix c1_lb   = `s1lb'
    ereturn matrix c1_ub   = `s1ub'
    ereturn matrix c2_lb   = `s2lb'
    ereturn matrix c2_ub   = `s2ub'

    * File Export Handling
    local export ""
    if "`textable'" != "" {
        local path = subinstr("`savein'", "\", "/", .)
        if "`path'" != "" local path "`path'/"
        local export "using "`path'`textable'.tex""
    }

    * Final Table Output
    display _n as text "{bf:Balance Check: 95% CIs and Standardized Differences}"
    
    esttab . `export', ///
        replace label booktabs ///
        cells("c1_lb(fmt(2) par) c1_ub(fmt(2) par) c2_lb(fmt(2) par) c2_ub(fmt(2) par) b(star fmt(2))") ///
        star(* 0.10) /// <-- Triggers a star based on our engineered variance
        collabels("(S`g1' LB)" "(S`g1' UB)" "(S`g2' LB)" "(S`g2' UB)" "SMD") ///
        title("Group Confidence Intervals and SMDs") ///
        nonumbers nomtitles varwidth(35)
end

********
*LABELS*
********

capture label drop state_lbl
label define state_lbl ///
    1  "Alabama" ///
    2  "Arizona" ///
    3  "Arkansas" ///
    4  "California" ///
    5  "Colorado" ///
    6  "Connecticut" ///
    7  "Delaware" ///
    8  "District of Columbia" ///
    9  "Florida" ///
    10 "Georgia" ///
    11 "Idaho" ///
    12 "Illinois" ///
    13 "Indiana" ///
    14 "Iowa" ///
    15 "Kansas" ///
    16 "Kentucky" ///
    17 "Louisiana" ///
    18 "Maine" ///
    19 "Maryland" ///
    20 "Massachusetts" ///
    21 "Michigan" ///
    22 "Minnesota" ///
    23 "Mississippi" ///
    24 "Missouri" ///
    25 "Montana" ///
    26 "Nebraska" ///
    27 "Nevada" ///
    28 "New Hampshire" ///
    29 "New Jersey" ///
    30 "New Mexico" ///
    31 "New York" ///
    32 "North Carolina" ///
    33 "North Dakota" ///
    34 "Ohio" ///
    35 "Oklahoma" ///
    36 "Oregon" ///
    37 "Pennsylvania" ///
    38 "Rhode Island" ///
    39 "South Carolina" ///
    40 "South Dakota" ///
    41 "Tennessee" ///
    42 "Texas" ///
    43 "Utah" ///
    44 "Vermont" ///
    45 "Virginia" ///
    46 "Washington" ///
    47 "West Virginia" ///
    48 "Wisconsin" ///
    49 "Wyoming" ///
    50 "Alaska" ///
    51 "Hawaii"