#delimit cr
set more off

****************************************************
* Build instrument: pill_at_XX
****************************************************

****************************************************
* User settings
****************************************************
local agecuts "18"              // can be "16 18 19" etc
local yy_list "68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 99 01 03 05 07 09 11 13 15 17 19 21 23"

****************************************************
* Mapping: parent state variable by wave (two digit year)
****************************************************
local st_68 V93
local st_69 V537
local st_70 V1103
local st_71 V1803
local st_72 V2403
local st_73 V3003
local st_74 V3403
local st_75 V3803
local st_76 V4303
local st_77 V5203
local st_78 V5703
local st_79 V6303
local st_80 V6903
local st_81 V7503
local st_82 V8203
local st_83 V8803
local st_84 V10003
local st_85 V11103
local st_86 V12503
local st_87 V13703
local st_88 V14803
local st_89 V16303
local st_90 V17703
local st_91 V19003
local st_92 V20303
local st_93 V21603
local st_94 ER4156
local st_95 ER6996
local st_96 ER9247
local st_97 ER12221
local st_99 ER13004
local st_01 ER17004
local st_03 ER21003
local st_05 ER25003
local st_07 ER36003
local st_09 ER42003
local st_11 ER47303
local st_13 ER53003
local st_15 ER60003
local st_17 ER66003
local st_19 ER72003
local st_21 ER78003
local st_23 ER82003

****************************************************
* Contraception access lookup table
* NOTE: we rename statecode -> _stkey to match merge key
****************************************************
tempfile contrac
preserve
clear
input byte statecode byte age69 byte age71 byte age74
1  21 17 17
2  21 18 18
3  18 14 14
4  15 15 15
5  21 14 14
6  21 18 18
7  21 21 18
8  21 14 14
9  21 21 14
10 14 14 14
11 18 18 14
12 21 14 14
13 21 21 18
14 21 21 14
15 21 21 14
16 18 18 14
17 21 21 14
18 21 18 18
19 21 18 14
20 21 21 18
21 21 14 14
22 21 18 18
23 14 14 14
24 21 21 21
25 21 19 18
26 20 20 19
27 18 18 18
28 21 14 14
29 21 21 18
30 21 18 14
31 21 16 16
32 21 18 18
33 21 18 18
34 21 21 14
35 18 18 14
36 21 15 15
37 21 18 18
38 21 21 18
39 21 21 16
40 21 21 18
41 21 14 14
42 21 21 18
43 18 18 18
44 21 18 18
45 21 21 14
46 21 18 18
47 21 21 14
48 21 18 18
49 21 21 14
50 19 19 14
51 20 20 20
end

