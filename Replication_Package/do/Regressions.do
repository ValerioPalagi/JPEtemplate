clear all
set more off

do "../Setup.do"

use "$DTA\Reshaped.dta", clear

*INVERSE HYPERBOLIC SINE OR LOG PLUS ONE?	
twoway function asinh(x), ra(-40 40) || function log(x), ra(0.01 40) legend(pos(11) ring(0) col(1) order(1 "asinh" 2 "log")) ytitle(transformed) xtitle(argument) yla(, ang(h)) yli(0, lstyle(grid)) xli(0, lstyle(grid))


twoway ///
    (hist c_ihs_earn_avg_25_35, ///
        fcolor(red%40) ///
        lcolor(red) ///
        width(.25)) ///
    || (hist c_ln_earn_avg_25_35, ///
        fcolor(blue%30) ///
        lcolor(blue) ///
        width(.25)), ///
    legend(order(1 "IHS income" 2 "Log income (+1)") ///
           pos(12) ring(0) cols(1)) ///
    title("Distribution of Child Earnings (Ages 25–35)") ///
    subtitle("Inverse hyperbolic sine vs log transformation") ///
    xtitle("Transformed earnings") ///
    ytitle("Frequency") ///
    graphregion(color(white)) ///
    plotregion(color(white)) ///
    scheme(s1color)

*----------------------------------------------------------------------*
**********************   INCOME AND EARNINGS ***************************
*----------------------------------------------------------------------*

/* COMMENT
In our setting, parental earnings are measured with greater consistency than household income. Earnings correspond to individual labor market compensation and require minimal aggregation across components, whereas household income definitions vary substantially over time and often require combining taxable income, transfers, and asset income using different survey instruments. As a result, the earnings series involves fewer conceptual breaks and less reliance on constructed aggregates, making it a cleaner measure of long-run parental economic status in the PSID.
*/

************************************************************************
**************************NOT INTERACTED********************************
************************************************************************

****************
*** EARNINGS ***	
****************

* EARNINGS 25-30	
****************


ivregress 2sls c_ihs_earn_avg_28_32 (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30 c_ihs_fam* ///
i.c_birth i.m_birth i.c_state_birth, vce(robust)
capture drop samp
gen samp = e(sample)
estat firststage


*JUST MOTHERS RESTRICTED SAMPLE - 5% P=0.011
ivregress 2sls c_ihs_earn_avg_25_35 (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30 ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust)
estat firststage


*JUST MOTHERS - NON RESTRICTED SAMPLE - 5% P=0.02
ivregress 2sls c_ihs_earn_avg_25_35 (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30 ///
i.c_birth i.m_birth i.c_state_birth , vce(robust)
estat firststage

*JUST FE - 1% p=0.005
ivregress 2sls c_ihs_earn_avg_25_35 (m_age_birth = m_pill_at_18) ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust) 
estat firststage
*JUST FE - NON RESTRICTED SAMPLE - NOT SIGNIFICANT
ivregress 2sls c_ihs_earn_avg_25_35 (m_age_birth = m_pill_at_18) ///
i.c_birth i.m_birth i.c_state_birth, vce(robust) 
estat firststage

*RENRUN EVERITHING  WITHOUT HOURS WORKED TO GET BIT MORE SAMPLE

* ALL CONTROLS - 5% P = 0.034
ivregress 2sls c_ihs_earn_avg_25_35 (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30 c_ihs_fam* ///
i.c_birth i.m_birth i.c_state_birth, vce(robust)
capture drop samp
gen samp = e(sample)
estat firststage

*JUST MOTHERS RESTRICTED SAMPLE - 5% P=0.011
ivregress 2sls c_ihs_earn_avg_25_35 (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30  ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust)
estat firststage

*JUST FE - 5% p=0.033
ivregress 2sls c_ihs_earn_avg_25_35 (m_age_birth = m_pill_at_18) ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust) 
estat firststag

* EARNINGS 28-32	
****************
* ALL CONTROLS - 5% P = 0.023 n = 564
ivregress 2sls c_ihs_earn_avg_28_32 (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30 c_ihs_fam*  ///
i.c_birth i.m_birth i.c_state_birth, vce(robust)
capture drop samp
gen samp = e(sample)
estat firststage

*JUST MOTHERS RESTRICTED SAMPLE - 5% P=0.018
ivregress 2sls c_ihs_earn_avg_28_32  (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30  ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust)
estat firststage

*JUST MOTHERS - NON RESTRICTED SAMPLE - 5%=0.02
ivregress 2sls c_ihs_earn_avg_28_32  (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30 ///
i.c_birth i.m_birth i.c_state_birth , vce(robust)
estat firststage

*JUST FE - 5% p=0.018
ivregress 2sls c_ihs_earn_avg_28_32  (m_age_birth = m_pill_at_18) ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust) 
estat firststage
*JUST FE - NON RESTRICTED SAMPLE - NOT SIGNIFICANT
ivregress 2sls c_ihs_earn_avg_28_32  (m_age_birth = m_pill_at_18) ///
i.c_birth i.m_birth i.c_state_birth, vce(robust) 
estat firststage

*RENRUN EVERITHING  WITHOUT HOURS WORKED TO GET BIT MORE SAMPLE

* ALL CONTROLS - 5% P = 0.029
ivregress 2sls c_ihs_earn_avg_28_32  (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30 c_ihs_fam* ///
i.c_birth i.m_birth i.c_state_birth, vce(robust)
capture drop samp
gen samp = e(sample)
estat firststage

*JUST MOTHERS RESTRICTED SAMPLE - 5% P=0.05
ivregress 2sls c_ihs_earn_avg_28_32  (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30  ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust)
estat firststage

*JUST FE - 5% p=0.033
ivregress 2sls c_ihs_earn_avg_28_32  (m_age_birth = m_pill_at_18) ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust) 
estat firststage

* EARNINGS 29 - 31 
*******************
* ALL CONTROLS - 10% P = 0.10
ivregress 2sls c_ihs_earn_avg_29_31 (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30 c_ihs_fam* ///
i.c_birth i.m_birth i.c_state_birth, vce(robust)
capture drop samp
gen samp = e(sample)
estat firststage

*JUST MOTHERS RESTRICTED SAMPLE - 10% P=0.077
ivregress 2sls c_ihs_earn_avg_29_31  (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30  ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust)
estat firststage

*JUST MOTHERS - NON RESTRICTED SAMPLE - 10% P=0.062
ivregress 2sls c_ihs_earn_avg_29_31  (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30 ///
i.c_birth i.m_birth i.c_state_birth , vce(robust)
estat firststage

*JUST FE - 10% P = 0.087
ivregress 2sls c_ihs_earn_avg_29_31  (m_age_birth = m_pill_at_18) ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust) 
estat firststage
*JUST FE - NON RESTRICTED SAMPLE - NOT SIGNIFICANT
ivregress 2sls c_ihs_earn_avg_29_31  (m_age_birth = m_pill_at_18) ///
i.c_birth i.m_birth i.c_state_birth, vce(robust) 
estat firststage

*RENRUN EVERITHING  WITHOUT HOURS WORKED TO GET BIT MORE SAMPLE

* ALL CONTROLS - 5% P = 0.029
ivregress 2sls c_ihs_earn_avg_29_31  (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30 c_ihs_fam* ///
i.c_birth i.m_birth i.c_state_birth, vce(robust)
capture drop samp
gen samp = e(sample)
estat firststage

*JUST MOTHERS RESTRICTED SAMPLE - 10% P=0.097
ivregress 2sls c_ihs_earn_avg_29_31  (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30  ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust)
estat firststage

*JUST FE - 5% p=0.033
ivregress 2sls c_ihs_earn_avg_29_31  (m_age_birth = m_pill_at_18) ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust) 
estat firststage


* EARNINGS 30	- SUPER SMALL SAMPLE (N=350)
****************
* ALL CONTROLS - NOT SIGNIFICANT
ivregress 2sls c_ihs_earn_avg_30_30 (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30 c_ihs_fam*  ///
i.c_birth i.m_birth i.c_state_birth, vce(robust)
capture drop samp
gen samp = e(sample)
estat firststage

*JUST MOTHERS RESTRICTED SAMPLE - NOT SIGNIFICANT
ivregress 2sls c_ihs_earn_avg_30_30  (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30  ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust)
estat firststage

*JUST MOTHERS - NON RESTRICTED SAMPLE - NOT SIGNIFICANT
ivregress 2sls c_ihs_earn_avg_30_30  (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30 ///
i.c_birth i.m_birth i.c_state_birth , vce(robust)
estat firststage

*JUST FE - NOT SIGNIFICANT
ivregress 2sls c_ihs_earn_avg_30_30  (m_age_birth = m_pill_at_18) ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust) 
estat firststage
*JUST FE - NON RESTRICTED SAMPLE - NOT SIGNIFICANT
ivregress 2sls c_ihs_earn_avg_30_30  (m_age_birth = m_pill_at_18) ///
i.c_birth i.m_birth i.c_state_birth, vce(robust) 
estat firststage

*RENRUN EVERITHING  WITHOUT HOURS WORKED TO GET BIT MORE SAMPLE

* ALL CONTROLS - 5% P = 0.029 n = 350
ivregress 2sls c_ihs_earn_avg_30_30  (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30 c_ihs_fam* ///
i.c_birth i.m_birth i.c_state_birth, vce(robust)
capture drop samp
gen samp = e(sample)
estat firststage

* JUST MOTHERS - RESTRICTED SAMPLE - NOT SIGNIFICANT
ivregress 2sls c_ihs_earn_avg_30_30  (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30  ///
i.c_birth i.m_birth i.c_state_birth  if samp ==1, vce(robust)
estat firststage

* JUST FE - NOT SIGNIFICANT
ivregress 2sls c_ihs_earn_avg_30_30  (m_age_birth = m_pill_at_18) ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust) 
estat firststage


***************************************************************************

***************************************************************************

**********************
***NOT INSTRUMENTED***
**********************

* EARNINGS 25-30	
****************
* ALL CONTROLS
reg c_ihs_earn_avg_25_35 m_age_birth ///
m_ihs_earn* ib6.m_educ_30 c_ihs_fam*   ///
i.c_birth i.m_birth i.c_state_birth, vce(robust)
capture drop samp
gen samp = e(sample)


* ALL CONTROLS
reg m_age_birth  m_pill_at_18 i.c_birth i.m_birth i.c_state_birth, vce(robust)


*JUST MOTHERS RESTRICTED SAMPLE
reg c_ihs_earn_avg_25_35 m_age_birth ///
m_ihs_earn* ib6.m_educ_30 ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust)

*JUST MOTHERS - NON RESTRICTED SAMPLE
reg c_ihs_earn_avg_25_35 m_age_birth ///
m_ihs_earn* ib6.m_educ_30 ///
i.c_birth i.m_birth i.c_state_birth, vce(robust)

*JUST FE
reg c_ihs_earn_avg_25_35 m_age_birth ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust) 

*JUST FE - NON RESTRICTED SAMPLE
reg c_ihs_earn_avg_25_35 m_age_birth ///
i.c_birth i.m_birth i.c_state_birth, vce(robust) 

*RERUN EVERYTHING WITHOUT HOURS WORKED TO GET BIT MORE SAMPLE

* ALL CONTROLS
reg c_ihs_earn_avg_25_35 m_age_birth ///
m_ihs_earn* ib6.m_educ_30 c_ihs_fam* ///
i.c_birth i.m_birth i.c_state_birth, vce(robust)
capture drop samp
gen samp = e(sample)

*JUST MOTHERS RESTRICTED SAMPLE
reg c_ihs_earn_avg_25_35 m_age_birth ///
m_ihs_earn* ib6.m_educ_30  ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust)

*JUST FE
reg c_ihs_earn_avg_25_35 m_age_birth ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust) 

* EARNINGS 28-32	
****************
* ALL CONTROLS
reg c_ihs_earn_avg_28_32 m_age_birth ///
m_ihs_earn* ib6.m_educ_30 c_ihs_fam*   ///
i.c_birth i.m_birth i.c_state_birth, vce(robust)
capture drop samp
gen samp = e(sample)

*JUST MOTHERS RESTRICTED SAMPLE
reg c_ihs_earn_avg_28_32 m_age_birth ///
m_ihs_earn* ib6.m_educ_30  ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust)

