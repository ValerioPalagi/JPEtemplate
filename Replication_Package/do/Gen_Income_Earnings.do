clear all

do "../Setup.do"

do "$DO/Income_reader.do"
/****************************************************************************************
SAFE PSID INCOME construction (manual mapping, missing treated as zero within sums)
----------------------------------------------------------------------------------------
This version treats missing components as 0 *when at least one component is observed*.
If ALL components for that year are missing, inc_YY is set to missing.

Mechanics for each summed year:
1) egen inc_YY = rowtotal(component vars)         // sums treating missing as 0
2) egen nYY    = rownonmiss(component vars)       // counts nonmissing components
3) replace inc_YY = . if nYY==0                   // if all components missing -> missing
4) drop nYY

Only the explicitly listed years are summed.
****************************************************************************************/

use "$DTA\Income_raw.dta", clear

* 0) Create merge id
capture drop id
gen long id = ER30001*1000 + ER30002
label var id "PSID constructed person id (ER30001*1000 + ER30002)"

*******************************************************
* 1) Pre-1975: single money-income measure (direct)
*    (No summing needed; missing stays missing)
*******************************************************
gen double inc_68 = ER30012
gen double inc_69 = ER30033
gen double inc_70 = ER30057
gen double inc_71 = ER30081
gen double inc_72 = ER30106
gen double inc_73 = ER30130
gen double inc_74 = ER30152   

*******************************************************
* 2) 1974–1989: total income = taxable + transfer (summed with rowtotal)
*    NOTE: inc_74 here refers to TAXABLE+TRANSFER for income year 1974.
*******************************************************

/* 1974 income (reported in 1975 wave): ER30173 (taxable) + ER30175 (transfer)
egen double inc_74 = rowtotal(ER30173 ER30175)
egen byte n74 = rownonmiss(ER30173 ER30175)
replace inc_74 = . if n74==0
drop n74
*/

* 1975 income
egen double inc_75 = rowtotal(ER30202 ER30209)
egen byte n75 = rownonmiss(ER30202 ER30209)
replace inc_75 = . if n75==0
drop n75

* 1976 income
egen double inc_76 = rowtotal(ER30231 ER30238)
egen byte n76 = rownonmiss(ER30231 ER30238)
replace inc_76 = . if n76==0
drop n76

* 1977 income
egen double inc_77 = rowtotal(ER30268 ER30275)
egen byte n77 = rownonmiss(ER30268 ER30275)
replace inc_77 = . if n77==0
drop n77

* 1978 income
egen double inc_78 = rowtotal(ER30298 ER30305)
egen byte n78 = rownonmiss(ER30298 ER30305)
replace inc_78 = . if n78==0
drop n78

* 1979 income
egen double inc_79 = rowtotal(ER30328 ER30335)
egen byte n79 = rownonmiss(ER30328 ER30335)
replace inc_79 = . if n79==0
drop n79

* 1980 income
egen double inc_80 = rowtotal(ER30358 ER30365)
egen byte n80 = rownonmiss(ER30358 ER30365)
replace inc_80 = . if n80==0
drop n80

* 1981 income
egen double inc_81 = rowtotal(ER30386 ER30391)
egen byte n81 = rownonmiss(ER30386 ER30391)
replace inc_81 = . if n81==0
drop n81

* 1982 income
egen double inc_82 = rowtotal(ER30415 ER30420)
egen byte n82 = rownonmiss(ER30415 ER30420)
replace inc_82 = . if n82==0
drop n82

* 1983 income
egen double inc_83 = rowtotal(ER30445 ER30455)
egen byte n83 = rownonmiss(ER30445 ER30455)
replace inc_83 = . if n83==0
drop n83

* 1984 income
egen double inc_84 = rowtotal(ER30480 ER30490)
egen byte n84 = rownonmiss(ER30480 ER30490)
replace inc_84 = . if n84==0
drop n84

* 1985 income
egen double inc_85 = rowtotal(ER30515 ER30525)
egen byte n85 = rownonmiss(ER30515 ER30525)
replace inc_85 = . if n85==0
drop n85