rename statecode _stkey
isid _stkey
save `contrac', replace
restore

cap label drop state_lbl 
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


*********************************
* Diagnostics: do key vars exist?
*********************************
di as text "Checking presence of parental birth variablee in dataset..."
capture confirm variable p_birth
if _rc {
    di as error "ERROR: p_birth not found. Stop."
    exit 111
}

di as text "Checking presence of parental role variablee in dataset..."
capture confirm variable p_G1TYPE
if _rc {
    di as error "ERROR: p_G1TYPE not found. Stop."
    exit 111
}

di as text "Checking presence of state variables p_*  in dataset..."
local missing_state_vars 0
foreach yy of local yy_list {
    local ST "`st_`yy''"
    capture confirm variable p_`ST'
    if _rc {
        di as error "Missing: p_`ST' (year `yy')"
        local missing_state_vars = `missing_state_vars' + 1
    }
}
di as text "Done. Missing state vars count = `missing_state_vars'"
di as text "If missing>0 it is OK if those years are not in your extract; they will be skipped." 

***********************************************************
* Build pill_at_XX for mothers, using state at XX or before
* + Checks for every cutoff age in local agecuts
***********************************************************
foreach ac of local agecuts {

    local acnum = real("`ac'")
    di as text "---- Building pill_at_`ac' (cutoff age=`acnum') ----"

    * cutoff year
    capture drop p_yearcut_`ac'
    gen int p_yearcut_`ac' = p_birth + `acnum' if p_G1TYPE=="M"

    * state at/before cutoff
    capture drop p_state_at_`ac' p_stateyear_at_`ac'
    gen byte p_state_at_`ac' = .
    gen int  p_stateyear_at_`ac' = .

    foreach yy of local yy_list {

        local yyn = real("`yy'")
        local yr  = cond(`yyn' >= 68, 1900 + `yyn', 2000 + `yyn')

        local ST "`st_`yy''"
        capture confirm variable p_`ST'
        if _rc continue

        replace p_state_at_`ac' = p_`ST' if p_G1TYPE=="M" ///
            & !missing(p_yearcut_`ac') ///
            & `yr' <= p_yearcut_`ac' ///
            & !missing(p_`ST') ///
            & (missing(p_stateyear_at_`ac') | `yr' > p_stateyear_at_`ac')

        replace p_stateyear_at_`ac' = `yr' if p_G1TYPE=="M" ///
            & !missing(p_yearcut_`ac') ///
            & `yr' <= p_yearcut_`ac' ///
            & !missing(p_`ST') ///
            & (missing(p_stateyear_at_`ac') | `yr' > p_stateyear_at_`ac')
    }

    * diagnostics: how many mothers missing state at cutoff
    quietly count if p_G1TYPE=="M" & !missing(p_yearcut_`ac') & missing(p_state_at_`ac')
    di as result "Mothers with missing state_at_`ac': " r(N)

    * age when the chosen state is observed
    capture drop p_age_state_at_`ac'
    gen int p_age_state_at_`ac' = p_stateyear_at_`ac' - p_birth if p_G1TYPE=="M" & !missing(p_stateyear_at_`ac', p_birth)

    di as text "State observation age summary (mothers) for cutoff age `acnum':"
    quietly sum p_age_state_at_`ac' if p_G1TYPE=="M" & !missing(p_age_state_at_`ac'), detail
    di as result "  min=" %9.0g r(min) "  p25=" %9.0g r(p25) "  p50=" %9.0g r(p50) "  p75=" %9.0g r(p75) "  max=" %9.0g r(max)

    * merge legal minimum ages
    capture drop _stkey
    gen byte _stkey = p_state_at_`ac'

    qui merge m:1 _stkey using `contrac'
    di as text "Merge results with contrac lookup (mothers):"
    tab _merge if p_G1TYPE=="M", missing
    drop if _merge==2
    drop _merge

    * legal minimum for that cutoff year
    capture drop p_legalmin_`ac'
    gen byte p_legalmin_`ac' = .
    replace p_legalmin_`ac' = age69 if !missing(p_yearcut_`ac') & p_yearcut_`ac' < 1971
    replace p_legalmin_`ac' = age71 if !missing(p_yearcut_`ac') & inrange(p_yearcut_`ac', 1971, 1973)
    replace p_legalmin_`ac' = age74 if !missing(p_yearcut_`ac') & p_yearcut_`ac' >= 1974

    * instrument: 0 before 1969, else compare cutoff age to legal min
    capture drop p_pill_at_`ac'
    gen byte p_pill_at_`ac' = .
    replace p_pill_at_`ac' = 0 if p_G1TYPE=="M" & !missing(p_yearcut_`ac') & p_yearcut_`ac' < 1969
    replace p_pill_at_`ac' = (`acnum' >= p_legalmin_`ac') if p_G1TYPE=="M" ///
        & !missing(p_yearcut_`ac') & p_yearcut_`ac' >= 1969 ///
        & !missing(p_legalmin_`ac')

    label var p_pill_at_`ac' "Mother legal contraception access at age `acnum' (state at/before age `acnum')"

    di as text "pill_at_`ac' distribution among mothers with nonmissing:"
    tab p_pill_at_`ac' if p_G1TYPE=="M", missing

    * spread within mother id if repeated rows
    capture confirm variable p_id
    if !_rc {
        bysort p_id: egen p_pill_at_`ac'_m = max(p_pill_at_`ac')
        drop p_pill_at_`ac'
        rename p_pill_at_`ac'_m p_pill_at_`ac'
    }

	
	    * ----------------------------------------------------------
    * Exposure length: how many years mother had legal access
    * up to cutoff age `acnum' (inclusive)
    * Creates: p_exposure_at_`ac'
    * ----------------------------------------------------------
    capture drop p_exposure_at_`ac'
    gen int p_exposure_at_`ac' = . 

    * before policy era: define as zero (if cutoff year < 1969)
    replace p_exposure_at_`ac' = 0 if p_G1TYPE=="M" ///
        & !missing(p_yearcut_`ac') ///
        & p_yearcut_`ac' < 1969

    * from 1969 onward: years exposed = max(0, acnum - legalmin + 1)
    replace p_exposure_at_`ac' = max(0, `acnum' - p_legalmin_`ac' + 1) if p_G1TYPE=="M" ///
        & !missing(p_yearcut_`ac') ///
        & p_yearcut_`ac' >= 1969 ///
        & !missing(p_legalmin_`ac')

    label var p_exposure_at_`ac' "Years mother had legal pill access up to age `acnum' (inclusive)"

    * spread within mother id if repeated rows
    capture confirm variable p_id
    if !_rc {
        bysort p_id: egen p_exposure_at_`ac'_m = max(p_exposure_at_`ac')
        drop p_exposure_at_`ac'
        rename p_exposure_at_`ac'_m p_exposure_at_`ac'
    }

    * quick check among mothers
    di as text "Exposure summary among mothers (cutoff age `acnum'):"
    sum p_exposure_at_`ac' if p_G1TYPE=="M", detail

	
	
    ***********************************************************
    * Checks (run for each cutoff age `ac')
    ***********************************************************

    * Check 1: at what age is the chosen state observed?
    di as text "CHECK 1: At what age is the mother's chosen state observed for cutoff age `acnum'?"
    tab p_age_state_at_`ac' if p_G1TYPE=="M" & !missing(p_age_state_at_`ac'), missing

    * Check 2: distribution of usable instrument observations by state
	di as text "CHECK 2: Distribution by state for mothers with nonmissing pill_at_`ac' and state_at_`ac'"
	label values p_state_at_`ac' state_lbl

	graph bar (count) ///
    if p_G1TYPE=="M" & !missing(p_pill_at_`ac') & !missing(p_state_at_`ac'), ///
    over(p_pill_at_`ac') ///
    over(p_state_at_`ac', label(angle(45) labsize(vsmall))) /// <-- Change here
    stack ///
    asyvars ///
    title("Instrument observed (pill_at_`ac') by state") ///
    subtitle("State observed at or before age `acnum'") ///
    legend(title("Pill Status") size(small))
	
	graph export "$IMAGES\pill_by_state.png", replace
	
    * Check 3: among mothers missing state_at_`ac', do we ever observe state in any wave?
    di as text "CHECK 3: For mothers missing state at or before age `acnum', is state ever observed later?"
    capture drop p_has_any_state_anyyear_`ac'
    gen byte p_has_any_state_anyyear_`ac' = 0 if p_G1TYPE=="M" & !missing(p_yearcut_`ac') & missing(p_state_at_`ac')

    foreach yy of local yy_list {
        local ST "`st_`yy''"
        capture confirm variable p_`ST'
        if _rc continue
        replace p_has_any_state_anyyear_`ac' = 1 if p_G1TYPE=="M" ///
            & !missing(p_yearcut_`ac') & missing(p_state_at_`ac') ///
            & !missing(p_`ST')
    }

    tab p_has_any_state_anyyear_`ac' if p_G1TYPE=="M" & !missing(p_yearcut_`ac') & missing(p_state_at_`ac'), missing

	
	* Check 4: For women missing state at/before cutoff: when do we first observe state later, and how far after the cutoff is that?
	di "CHECK 4: For mothers missing state at/before age 18, when is state first observed later?"

	* size of the problem group (mother-rows)
	quietly count if p_G1TYPE=="M" & !missing(p_yearcut_`ac') & missing(p_state_at_`ac')
	di as result "Mothers missing state at/before cutoff (row-level): " r(N)

	* size at mother-id level (unique mothers), if p_id exists
	capture confirm variable p_id
	if !_rc {
		preserve
			keep if p_G1TYPE=="M" & !missing(p_yearcut_`ac') & missing(p_state_at_`ac')
			bysort p_id: keep if _n==1
			di as result "Mothers missing state at/before cutoff (unique p_id): " _N
		restore
	}

	* confirm: among missing-at-cutoff, is state ever observed later?
	tab p_has_any_state_anyyear_`ac' if p_G1TYPE=="M" & !missing(p_yearcut_`ac') & missing(p_state_at_`ac'), missing

	
	* Build vars for analysis
	* p_firststate_year = Earliest observed mother state year (only for those missing state <= cutoff)
	* p_firststate_code "Mother state code at earliest observed year (post-cutoff group)
	* p_firststate_gap  "Years after cutoff when mother state first observed (post-cutoff group)"
	
	capture drop p_firststate_year p_firststate_code
	gen int  p_firststate_year = .
	gen byte p_firststate_code = .

	foreach yy of local yy_list {
		local yyn = real("`yy'")
		local yr  = cond(`yyn' >= 68, 1900 + `yyn', 2000 + `yyn')
		local ST "`st_`yy''"
		capture confirm variable p_`ST'
		if _rc continue

		replace p_firststate_year = `yr' if p_G1TYPE=="M" ///
			& !missing(p_yearcut_`ac') ///
			& missing(p_state_at_`ac') ///
			& !missing(p_`ST') ///
			& missing(p_firststate_year)

		replace p_firststate_code = p_`ST' if p_G1TYPE=="M" ///
			& !missing(p_yearcut_`ac') ///
			& missing(p_state_at_`ac') ///
			& !missing(p_`ST') ///
			& p_firststate_year == `yr'
	}

	* distance from cutoff
	capture drop p_firststate_gap
	gen int p_firststate_gap = p_firststate_year - p_yearcut_`ac' if p_G1TYPE=="M" ///
		& missing(p_state_at_`ac') & !missing(p_firststate_year, p_yearcut_`ac')

	* spread to all rows of same mother (unique mother-level values)
	capture confirm variable p_id
	if !_rc {
		bysort p_id: egen p_firststate_year_m = max(p_firststate_year)
		bysort p_id: egen p_firststate_code_m = max(p_firststate_code)
		bysort p_id: egen p_firststate_gap_m  = max(p_firststate_gap)

		drop p_firststate_year p_firststate_code p_firststate_gap
		rename p_firststate_year_m p_firststate_year
		rename p_firststate_code_m p_firststate_code
		rename p_firststate_gap_m  p_firststate_gap
	}

}


	/* How many in the post-cutoff group still never get observed (should be 0 if your tab is all 1s)
	quietly count if p_G1TYPE=="M" & missing(p_state_at_`ac') & !missing(p_yearcut_`ac') & missing(p_firststate_year)
	di "Missing-at-cutoff mothers with NO later state observed: " r(N)

	* Distribution of first observed year
	di "First observed state YEAR (post-cutoff group):"
	tab p_firststate_year p_birth if p_G1TYPE=="M" & missing(p_state_at_`ac') & !missing(p_yearcut_`ac'), missing

	* Gap distribution: how far after cutoff
	di "Gap in years after cutoff when state first observed:"
	tab p_firststate_gap if p_G1TYPE=="M" & missing(p_state_at_`ac') & !missing(p_yearcut_`ac'), missing


	****************************
	
    * clean up lookup vars so next iteration can re-merge cleanly
    drop age69 age71 age74 _stkey