*JUST MOTHERS - NON RESTRICTED SAMPLE
reg c_ihs_earn_avg_28_32 m_age_birth ///
m_ihs_earn* ib6.m_educ_30 ///
i.c_birth i.m_birth i.c_state_birth, vce(robust)

*JUST FE
reg c_ihs_earn_avg_28_32 m_age_birth ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust) 

*JUST FE - NON RESTRICTED SAMPLE
reg c_ihs_earn_avg_28_32 m_age_birth ///
i.c_birth i.m_birth i.c_state_birth, vce(robust) 

*RERUN EVERYTHING WITHOUT HOURS WORKED TO GET BIT MORE SAMPLE

* ALL CONTROLS
reg c_ihs_earn_avg_28_32 m_age_birth ///
m_ihs_earn* ib6.m_educ_30 c_ihs_fam* ///
i.c_birth i.m_birth i.c_state_birth, vce(robust)
capture drop samp
gen samp = e(sample)

*JUST MOTHERS RESTRICTED SAMPLE
reg c_ihs_earn_avg_28_32 m_age_birth ///
m_ihs_earn* ib6.m_educ_30  ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust)

*JUST FE
reg c_ihs_earn_avg_28_32 m_age_birth ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust) 

* EARNINGS 29 - 31 
*******************
* ALL CONTROLS
reg c_ihs_earn_avg_29_31 m_age_birth ///
m_ihs_earn* ib6.m_educ_30 c_ihs_fam*  ///
i.c_birth i.m_birth i.c_state_birth, vce(robust)
capture drop samp
gen samp = e(sample)

*JUST MOTHERS RESTRICTED SAMPLE
reg c_ihs_earn_avg_29_31 m_age_birth ///
m_ihs_earn* ib6.m_educ_30  ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust)

*JUST MOTHERS - NON RESTRICTED SAMPLE
reg c_ihs_earn_avg_29_31 m_age_birth ///
m_ihs_earn* ib6.m_educ_30 ///
i.c_birth i.m_birth i.c_state_birth, vce(robust)

*JUST FE
reg c_ihs_earn_avg_29_31 m_age_birth ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust) 

*JUST FE - NON RESTRICTED SAMPLE
reg c_ihs_earn_avg_29_31 m_age_birth ///
i.c_birth i.m_birth i.c_state_birth, vce(robust) 