* 1986 income
egen double inc_86 = rowtotal(ER30551 ER30561)
egen byte n86 = rownonmiss(ER30551 ER30561)
replace inc_86 = . if n86==0
drop n86

* 1987 income
egen double inc_87 = rowtotal(ER30586 ER30596)
egen byte n87 = rownonmiss(ER30586 ER30596)
replace inc_87 = . if n87==0
drop n87

* 1988 income
egen double inc_88 = rowtotal(ER30622 ER30632)
egen byte n88 = rownonmiss(ER30622 ER30632)
replace inc_88 = . if n88==0
drop n88

* 1989 income
egen double inc_89 = rowtotal(ER30659 ER30669)
egen byte n89 = rownonmiss(ER30659 ER30669)
replace inc_89 = . if n89==0
drop n89

*******************************************************
* 3) 1990–1992: total income = labor + asset + transfer (summed with rowtotal)
*******************************************************

* 1990 income
egen double inc_90 = rowtotal(ER30705 ER30707 ER30717)
egen byte n90 = rownonmiss(ER30705 ER30707 ER30717)
replace inc_90 = . if n90==0
drop n90

* 1991 income
egen double inc_91 = rowtotal(ER30750 ER30752 ER30762)
egen byte n91 = rownonmiss(ER30750 ER30752 ER30762)
replace inc_91 = . if n91==0
drop n91

* 1992 income
egen double inc_92 = rowtotal(ER30821 ER30822 ER30825)
egen byte n92 = rownonmiss(ER30821 ER30822 ER30825)
replace inc_92 = . if n92==0
drop n92

*******************************************************
* 4) 2005+ OFUM total taxable income (already totals; no summing)
*    Missing stays missing here.
*******************************************************
gen double inc_05 = ER33838F
gen double inc_07 = ER33938F
gen double inc_09 = ER34032D
gen double inc_11 = ER34144D
gen double inc_13 = ER34251D
gen double inc_15 = ER34401D
gen double inc_17 = ER34639
gen double inc_19 = ER34848
gen double inc_21 = ER35049
gen double inc_23 = ER35249

*******************************************************
* 5) Finalize: keep merge-ready vars only
*******************************************************
keep id inc_*
compress


/****************************************************************************************
DEFLATE inc_YY variables to 2023 USD (CPI-U annual, 2023=100), keeping nominal for comparison
--------------------------------------------------------------------------------------------
Assumptions
- You already created inc_YY variables (inc_68, inc_69, ..., inc_23) in the dataset in memory
- Your CPI file exists: $DTA\BLS_CPI_2023.dta with variables: year, cpi
  and cpi is normalized so that 2023=100 (same convention you used elsewhere)

What this code does
1) Loads CPI and caches deflator factors in locals: defl_YYYY = 100 / cpi(YYYY)
2) Creates nominal copies inc_YY_nom = inc_YY (so you can compare later)
3) Deflates inc_YY in place to 2023 dollars using the correct 4-digit year for each suffix YY
   - YY 68-99 -> 1968-1999
   - YY 00-23 -> 2000-2023
4) Updates variable labels to indicate deflation, if labels exist

How it handles missing CPI
- If CPI for a given year is missing, it skips that inc_YY and prints an error message.

****************************************************************************************/

* -------------------------
* 0) Load CPI and cache factors in locals
* -------------------------
preserve
    use "$DTA\BLS_CPI_2023.dta", clear
    keep year cpi
    drop if missing(year) | missing(cpi)

    levelsof year, local(cpi_years)
    foreach y of local cpi_years {
        quietly summarize cpi if year==`y', meanonly
        local defl_`y' = 100 / r(mean)
    }
restore

* -------------------------
* 1) Make nominal copies for comparison (inc_YY_nom)
* -------------------------
ds inc_*, has(type numeric)
local incvars `r(varlist)'

foreach v of local incvars {
    if strpos("`v'", "_nom") continue
    capture drop `v'_nom
    gen double `v'_nom = `v'
    label var `v'_nom "Nominal (original) `v'"
}

