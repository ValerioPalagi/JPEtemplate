clear all

do "..\Setup.do"

*-----------------
* DEFLATE 100=2023
*-----------------
* 1. Load your data
import delimited "$ASCII\BLS_CPI_6823.txt", clear //dataset for CPI from bls, dowloaded on 19/01/2026 from https://data.bls.gov/timeseries/CUUR0000SA0

* 2. Store the 2023 CPI value as a scalar for calculation
* This ensures we use exactly 304.702 from your list
summarize annual if year == 2023
scalar base_2023 = r(mean)

* 3. Calculate the Adjustment Factor
* Formula: (CPI 2023) / (CPI Year X)
* This factor converts nominal dollars from any year into 2023 purchasing power
gen adj_factor = base_2023 / annual

* 4. Rebase the Index to 2023 = 100
* Formula: (Annual Value / 2023 Value) * 100
gen cpi_rebased_2023 = (annual / base_2023) * 100

drop annual adj_factor

rename cpi_rebased_2023 cpi

save "$DTA\BLS_CPI_2023.dta", replace