*RERUN EVERYTHING WITHOUT HOURS WORKED TO GET BIT MORE SAMPLE

* ALL CONTROLS
reg c_ihs_earn_avg_29_31 m_age_birth ///
m_ihs_earn* ib6.m_educ_30 c_ihs_fam* ///
i.c_birth i.m_birth i.c_state_birth, vce(robust)
capture drop samp
gen samp = e(sample)

*JUST MOTHERS RESTRICTED SAMPLE
reg c_ihs_earn_avg_29_31 m_age_birth ///
m_ihs_earn* ib6.m_educ_30  ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust)

*JUST FE
reg c_ihs_earn_avg_29_31 m_age_birth ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust) 


* EARNINGS 30 - SUPER SMALL SAMPLE (N=350)
****************
* ALL CONTROLS
reg c_ihs_earn_avg_30_30 m_age_birth ///
m_ihs_earn* ib6.m_educ_30 c_ihs_fam*  ///
i.c_birth i.m_birth i.c_state_birth, vce(robust)
capture drop samp
gen samp = e(sample)

*JUST MOTHERS RESTRICTED SAMPLE
reg c_ihs_earn_avg_30_30 m_age_birth ///
m_ihs_earn* ib6.m_educ_30  ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust)

*JUST MOTHERS - NON RESTRICTED SAMPLE
reg c_ihs_earn_avg_30_30 m_age_birth ///
m_ihs_earn* ib6.m_educ_30 ///
i.c_birth i.m_birth i.c_state_birth, vce(robust)

*JUST FE
reg c_ihs_earn_avg_30_30 m_age_birth ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust) 

*JUST FE - NON RESTRICTED SAMPLE
reg c_ihs_earn_avg_30_30 m_age_birth ///
i.c_birth i.m_birth i.c_state_birth, vce(robust) 

*RERUN EVERYTHING WITHOUT HOURS WORKED TO GET BIT MORE SAMPLE

* ALL CONTROLS
reg c_ihs_earn_avg_30_30 m_age_birth ///
m_ihs_earn* ib6.m_educ_30 c_ihs_fam* ///
i.c_birth i.m_birth i.c_state_birth, vce(robust)
capture drop samp
gen samp = e(sample)

* JUST MOTHERS - RESTRICTED SAMPLE
reg c_ihs_earn_avg_30_30 m_age_birth ///
m_ihs_earn* ib6.m_educ_30  ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust)

* JUST FE
reg c_ihs_earn_avg_30_30 m_age_birth ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust)

***************************************************************************

***************************************************************************

**************
*** INCOME ***	NEVER SIGNIFICANT
**************