* -------------------------
* 2) Deflate inc_YY in place to 2023 USD
*    Robust check for deflator existence: test the macro content, not confirm local
* -------------------------
foreach v of local incvars {
    if strpos("`v'", "_nom") continue

    * Extract YY from inc_YY
    local yy = substr("`v'", 5, 2)
    local yy_num = real("`yy'")

    * Convert YY -> 4-digit year
    local yr = cond(`yy_num' >= 68, 1900 + `yy_num', 2000 + `yy_num')

    * Robust existence check: if macro is empty, CPI is missing
    if "`defl_`yr''" == "" {
        di as err "Missing CPI for year `yr' (needed for `v'). Skipping."
        continue
    }

    quietly replace `v' = `v' * `defl_`yr'' if !missing(`v')

    * Safer label handling (no embedded newline)
    local oldlab : variable label `v'
    local addlab "deflated to 2023 USD"
    if "`oldlab'" == "" label var `v' "`addlab'"
    else               label var `v' "`oldlab' | `addlab'"
}

* -------------------------
* Quick check: compare one year nominal vs deflated
* -------------------------
*sanity check
summarize inc_68 inc_74 inc_89 inc_90 inc_05 inc_23

summarize inc_90_nom inc_90 inc_05_nom inc_05


save "$DTA\Income_clean.dta", replace


*************************************






/****************************************************************************************
CREATE earnings series earn_YY + DEFLATE to 2023 USD (CPI-U annual, 2023=100)
----------------------------------------------------------------------------------------
Uses the SAME principles as our income logic:

EARNINGS ("earn_YY") definition (manual, label-free, safe):
- 1968–1974: use ER30012 ER30033 ER30057 ER30081 ER30106 ER30130 ER30152
            (these are "money income ind YY"; for heads/wives this behaves like labor-only,
             for others it can be broader; we keep it as early-era earnings proxy)
- 1975–1990: use the same "taxable income" series as a labor/earnings proxy:
            ER30173 ER30202 ... ER30659  (one var per reference year)
            (no transfers summed here; this is earnings proxy only)
- 1991–1993: labor income only:
            ER30705 (1990) ER30750 (1991) ER30821 (1992)
- 1997–2005: clean earnings series:
            ER33537N (1997) ER33628N (1999) ER33728N (2001) ER33826A (2003) ER33926A (2005)
- 2006+ (biennial): OFUM labor income:
            ER33938C (2006) ER34032A (2008) ER34144A (2010) ER34251A (2012)
            ER34401A (2014) ER34636 (2016) ER34845 (2018) ER35046 (2020) ER35246 (2022)

Deflation:
- Creates nominal copies earn_YY_nom for comparison
- Deflates earn_YY in place using CPI file $DTA\BLS_CPI_2023.dta (year, cpi; 2023=100)
- Robust CPI availability check using macro contents (no confirm local pitfalls)

Assumes:
- You already have id OR you can build it from ER30001 and ER30002.
- Run after loading your wide extract OR after merging to a file that still contains ER vars.

****************************************************************************************/

* -------------------------------------------------------------------
* 0) Ensure id exists (if not already created)
* -------------------------------------------------------------------
use "$DTA\Earnings_raw.dta", clear

gen id = ER30001*1000 + ER30002


capture confirm variable id


* -------------------------------------------------------------------
* 1) Create earn_YY variables (manual mapping; no summing)
*    Missing years remain missing by design.
* -------------------------------------------------------------------

* Early era proxy (1968–1974 reference years)
capture drop earn_68 earn_69 earn_70 earn_71 earn_72 earn_73 earn_74
gen double earn_68 = ER30012
gen double earn_69 = ER30033
gen double earn_70 = ER30057
gen double earn_71 = ER30081
gen double earn_72 = ER30106
gen double earn_73 = ER30130
gen double earn_74 = ER30152

