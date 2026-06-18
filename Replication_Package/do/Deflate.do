/********************************************************************
Deflate PSID income variables using your CPI (rebased to 2023=100)

Assumes you already created and saved:
    "$DTA\BLS_CPI_2023.dta"
with variables:
    year   (numeric, e.g. 1968, 1969, ..., 2023)
    cpi    (numeric index, 2023=100)

Deflation rule:
    real_2023 = nominal_year * (100 / cpi_year)

********************************************************************/

preserve
do "$DO\RebaseCPI.do"
restore

* -------------------------
* 0) Load CPI and cache factors in locals
* -------------------------
preserve
    use "$DTA\BLS_CPI_2023.dta", clear

    confirm variable year
    confirm variable cpi

    keep year cpi
    drop if missing(year) | missing(cpi)

    * store deflators: defl_YYYY = 100/cpi(YYYY)
    levelsof year, local(cpi_years)
    foreach y of local cpi_years {
        quietly summarize cpi if year==`y', meanonly
        local defl_`y' = 100 / r(mean)
    }
restore

* -------------------------
* 1) Helper: deflate list of year:var pairs
* -------------------------
capture program drop deflate_pairs_2023
program define deflate_pairs_2023
    args pairs

    foreach pair of local pairs {
        local yr  = real(substr("`pair'", 1, strpos("`pair'", ":")-1))
        local vn  = substr("`pair'", strpos("`pair'", ":")+1, .)

        capture confirm variable `vn'
        if _rc continue

        capture confirm local defl_`yr'
        if _rc {
            di as err "Missing CPI for year `yr' (needed for `vn'). Skipping."
            continue
        }

        quietly replace `vn' = `vn' * `defl_`yr'' if !missing(`vn')

        local oldlab : variable label `vn'
        if "`oldlab'"=="" label var `vn' "Deflated to 2023 USD (CPI-U annual, 2023=100)"
        else              label var `vn' "`oldlab' | deflated to 2023 USD"
    }
end

* -------------------------
* 2) Head labor income (annual) — deflate in place
* -------------------------
local head_pairs "1968:V74 1969:V514 1970:V1196 1971:V1897 1972:V2498 1973:V3051 1974:V3463 1975:V3863 1976:V5031 1977:V5627 1978:V6174 1979:V6767 1980:V7413 1981:V8066 1982:V8690 1983:V9376 1984:V11023 1985:V12372 1986:V13624 1987:V14671 1988:V16145 1989:V17534 1990:V18878 1991:V20178 1992:V21484 1993:V23323 1994:ER4140 1995:ER6980 1996:ER9231 1997:ER12080 1999:ER16463 2001:ER20443 2003:ER24116 2005:ER27931 2007:ER40921 2009:ER46829 2011:ER52237 2013:ER58038 2015:ER65216 2017:ER71293 2019:ER77315 2021:ER81642 2023:ER85496"

 
deflate_pairs_2023 "`head_pairs'"

* -------------------------
* 3) Wife labor income (annual) — deflate in place
* -------------------------
local wife_pairs "1968:V75  1969:V516 1970:V1198 1971:V1899 1972:V2500 1973:V3053 1974:V3465 1975:V3865 1976:V4379 1977:V5289 1978:V5788 1979:V6398 1980:V6988 1981:V7580 1982:V8273 1983:V8881 1984:V10263 1985:V11404 1986:V12803 1987:V13905 1988:V14920 1989:V16420 1990:V17836 1991:V19136 1992:V20436 1993:V23324 1994:ER2576 1995:ER5575 1996:ER7671 1997:ER10574 1999:ER13730 2001:ER17799 2003:ER21403 2005:ER25400 2007:ER36405 2009:ER42434 2011:ER47752 2013:ER53458 2015:ER60473 2017:ER66486 2019:ER72488 2021:ER78530 2023:ER82518"
 
deflate_pairs_2023 "`wife_pairs'"

* -------------------------
* 4) Family income vars — deflate in place
* -------------------------
local fam_pairs "1968:V81  1969:V1514 1970:V2226 1971:V2852 1972:V3256 1973:V3676 1974:V4154 1975:V5029 1976:V5626 1977:V6173 1978:V6766 1979:V7412 1980:V8065 1981:V8689 1982:V9375 1983:V11022 1984:V12371 1985:V13623 1986:V14670 1987:V16144 1988:V17533 1989:V18875 1990:V20175 1991:V21481 1992:V23322 1993:ER4153 1994:ER6993 1995:ER9244 1996:ER12079 1997:ER16462 2000:ER20456 2002:ER24099 2004:ER28037 2006:ER41027 2008:ER46935 2010:ER52343 2012:ER58152 2014:ER65349 2016:ER71426 2018:ER77448 2020:ER81775 2022:ER85629"
 
deflate_pairs_2023 "`fam_pairs'"

di as txt "Done: listed variables deflated to 2023 USD using CPI (2023=100)." 