* INCOME 25-30	
****************
* ALL CONTROLS - NOT SIGNIFICANT
ivregress 2sls c_ihs_inc_avg_25_35 (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30 c_ihs_fam*  ///
i.c_birth i.m_birth i.c_state_birth, vce(robust)
capture drop samp
gen samp = e(sample)
estat firststage

*JUST MOTHERS RESTRICTED SAMPLE - NOT SIGNIFICANT
ivregress 2sls c_ihs_inc_avg_25_35 (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30  ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust)
estat firststage

*JUST MOTHERS - NON RESTRICTED SAMPLE - NOT SIGNIFICANT
ivregress 2sls c_ihs_inc_avg_25_35 (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30  ///
i.c_birth i.m_birth i.c_state_birth , vce(robust)
estat firststage

*JUST FE - NOT SIGNIFICANT
ivregress 2sls c_ihs_inc_avg_25_35 (m_age_birth = m_pill_at_18) ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust) 
estat firststage
*JUST FE - NON RESTRICTED SAMPLE - NOT SIGNIFICANT
ivregress 2sls c_ihs_inc_avg_25_35 (m_age_birth = m_pill_at_18) ///
i.c_birth i.m_birth i.c_state_birth, vce(robust) 
estat firststage

*RENRUN EVERITHING  WITHOUT HOURS WORKED TO GET BIT MORE SAMPLE

* ALL CONTROLS - NOT SIGNIFICANT
ivregress 2sls c_ihs_inc_avg_25_35 (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30 c_ihs_fam* ///
i.c_birth i.m_birth i.c_state_birth, vce(robust)
capture drop samp
gen samp = e(sample)
estat firststage

*JUST MOTHERS RESTRICTED SAMPLE - NOT SIGNIFICANT
ivregress 2sls c_ihs_inc_avg_25_35 (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30  ///
i.c_birth i.m_birth i.c_state_birth  if samp ==1, vce(robust)
estat firststage

*JUST FE - NOT SIGNIFICANT
ivregress 2sls c_ihs_inc_avg_25_35 (m_age_birth = m_pill_at_18) ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust) 
estat firststag

* INCOME  28-32	
****************
* ALL CONTROLS - NOT SIGNIFICANT
ivregress 2sls c_ihs_inc_avg_28_32 (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30 c_ihs_fam*  ///
i.c_birth i.m_birth i.c_state_birth, vce(robust)
capture drop samp
gen samp = e(sample)
estat firststage

*JUST MOTHERS RESTRICTED SAMPLE - NOT SIGNIFICANT
ivregress 2sls c_ihs_inc_avg_28_32  (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30 ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust)
estat firststage

*JUST MOTHERS - NON RESTRICTED SAMPLE - NOT SIGNIFICANT
ivregress 2sls c_ihs_inc_avg_28_32  (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30  ///
i.c_birth i.m_birth i.c_state_birth , vce(robust)
estat firststage

*JUST FE - NOT SIGNIFICANT
ivregress 2sls c_ihs_inc_avg_28_32  (m_age_birth = m_pill_at_18) ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust) 
estat firststage
*JUST FE - NON RESTRICTED SAMPLE - NOT SIGNIFICANT
ivregress 2sls c_ihs_inc_avg_28_32  (m_age_birth = m_pill_at_18) ///
i.c_birth i.m_birth i.c_state_birth, vce(robust) 
estat firststage

*RENRUN EVERITHING  WITHOUT HOURS WORKED TO GET BIT MORE SAMPLE

* ALL CONTROLS - NOT SIGNIFICANT
ivregress 2sls c_ihs_inc_avg_28_32  (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30 c_ihs_fam* ///
i.c_birth i.m_birth i.c_state_birth, vce(robust)
capture drop samp
gen samp = e(sample)
estat firststage

*JUST MOTHERS RESTRICTED SAMPLE - NOT SIGNIFICANT
ivregress 2sls c_ihs_inc_avg_28_32  (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30 ///
i.c_birth i.m_birth i.c_state_birth ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust)
estat firststage

*JUST FE - NOT SIGNIFICANT
ivregress 2sls c_ihs_inc_avg_28_32  (m_age_birth = m_pill_at_18) ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust) 
estat firststage

* INCOME 29 - 31 
*******************
* ALL CONTROLS - NOT SIGNIFICANT
ivregress 2sls c_ihs_inc_avg_29_31 (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30 c_ihs_fam*  ///
i.c_birth i.m_birth i.c_state_birth, vce(robust)
capture drop samp
gen samp = e(sample)
estat firststage

*JUST MOTHERS RESTRICTED SAMPLE - NOT SIGNIFICANT
ivregress 2sls c_ihs_inc_avg_29_31  (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30  ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust)
estat firststage

*JUST MOTHERS - NON RESTRICTED SAMPLE - NOT SIGNIFICANT
ivregress 2sls c_ihs_inc_avg_29_31  (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30  ///
i.c_birth i.m_birth i.c_state_birth, vce(robust)
estat firststage

*JUST FE - NOT SIGNIFICANT
ivregress 2sls c_ihs_inc_avg_29_31  (m_age_birth = m_pill_at_18) ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust) 
estat firststage
*JUST FE - NON RESTRICTED SAMPLE - NOT SIGNIFICANT
ivregress 2sls c_ihs_inc_avg_29_31  (m_age_birth = m_pill_at_18) ///
i.c_birth i.m_birth i.c_state_birth, vce(robust) 
estat firststage

*RENRUN EVERITHING  WITHOUT HOURS WORKED TO GET BIT MORE SAMPLE

* ALL CONTROLS - NOT SIGNIFICANT
ivregress 2sls c_ihs_inc_avg_29_31  (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30 c_ihs_fam* ///
i.c_birth i.m_birth i.c_state_birth, vce(robust)
capture drop samp
gen samp = e(sample)
estat firststage

*JUST MOTHERS RESTRICTED SAMPLE - NOT SIGNIFICANT
ivregress 2sls c_ihs_inc_avg_29_31  (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30 ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust)
estat firststage

*JUST FE - NOT SIGNIFICANT
ivregress 2sls c_ihs_inc_avg_29_31  (m_age_birth = m_pill_at_18) ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust) 
estat firststage


* INCOME 30	
****************
* ALL CONTROLS - NOT SIGNIFICANT
ivregress 2sls c_ihs_inc_avg_30_30 (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30 c_ihs_fam*  ///
i.c_birth i.m_birth i.c_state_birth, vce(robust)
capture drop samp
gen samp = e(sample)
estat firststage

*JUST MOTHERS RESTRICTED SAMPLE - NOT SIGNIFICANT
ivregress 2sls c_ihs_inc_avg_30_30  (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30 ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust)
estat firststage

*JUST MOTHERS - NON RESTRICTED SAMPLE - NOT SIGNIFICANT
ivregress 2sls c_ihs_inc_avg_30_30  (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30 ///
i.c_birth i.m_birth i.c_state_birth, vce(robust)
estat firststage

*JUST FE - NOT SIGNIFICANT
ivregress 2sls c_ihs_inc_avg_30_30  (m_age_birth = m_pill_at_18) ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust) 
estat firststage
*JUST FE - NON RESTRICTED SAMPLE - NOT SIGNIFICANT
ivregress 2sls c_ihs_inc_avg_30_30  (m_age_birth = m_pill_at_18) ///
i.c_birth i.m_birth i.c_state_birth, vce(robust) 
estat firststage

*RENRUN EVERITHING  WITHOUT HOURS WORKED TO GET BIT MORE SAMPLE

* ALL CONTROLS - 10% P = 0.078 n = 129
ivregress 2sls c_ihs_inc_avg_30_30  (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30 c_ihs_fam* ///
i.c_birth i.m_birth i.c_state_birth, vce(robust)
capture drop samp
gen samp = e(sample)
estat firststage

* JUST MOTHERS - RESTRICTED SAMPLE - 10% P=0.098 significance n = 129
ivregress 2sls c_ihs_inc_avg_30_30  (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30 ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust)
estat firststage

* JUST FE - NOT SIGNIFICANT
ivregress 2sls c_ihs_inc_avg_30_30  (m_age_birth = m_pill_at_18) ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust) 
estat firststag


*******************************
*** WAGE FROM FAMILY SURVEY ***	NEVER SIGNIFICANT
*******************************

* WAGE 25-30	
****************
* ALL CONTROLS - NOT SIGNIFICANT
ivregress 2sls c_ihs_wage_avg_25_35 (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30 c_ihs_fam*  ///
i.c_birth i.m_birth i.c_state_birth, vce(robust)
capture drop samp
gen samp = e(sample)
estat firststage

*JUST MOTHERS RESTRICTED SAMPLE - NOT SIGNIFICANT
ivregress 2sls c_ihs_wage_avg_25_35 (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30 ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust)
estat firststage

*JUST MOTHERS - NON RESTRICTED SAMPLE - NOT SIGNIFICANT
ivregress 2sls c_ihs_wage_avg_25_35 (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30 ///
i.c_birth i.m_birth i.c_state_birth , vce(robust)
estat firststage

*JUST FE - NOT SIGNIFICANT
ivregress 2sls c_ihs_wage_avg_25_35 (m_age_birth = m_pill_at_18) ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust) 
estat firststage
*JUST FE - NON RESTRICTED SAMPLE - NOT SIGNIFICANT
ivregress 2sls c_ihs_wage_avg_25_35 (m_age_birth = m_pill_at_18) ///
i.c_birth i.m_birth i.c_state_birth, vce(robust) 
estat firststage

*RENRUN EVERITHING  WITHOUT HOURS WORKED TO GET BIT MORE SAMPLE

* ALL CONTROLS - NOT SIGNIFICANT
ivregress 2sls c_ihs_wage_avg_25_35 (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30 c_ihs_fam* ///
i.c_birth i.m_birth i.c_state_birth, vce(robust)
capture drop samp
gen samp = e(sample)
estat firststage

*JUST MOTHERS RESTRICTED SAMPLE - NOT SIGNIFICANT
ivregress 2sls c_ihs_wage_avg_25_35 (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30  ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust)
estat firststage

*JUST FE - NOT SIGNIFICANT
ivregress 2sls c_ihs_wage_avg_25_35 (m_age_birth = m_pill_at_18) ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust) 
estat firststag

* EARNINGS 28-32	
****************
* ALL CONTROLS - NOT SIGNIFICANT
ivregress 2sls c_ihs_wage_avg_28_32 (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30 c_ihs_fam*  ///
i.c_birth i.m_birth i.c_state_birth, vce(robust)
capture drop samp
gen samp = e(sample)
estat firststage

*JUST MOTHERS RESTRICTED SAMPLE - NOT SIGNIFICANT
ivregress 2sls c_ihs_wage_avg_28_32  (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30  ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust)
estat firststage

*JUST MOTHERS - NON RESTRICTED SAMPLE - NOT SIGNIFICANT
ivregress 2sls c_ihs_wage_avg_28_32  (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30 ///
i.c_birth i.m_birth i.c_state_birth , vce(robust)
estat firststage

*JUST FE - NOT SIGNIFICANT
ivregress 2sls c_ihs_wage_avg_28_32  (m_age_birth = m_pill_at_18) ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust) 
estat firststage
*JUST FE - NON RESTRICTED SAMPLE - NOT SIGNIFICANT
ivregress 2sls c_ihs_wage_avg_28_32  (m_age_birth = m_pill_at_18) ///
i.c_birth i.m_birth i.c_state_birth, vce(robust) 
estat firststage

*RENRUN EVERITHING  WITHOUT HOURS WORKED TO GET BIT MORE SAMPLE

* ALL CONTROLS - NOT SIGNIFICANT
ivregress 2sls c_ihs_wage_avg_28_32  (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30 c_ihs_fam* ///
i.c_birth i.m_birth i.c_state_birth, vce(robust)
capture drop samp
gen samp = e(sample)
estat firststage

*JUST MOTHERS RESTRICTED SAMPLE - NOT SIGNIFICANT
ivregress 2sls c_ihs_wage_avg_28_32  (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30  ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust)
estat firststage

*JUST FE - NOT SIGNIFICANT
ivregress 2sls c_ihs_wage_avg_28_32  (m_age_birth = m_pill_at_18) ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust) 
estat firststage

* EARNINGS 29 - 31 n=199
*******************
* ALL CONTROLS - NOT SIGNIFICANT
ivregress 2sls c_ihs_wage_avg_29_31 (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30 c_ihs_fam*  ///
i.c_birth i.m_birth i.c_state_birth, vce(robust)
capture drop samp
gen samp = e(sample)
estat firststage

*JUST MOTHERS RESTRICTED SAMPLE - NOT SIGNIFICANT
ivregress 2sls c_ihs_wage_avg_29_31  (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30  ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust)
estat firststage

*JUST MOTHERS - NON RESTRICTED SAMPLE - NOT SIGNIFICANT
ivregress 2sls c_ihs_wage_avg_29_31  (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30 ///
i.c_birth i.m_birth i.c_state_birth , vce(robust)
estat firststage

*JUST FE - NOT SIGNIFICANT
ivregress 2sls c_ihs_wage_avg_29_31  (m_age_birth = m_pill_at_18) ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust) 
estat firststage
*JUST FE - NON RESTRICTED SAMPLE - NOT SIGNIFICANT
ivregress 2sls c_ihs_wage_avg_29_31  (m_age_birth = m_pill_at_18) ///
i.c_birth i.m_birth i.c_state_birth, vce(robust) 
estat firststage

*RENRUN EVERITHING  WITHOUT HOURS WORKED TO GET BIT MORE SAMPLE

* ALL CONTROLS - NOT SIGNIFICANT
ivregress 2sls c_ihs_wage_avg_29_31  (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30 c_ihs_fam* ///
i.c_birth i.m_birth i.c_state_birth, vce(robust)
capture drop samp
gen samp = e(sample)
estat firststage

*JUST MOTHERS RESTRICTED SAMPLE - NOT SIGNIFICANT
ivregress 2sls c_ihs_wage_avg_29_31  (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30  ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust)
estat firststage

*JUST FE - NOT SIGNIFICANT
ivregress 2sls c_ihs_wage_avg_29_31  (m_age_birth = m_pill_at_18) ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust) 
estat firststage


* EARNINGS 30	- SUPER SMALL SAMPLE (N=93)
****************
* ALL CONTROLS - 1% P=0 
ivregress 2sls c_ihs_wage_avg_30_30 (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30 c_ihs_fam*  ///
i.c_birth i.m_birth i.c_state_birth, vce(robust)
capture drop samp
gen samp = e(sample)
estat firststage

*JUST MOTHERS RESTRICTED SAMPLE - 5% P=0.034
ivregress 2sls c_ihs_wage_avg_30_30  (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30  ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust)
estat firststage

*JUST MOTHERS - NON RESTRICTED SAMPLE - NOT SIGNIFICANT
ivregress 2sls c_ihs_wage_avg_30_30  (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30 ///
i.c_birth i.m_birth i.c_state_birth , vce(robust)
estat firststage

*JUST FE - NOT SIGNIFICANT
ivregress 2sls c_ihs_wage_avg_30_30  (m_age_birth = m_pill_at_18) ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust) 
estat firststage
*JUST FE - NON RESTRICTED SAMPLE - NOT SIGNIFICANT
ivregress 2sls c_ihs_wage_avg_30_30  (m_age_birth = m_pill_at_18) ///
i.c_birth i.m_birth i.c_state_birth, vce(robust) 
estat firststage

*RENRUN EVERITHING  WITHOUT HOURS WORKED TO GET BIT MORE SAMPLE

* ALL CONTROLS - NOT SIGNIFICANT
ivregress 2sls c_ihs_wage_avg_30_30  (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30 c_ihs_fam* ///
i.c_birth i.m_birth i.c_state_birth, vce(robust)
capture drop samp
gen samp = e(sample)
estat firststage

* JUST MOTHERS - RESTRICTED SAMPLE - NOT SIGNIFICANT
ivregress 2sls c_ihs_wage_avg_30_30  (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_30  ///
i.c_birth i.m_birth i.c_state_birth  if samp ==1, vce(robust)
estat firststage

* JUST FE - NOT SIGNIFICANT
ivregress 2sls c_ihs_wage_avg_30_30  (m_age_birth = m_pill_at_18) ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust) 
estat firststage


***************************************************************************

***************************************************************************

************************************************************************
*****************************INTERACTED*********************************
************************************************************************

*NOTHING IS EVER SIGNIFICANT WITH EARINIGNS AT LEAST

capture drop m_agexPI 
capture drop m_agexI5 
capture drop m_agexI11 
capture drop m_agexI17 
capture drop m_pillxI5 
capture drop m_pillxI11 
capture drop m_pillxI17 
capture drop m_agexPI 
capture drop m_pillxPI

gen m_agexPI = m_age_birth*c_ihs_fam_inc_avg_0_17
gen m_pillxPI = m_pill_at_18*c_ihs_fam_inc_avg_0_17

gen m_agexI5 = m_age_birth*c_ihs_fam_inc_avg_0_5 
gen m_agexI11 = m_age_birth*c_ihs_fam_inc_avg_6_11 
gen m_agexI17 = m_age_birth*c_ihs_fam_inc_avg_12_17

gen m_pillxI5 = m_pill_at_18*c_ihs_fam_inc_avg_0_5 
gen m_pillxI11 = m_pill_at_18*c_ihs_fam_inc_avg_6_11 
gen m_pillxI17 = m_pill_at_18*c_ihs_fam_inc_avg_12_17

**************
***EARNINGS***
**************

* EARNINGS 25-25
*****************
* ALL INTERACTIONS, ALL CONTROLS- NOT SIGNIFICANT
ivregress 2sls c_ihs_earn_avg_25_35 ///
(m_age_birth m_agexI5 m_agexI11 m_agexI17 m_agexPI = m_pill_at_18 m_pillxI5 m_pillxI11 m_pillxI17 m_pillxPI ) ///
c_ihs_fam_inc* ///
m_ihs_earn* ib6.m_educ_30, ///
vce(robust)
capture drop samp
gen samp = e(sample)

* ALL INTERACTIONS - MINIMAL CONTROLS -  NOT SIGNIFICANT
ivregress 2sls c_ihs_earn_avg_25_35 ///
(m_age_birth m_agexI5 m_agexI11 m_agexI17 m_agexPI = m_pill_at_18 m_pillxI5 m_pillxI11 m_pillxI17 m_pillxPI ) ///
c_ihs_fam_inc* ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust) 

* JUST PI - ALL CONTROLS - NOT SIGNIFICANT
ivregress 2sls c_ihs_earn_avg_25_35 (m_age_birth m_agexPI = m_pill_at_18  m_pillxPI ) ///
c_ihs_fam_inc_avg_0_5 c_ihs_fam_inc_avg_6_11 c_ihs_fam_inc_avg_12_17 ///
m_ihs_earn* ib6.m_educ_30, vce(robust)
capture drop samp
gen samp = e(sample)

* JUST PI - MINIMAL CONTROLS - NOT SIGNIFICANT
ivregress 2sls c_ihs_earn_avg_25_35 (m_age_birth m_agexPI = m_pill_at_18  m_pillxPI ) ///
c_ihs_fam_inc_avg_0_5 c_ihs_fam_inc_avg_6_11 c_ihs_fam_inc_avg_12_17 ///
m_ihs_earn* ib6.m_educ_30 if samp==1, vce(robust)

* SPECIFIC AGE - ALL CONTROLS - NOT SIGNIFICANT
ivregress 2sls c_ihs_earn_avg_25_35 (m_age_birth m_agexI5 m_agexI11 m_agexI17= m_pill_at_18 m_pillxI5 m_pillxI11 m_pillxI17) ///
c_ihs_fam_inc_avg_0_5 c_ihs_fam_inc_avg_6_11 c_ihs_fam_inc_avg_12_17 ///
m_ihs_earn* ib6.m_educ_30, vce(robust)
capture drop samp
gen samp = e(sample)

*SPECIFIC AGE - MINIMAL CONTROLS - SPECIFIC AGE INTERACTED - NOT SIGNIFICANT
ivregress 2sls c_ihs_earn_avg_25_35 (m_age_birth m_agexI5 m_agexI11 m_agexI17= m_pill_at_18 m_pillxI5 m_pillxI11 m_pillxI17) ///
c_ihs_fam_inc_avg_0_5 c_ihs_fam_inc_avg_6_11 c_ihs_fam_inc_avg_12_17 ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust)


* EARNINGS 28-34
*****************
* ALL INTERACTIONS, ALL CONTROLS- NOT SIGNIFICANT
ivregress 2sls c_ihs_earn_avg_28_32 ///
(m_age_birth m_agexI5 m_agexI11 m_agexI17 m_agexPI = m_pill_at_18 m_pillxI5 m_pillxI11 m_pillxI17 m_pillxPI ) ///
c_ihs_fam_inc* ///
m_ihs_earn* ib6.m_educ_30, ///
vce(robust)
capture drop samp
gen samp = e(sample)

* ALL INTERACTIONS - MINIMAL CONTROLS -  NOT SIGNIFICANT
ivregress 2sls c_ihs_earn_avg_28_32 ///
(m_age_birth m_agexI5 m_agexI11 m_agexI17 m_agexPI = m_pill_at_18 m_pillxI5 m_pillxI11 m_pillxI17 m_pillxPI ) ///
c_ihs_fam_inc* ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust) 

* JUST PI - ALL CONTROLS - NOT SIGNIFICANT
ivregress 2sls c_ihs_earn_avg_28_32 (m_age_birth m_agexPI = m_pill_at_18  m_pillxPI ) ///
c_ihs_fam_inc_avg_0_5 c_ihs_fam_inc_avg_6_11 c_ihs_fam_inc_avg_12_17 ///
m_ihs_earn* ib6.m_educ_30, vce(robust)
capture drop samp
gen samp = e(sample)

* JUST PI - MINIMAL CONTROLS - NOT SIGNIFICANT
ivregress 2sls c_ihs_earn_avg_28_32 (m_age_birth m_agexPI = m_pill_at_18  m_pillxPI ) ///
c_ihs_fam_inc_avg_0_5 c_ihs_fam_inc_avg_6_11 c_ihs_fam_inc_avg_12_17 ///
m_ihs_earn* ib6.m_educ_30 if samp==1, vce(robust)

* SPECIFIC AGE - ALL CONTROLS - NOT SIGNIFICANT
ivregress 2sls c_ihs_earn_avg_28_32 (m_age_birth m_agexI5 m_agexI11 m_agexI17= m_pill_at_18 m_pillxI5 m_pillxI11 m_pillxI17) ///
c_ihs_fam_inc_avg_0_5 c_ihs_fam_inc_avg_6_11 c_ihs_fam_inc_avg_12_17 ///
m_ihs_earn* ib6.m_educ_30, vce(robust)
capture drop samp
gen samp = e(sample)

*SPECIFIC AGE - MINIMAL CONTROLS - SPECIFIC AGE INTERACTED - NOT SIGNIFICANT
ivregress 2sls c_ihs_earn_avg_28_32 (m_age_birth m_agexI5 m_agexI11 m_agexI17= m_pill_at_18 m_pillxI5 m_pillxI11 m_pillxI17) ///
c_ihs_fam_inc_avg_0_5 c_ihs_fam_inc_avg_6_11 c_ihs_fam_inc_avg_12_17 ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust)  

*----------------------------------------------------------------------*
***************************  EDUCATION  ********************************
*----------------------------------------------------------------------*

*********************
***EDUC AT 30, IHS***
*********************

*Education - ALL CONTROLS - 10% Significance (P=0.056)
*************************
ivregress 2sls c_educ_30 (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_40 c_ihs_fam* ///  ///
i.c_birth i.m_birth i.c_state_birth, vce(robust)
capture drop samp
gen samp = e(sample)
estat firststage

*Education - JUST MOTHER CONTROLS 
*********************************
* SAMPLE RESTRICTION - 5% p =0.043
ivregress 2sls c_educ_30 (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_40  ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust)
estat firststage
* NO SAMPLE RESTRICTION - NON SIGNIFICANT 
ivregress 2sls c_educ_40 (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_40 ///
i.c_birth i.m_birth i.c_state_birth , vce(robust)
estat firststage

*Education - JUST FE  
*********************
* SAMPLE RESTRICTION - 5% Significance (P=0.013)
ivregress 2sls c_educ_30 (m_age_birth = m_pill_at_18) ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust) 
estat firststage

* NO SAMPLE RESTRICTION - NON SIGNIFICANT
ivregress 2sls c_educ_30 (m_age_birth = m_pill_at_18) ///
i.c_birth i.m_birth i.c_state_birth, vce(robust) 
estat firststage

*********************
***EDUC AT 40, IHS***
*********************

*Education - ALL CONTROLS - 10% Significance (P=0.069)
*************************
ivregress 2sls c_educ_40 (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_40 c_ihs_fam* ///  ///
i.c_birth i.m_birth i.c_state_birth, vce(robust)
capture drop samp
gen samp = e(sample)
estat firststage

*Education - JUST MOTHER CONTROLS 
*********************************
* SAMPLE RESTRICTION - 10% p =0.069
ivregress 2sls c_educ_40 (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_40  ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust)
estat firststage
* NO SAMPLE RESTRICTION - NON SIGNIFICANT 
ivregress 2sls c_educ_40 (m_age_birth = m_pill_at_18) ///
m_ihs_earn* ib6.m_educ_40 ///
i.c_birth i.m_birth i.c_state_birth , vce(robust)
estat firststage

*Education - JUST FE  
*********************
* SAMPLE RESTRICTION - 5% Significance (P=0.031)
ivregress 2sls c_educ_40 (m_age_birth = m_pill_at_18) ///
i.c_birth i.m_birth i.c_state_birth if samp ==1, vce(robust) 
estat firststage

* NO SAMPLE RESTRICTION - NON SIGNIFICANT
ivregress 2sls c_educ_40 (m_age_birth = m_pill_at_18) ///
i.c_birth i.m_birth i.c_state_birth, vce(robust) 
estat firststage




/*
****************************
***MOTHER EDUC AT 30, LOGS**
****************************

*Education - ALL CONTROLS - Not significant
ivregress 2sls c_educ_30 (m_age_birth = m_pill_at_18) ///
m_ln_earn* ib6.m_educ_30 c_ln_fam* ///  ///
i.c_birth i.m_birth i.c_state_birth, vce(robust)
capture drop samp
gen samp = e(sample)
estat firststage

*Education - JUST MOTHER CONTROLS - Not significant & WEAK INSTRUMENT
ivregress 2sls c_educ_30 (m_age_birth = m_pill_at_18) ///
m_ln_earn* ib6.m_educ_30 if samp ==1, vce(robust)
estat firststage

*Education - JUST MOTHER CONTROLS - NO SAMPLE RESTRICTION - Not significant & moderately weak instrument
ivregress 2sls c_educ_30 (m_age_birth = m_pill_at_18) ///
m_ln_earn* ib6.m_educ_30, vce(robust)
estat firststage

****************************
***MOTHER EDUC AT 40, LOGS***
****************************

*Education - ALL CONTROLS - 10% Significance (P=0.056)
*************************
ivregress 2sls c_educ_30 (m_age_birth = m_pill_at_18) ///
m_ln_earn* ib6.m_educ_40 c_ln_fam* ///  ///
i.c_birth i.m_birth i.c_state_birth, vce(robust)
capture drop samp
gen samp = e(sample)
estat firststage

*Education - JUST MOTHER CONTROLS 
*********************************
* SAMPLE RESTRICTION - NON SIGNIFICANT & WEAK INSTRUMENT
ivregress 2sls c_educ_30 (m_age_birth = m_pill_at_18) ///
m_ln_earn* ib6.m_educ_40 if samp ==1, vce(robust)
estat firststage
* NO SAMPLE RESTRICTION - NON SIGNIFICANT & WEAK INSTRUMENT
ivregress 2sls c_educ_30 (m_age_birth = m_pill_at_18) ///
m_ln_earn* ib6.m_educ_40, vce(robust)
estat firststage

********************************************************************************
* 1. SETUP & DIRECTORY
********************************************************************************

* Label the main regressor for the rows
label variable m_age_birth "Mother's Age at Birth"

* Control Group Globals
local mother_ctrls "m_ihs_earn* ib6.m_educ_30"
local all_ctrls    "`mother_ctrls' c_ihs_fam* "
local no_hw_ctrls  "`mother_ctrls' c_ihs_fam*"
local fe_ctrls     "i.c_birth i.m_birth i.c_state_birth"

local depvars "c_ihs_earn_avg_25_35 c_ihs_earn_avg_28_32 c_ihs_earn_avg_29_31 c_ihs_earn_avg_30_30"

* Nice titles for the columns
local mtitles `" "Avg child earnings 25-35 y.o." "Avg child earnings 28-32 y.o." "Avg child earnings 29-31 y.o." "Avg child earnings 30 y.o." "'

* Updated estopts with mtitle
local estopts `" keep(m_age_birth) cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N f_stat, labels("N" "First-stage F") fmt(0 3)) booktabs label nodepvars mtitle(`mtitles') collabels(" ") "'

********************************************************************************
* 2. LOOP TO PRODUCE THE 3 TABLES
********************************************************************************
forvalues t = 1/3 {
    eststo clear
    
    if `t' == 1 local tabtitle "Main Regressions (Restricted Sample)"
    if `t' == 2 local tabtitle "Main Regressions (Whole Sample)"
    if `t' == 3 local tabtitle "Regressions Excluding Hours Worked"

    foreach v of local depvars {
        
        * --- Panel A ---
        if `t' == 1 ivregress 2sls `v' (m_age_birth = m_pill_at_18) `all_ctrls' `fe_ctrls', vce(robust)
        if `t' == 2 ivregress 2sls `v' (m_age_birth = m_pill_at_18) `all_ctrls' `fe_ctrls', vce(robust)
        if `t' == 3 ivregress 2sls `v' (m_age_birth = m_pill_at_18) `no_hw_ctrls' `fe_ctrls', vce(robust)
        
        if `t' != 2 {
            capture drop samp
            gen samp = e(sample)
        }
        estat firststage
        matrix f_mat = r(singleresults)
        estadd scalar f_stat = f_mat[1,4]
        eststo `v'_A
        
        * --- Panel B ---
        local if_cond ""
        if `t' != 2 local if_cond "if samp==1"
        ivregress 2sls `v' (m_age_birth = m_pill_at_18) `mother_ctrls' `fe_ctrls' `if_cond', vce(robust)
        estat firststage
        matrix f_mat = r(singleresults)
        estadd scalar f_stat = f_mat[1,4]
        eststo `v'_B
        
        * --- Panel C ---
        ivregress 2sls `v' (m_age_birth = m_pill_at_18) `fe_ctrls' `if_cond', vce(robust)
        estat firststage
        matrix f_mat = r(singleresults)
        estadd scalar f_stat = f_mat[1,4]
        eststo `v'_C
    }

    * --- EXPORTING WITH CLEAN HEADERS AND RESIZEBOX ---

    * Panel A
    esttab *_A using "$\Table`t'.tex", replace `estopts' ///
        prehead("\begin{table}[ht!]\centering\caption{`tabtitle'}\resizebox{\textwidth}{!}{\begin{tabular}{l*{4}{c}}\toprule") ///
        posthead("\hline \\ \multicolumn{5}{l}{\textbf{Panel A: All Controls}} \\") ///
        postfoot("\bottomrule \end{tabular}}")

    * Panel B
    esttab *_B using "$$TABLES\Table`t'.tex", append `estopts' ///
        prehead("\vspace{0.2cm} \resizebox{\textwidth}{!}{\begin{tabular}{l*{4}{c}}\toprule") ///
        posthead("\hline \\ \multicolumn{5}{l}{\textbf{Panel B: Mother Controls}} \\") ///
        postfoot("\bottomrule \end{tabular}}")

    * Panel C
    esttab *_C using "$$TABLES\Table`t'.tex", append `estopts' ///
        prehead("\vspace{0.2cm} \resizebox{\textwidth}{!}{\begin{tabular}{l*{4}{c}}\toprule") ///
        posthead("\hline \\ \multicolumn{5}{l}{\textbf{Panel C: Fixed Effects Only}} \\") ///
        postfoot("\bottomrule \end{tabular}}\end{table}")
}

*/
********************************************************************************
* 1. SETUP & DIRECTORY
********************************************************************************
global path "$TEX\Tables"

* Label main variables for professional look
label variable m_age_birth "Mother's Age at Birth"
label variable m_educ_30   "Mother's Education (Age 30)"

* Control Group Globals
local mother_ctrls "m_ihs_earn* ib6.m_educ_30"
local all_ctrls    "`mother_ctrls' c_ihs_fam* "
local no_hw_ctrls  "`mother_ctrls' c_ihs_fam*"
local fe_ctrls     "i.c_birth i.m_birth i.c_state_birth"

local depvars "c_ihs_earn_avg_25_35 c_ihs_earn_avg_28_32 c_ihs_earn_avg_29_31 c_ihs_earn_avg_30_30"

* Column Headers
local mtitles `" "Avg child earnings 25-35 y.o." "Avg child earnings 28-32 y.o." "Avg child earnings 29-31 y.o." "Avg child earnings 30 y.o." "'

* NEW: Drop the FE and Constant, but keep all other covariates
* We use wildcards (*.c_birth etc.) to catch all factor levels of the FEs
local estopts `" drop(*.c_birth *.m_birth *.c_state_birth _cons) cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N f_stat, labels("N" "First-stage F") fmt(0 3)) booktabs label nodepvars mtitle(`mtitles') collabels("b/se", span) "'

********************************************************************************
* 2. LOOP TO PRODUCE THE 3 COVARIATE TABLES
********************************************************************************
forvalues t = 1/3 {
    eststo clear
    
    * Titles and Logic for the 3 Versions
    if `t' == 1 local tabtitle "Main Regressions (Restricted Sample) - Covariates"
    if `t' == 2 local tabtitle "Main Regressions (Whole Sample) - Covariates"
    if `t' == 3 local tabtitle "Regressions Excluding Hours Worked - Covariates"

    foreach v of local depvars {
        
        * --- Panel A ---
        if `t' == 1 ivregress 2sls `v' (m_age_birth = m_pill_at_18) `all_ctrls' `fe_ctrls', vce(robust)
        if `t' == 2 ivregress 2sls `v' (m_age_birth = m_pill_at_18) `all_ctrls' `fe_ctrls', vce(robust)
        if `t' == 3 ivregress 2sls `v' (m_age_birth = m_pill_at_18) `no_hw_ctrls' `fe_ctrls', vce(robust)
        
        if `t' != 2 {
            capture drop samp
            gen samp = e(sample)
        }
        estat firststage
        matrix f_mat = r(singleresults)
        estadd scalar f_stat = f_mat[1,4]
        eststo `v'_A
        
        * --- Panel B ---
        local if_cond ""
        if `t' != 2 local if_cond "if samp==1"
        ivregress 2sls `v' (m_age_birth = m_pill_at_18) `mother_ctrls' `fe_ctrls' `if_cond', vce(robust)
        estat firststage
        matrix f_mat = r(singleresults)
        estadd scalar f_stat = f_mat[1,4]
        eststo `v'_B
        
        * --- Panel C ---
        ivregress 2sls `v' (m_age_birth = m_pill_at_18) `fe_ctrls' `if_cond', vce(robust)
        estat firststage
        matrix f_mat = r(singleresults)
        estadd scalar f_stat = f_mat[1,4]
        eststo `v'_C
    }

    * --- EXPORTING WITH NEW FILENAMES AND COVARIATES ---

    * Panel A
    esttab *_A using "$TABLES\Table`t'_covariates.tex", replace `estopts' ///
        prehead("\begin{table}[ht!]\centering\caption{`tabtitle'}\resizebox{\textwidth}{!}{\begin{tabular}{l*{4}{c}}\toprule") ///
        posthead("\hline \\ \multicolumn{5}{l}{\textbf{Panel A: All Controls}} \\") ///
        postfoot("\bottomrule \end{tabular}}")

    * Panel B
    esttab *_B using "$TABLES\Table`t'_covariates.tex", append `estopts' ///
        prehead("\vspace{0.2cm} \resizebox{\textwidth}{!}{\begin{tabular}{l*{4}{c}}\toprule") ///
        posthead("\hline \\ \multicolumn{5}{l}{\textbf{Panel B: Mother Controls}} \\") ///
        postfoot("\bottomrule \end{tabular}}")

    * Panel C
    esttab *_C using "$TABLES\Table`t'_covariates.tex", append `estopts' ///
        prehead("\vspace{0.2cm} \resizebox{\textwidth}{!}{\begin{tabular}{l*{4}{c}}\toprule") ///
        posthead("\hline \\ \multicolumn{5}{l}{\textbf{Panel C: Fixed Effects Only}} \\") ///
        postfoot("\bottomrule \end{tabular}}\end{table}")
}



**EDUCATIONNNNNNNNNNNNN
********************************************************************************
* 1. SETUP & DIRECTORY
********************************************************************************
global path "$TEX\Tables"

* Label the main regressor for the rows
label variable m_age_birth "Mother's Age at Birth"

* Updated Control Group Globals for Education Regressions
* Note: using m_educ_40 as per your provided snippet
local mother_ctrls "m_ihs_earn* ib6.m_educ_40"
local all_ctrls    "`mother_ctrls' c_ihs_fam*"
local fe_ctrls     "i.c_birth i.m_birth i.c_state_birth"

* Two dependent variables
local depvars "c_educ_30 c_educ_40"

* Column titles for 2 columns
local mtitles `" "Child education at 30" "Child education at 40" "'

* estopts adjusted for 2 columns (tabular{l*{2}{c}} and multicolumn{3}{l})
local estopts `" keep(m_age_birth) cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N f_stat, labels("N" "First-stage F") fmt(0 3)) booktabs label nodepvars mtitle(`mtitles') collabels(" ") "'

********************************************************************************
* 2. LOOP TO PRODUCE 2 TABLES (RESTRICTED AND WHOLE SAMPLE)
********************************************************************************
forvalues t = 1/2 {
    eststo clear
    
    if `t' == 1 local tabtitle "Education Regressions (Restricted Sample)"
    if `t' == 2 local tabtitle "Education Regressions (Whole Sample)"

    foreach v of local depvars {
        
        * --- Panel A: All Controls ---
        ivregress 2sls `v' (m_age_birth = m_pill_at_18) `all_ctrls' `fe_ctrls', vce(robust)
        
        if `t' == 1 {
            capture drop samp
            gen samp = e(sample)
        }
        
        estat firststage
        matrix f_mat = r(singleresults)
        estadd scalar f_stat = f_mat[1,4]
        eststo `v'_A
        
        * --- Panel B: Just Mother Controls ---
        local if_cond ""
        if `t' == 1 local if_cond "if samp==1"
        
        ivregress 2sls `v' (m_age_birth = m_pill_at_18) `mother_ctrls' `fe_ctrls' `if_cond', vce(robust)
        estat firststage
        matrix f_mat = r(singleresults)
        estadd scalar f_stat = f_mat[1,4]
        eststo `v'_B
        
        * --- Panel C: Just FE ---
        ivregress 2sls `v' (m_age_birth = m_pill_at_18) `fe_ctrls' `if_cond', vce(robust)
        estat firststage
        matrix f_mat = r(singleresults)
        estadd scalar f_stat = f_mat[1,4]
        eststo `v'_C
    }

    * --- EXPORTING WITH 2 COLUMNS AND RESIZEBOX ---

    * Panel A: replace, starts the float. multicolumn is 3 (1 label + 2 cols)
    esttab *_A using "$TABLES\Table_Educ_`t'.tex", replace `estopts' ///
        prehead("\begin{table}[ht!]\centering\caption{`tabtitle'}\resizebox{\textwidth}{!}{\begin{tabular}{l*{2}{c}}\toprule") ///
        posthead("\hline \\ \multicolumn{3}{l}{\textbf{Panel A: All Controls}} \\") ///
        postfoot("\bottomrule \end{tabular}}")

    * Panel B: append
    esttab *_B using "$TABLES\Table_Educ_`t'.tex", append `estopts' ///
        prehead("\vspace{0.2cm} \resizebox{\textwidth}{!}{\begin{tabular}{l*{2}{c}}\toprule") ///
        posthead("\hline \\ \multicolumn{3}{l}{\textbf{Panel B: Mother Controls}} \\") ///
        postfoot("\bottomrule \end{tabular}}")

    * Panel C: append, closes the float
    esttab *_C using "$TABLES\Table_Educ_`t'.tex", append `estopts' ///
        prehead("\vspace{0.2cm} \resizebox{\textwidth}{!}{\begin{tabular}{l*{2}{c}}\toprule") ///
        posthead("\hline \\ \multicolumn{3}{l}{\textbf{Panel C: Fixed Effects Only}} \\") ///
        postfoot("\bottomrule \end{tabular}}\end{table}")
}