* 1974–1989 reference years (1975–1990 waves): taxable-income series as labor proxy
* If you prefer to start at 1975 instead of 1974, delete earn_74 assignment above or below.
capture drop earn_75 earn_76 earn_77 earn_78 earn_79 earn_80 earn_81 earn_82 ///
             earn_83 earn_84 earn_85 earn_86 earn_87 earn_88 earn_89
gen double earn_75 = ER30202
gen double earn_76 = ER30231
gen double earn_77 = ER30268
gen double earn_78 = ER30298
gen double earn_79 = ER30328
gen double earn_80 = ER30358
gen double earn_81 = ER30386
gen double earn_82 = ER30415
gen double earn_83 = ER30445
gen double earn_84 = ER30480
gen double earn_85 = ER30515
gen double earn_86 = ER30551
gen double earn_87 = ER30586
gen double earn_88 = ER30622
gen double earn_89 = ER30659

* 1990–1992 reference years (1991–1993 waves): labor income only
capture drop earn_90 earn_91 earn_92
gen double earn_90 = ER30705
gen double earn_91 = ER30750
gen double earn_92 = ER30821

* Clean earnings (biennial reference years)
capture drop earn_97 earn_99 earn_01 earn_03 earn_05
gen double earn_97 = ER33537N
gen double earn_99 = ER33628N
gen double earn_01 = ER33728N
gen double earn_03 = ER33826A
gen double earn_05 = ER33926A

* OFUM labor income (biennial reference years from 2006 onwards)
capture drop earn_06 earn_08 earn_10 earn_12 earn_14 earn_16 earn_18 earn_20 earn_22
gen double earn_06 = ER33938C
gen double earn_08 = ER34032A
gen double earn_10 = ER34144A
gen double earn_12 = ER34251A
gen double earn_14 = ER34401A
gen double earn_16 = ER34636
gen double earn_18 = ER34845
gen double earn_20 = ER35046
gen double earn_22 = ER35246

* -------------------------------------------------------------------
* 2) Load CPI and cache deflators in locals: defl_YYYY = 100/cpi(YYYY)
* -------------------------------------------------------------------
preserve
    use "$DTA\BLS_CPI_2023.dta", clear
    keep year cpi
    drop if missing(year) | missing(cpi)

    levelsof year, local(cpi_years)
    foreach y of local cpi_years {
        quietly summarize cpi if year==`y', meanonly
        local defl_`y' = 100 / r(mean)
    }
restore

* -------------------------------------------------------------------
* 3) Make nominal copies (earn_YY_nom) for comparison
* -------------------------------------------------------------------
ds earn_*, has(type numeric)
local earnvars `r(varlist)'

foreach v of local earnvars {
    if strpos("`v'", "_nom") continue
    capture drop `v'_nom
    gen double `v'_nom = `v'
    label var `v'_nom "Nominal (original) `v'"
}

* -------------------------------------------------------------------
* 4) Deflate earn_YY in place to 2023 USD
*     - YY >= 68  -> 19YY
*     - YY <  68  -> 20YY
* -------------------------------------------------------------------
foreach v of local earnvars {
    if strpos("`v'", "_nom") continue

    * Expect v name pattern: earn_YY
    local yy = substr("`v'", 6, 2)
    local yy_num = real("`yy'")

    local yr = cond(`yy_num' >= 68, 1900 + `yy_num', 2000 + `yy_num')

    if "`defl_`yr''" == "" {
        di as err "Missing CPI for year `yr' (needed for `v'). Skipping."
        continue
    }

    quietly replace `v' = `v' * `defl_`yr'' if !missing(`v')

    local oldlab : variable label `v'
    local addlab "deflated to 2023 USD"
    if "`oldlab'" == "" label var `v' "`addlab'"
    else               label var `v' "`oldlab' | `addlab'"
}

* -------------------------------------------------------------------
* Optional: keep only id + earnings series if this is a standalone earnings file
* -------------------------------------------------------------------
keep id earn_*
compress
save "$DTA\Earnings_clean.dta", replace

