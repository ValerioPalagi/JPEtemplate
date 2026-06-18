/* Uncomment this to run as standalone do file
do "../Setup.do"

use "$DTA\parent_child_PSID.dta", clear
*/

#delimit cr
set more off

*----------------------------------------------------------------
* ASSIGN ROLE-RELATED VARIABLES AND RESPONDENT RELATED VARIABLES
*----------------------------------------------------------------

*Race is respondent-based, income and hours worked are assigned for wife and head

/*recode relationship to head to match '68 values (the additional complexity introduced in later years is not needed), Values are:
 
1 Head in 1982; 1981 Head who was mover-out nonresponse by the
time of the 1982 interview
2 Wife in 1982; 1981 Wife who was mover-out nonresponse by the
time of the 1982 interview
3 Son or daughter; includes stepchildren and adopted children
4 Brother or sister of Head
5 Father or mother of Head
6 Grandchild or great-grandchild
7 Other relative; includes in-laws
8 Nonrelative
9 Husband of Head (i.e., Wife was Head of FU)
0 Inappropriate
*/
foreach var of varlist p_ER30401 p_ER30431 p_ER30465 p_ER30500 p_ER30537 ///
    p_ER30572 p_ER30608 p_ER30644 p_ER30691 p_ER30735 p_ER30808 p_ER33103 ///
    p_ER33203 p_ER33303 p_ER33403 p_ER33503 p_ER33603 p_ER33703 p_ER33803 ///
    p_ER33903 p_ER34003 p_ER34103 p_ER34203 p_ER34303 p_ER34503 p_ER34703 ///
    p_ER34903 p_ER35103 ///
	c_ER30401 c_ER30431 c_ER30465 c_ER30500 c_ER30537 ///
    c_ER30572 c_ER30608 c_ER30644 c_ER30691 c_ER30735 c_ER30808 c_ER33103 ///
    c_ER33203 c_ER33303 c_ER33403 c_ER33503 c_ER33603 c_ER33703 c_ER33803 ///
    c_ER33903 c_ER34003 c_ER34103 c_ER34203 c_ER34303 c_ER34503 c_ER34703 ///
    c_ER34903 c_ER35103{
    
    replace `var' = floor(`var' / 10)
}


****************************************************
* 0) DICTIONARY (GLOBALS): years, mappings, codes
****************************************************

* Role codes (relationship-to-head)
global REL_HEAD 1
global REL_WIFE 2
global REL_HUSBAND_OF_HEAD 9

* Years to process (two digits)
global yy_list "68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 99 01 03 05 07 09 11 13 15 17 19 21 23"

* Relationship to head
global rel_68 ER30003
global rel_69 ER30022
global rel_70 ER30045
global rel_71 ER30069
global rel_72 ER30093
global rel_73 ER30119
global rel_74 ER30140
global rel_75 ER30162
global rel_76 ER30190
global rel_77 ER30219
global rel_78 ER30248
global rel_79 ER30285
global rel_80 ER30315
global rel_81 ER30345
global rel_82 ER30375
global rel_83 ER30401
global rel_84 ER30431
global rel_85 ER30465
global rel_86 ER30500
global rel_87 ER30537
global rel_88 ER30572
global rel_89 ER30608
global rel_90 ER30644
global rel_91 ER30691
global rel_92 ER30735
global rel_93 ER30808
global rel_94 ER33103
global rel_95 ER33203
global rel_96 ER33303
global rel_97 ER33403
global rel_99 ER33503
global rel_01 ER33603
global rel_03 ER33703
global rel_05 ER33803
global rel_07 ER33903
global rel_09 ER34003
global rel_11 ER34103
global rel_13 ER34203
global rel_15 ER34303
global rel_17 ER34503
global rel_19 ER34703
global rel_21 ER34903
global rel_23 ER35103

* Head labor income (annual)
global hin_68 V74
global hin_69 V514
global hin_70 V1196
global hin_71 V1897
global hin_72 V2498
global hin_73 V3051
global hin_74 V3463
global hin_75 V3863
global hin_76 V5031
global hin_77 V5627
global hin_78 V6174
global hin_79 V6767
global hin_80 V7413
global hin_81 V8066
global hin_82 V8690
global hin_83 V9376
global hin_84 V11023
global hin_85 V12372
global hin_86 V13624
global hin_87 V14671
global hin_88 V16145
global hin_89 V17534
global hin_90 V18878
global hin_91 V20178
global hin_92 V21484
global hin_93 V23323
global hin_94 ER4140
global hin_95 ER6980
global hin_96 ER9231
global hin_97 ER12080
global hin_99 ER16463
global hin_01 ER20443
global hin_03 ER24116
global hin_05 ER27931
global hin_07 ER40921
global hin_09 ER46829
global hin_11 ER52237
global hin_13 ER58038
global hin_15 ER65216
global hin_17 ER71293
global hin_19 ER77315
global hin_21 ER81642
global hin_23 ER85496

* Wife labor income (annual)
global win_68 V75
global win_69 V516
global win_70 V1198
global win_71 V1899
global win_72 V2500
global win_73 V3053
global win_74 V3465
global win_75 V3865
global win_76 V4379
global win_77 V5289
global win_78 V5788
global win_79 V6398
global win_80 V6988
global win_81 V7580
global win_82 V8273
global win_83 V8881
global win_84 V10263
global win_85 V11404
global win_86 V12803
global win_87 V13905
global win_88 V14920
global win_89 V16420
global win_90 V17836
global win_91 V19136
global win_92 V20436
global win_93 V23324
global win_94 ER2576
global win_95 ER5575
global win_96 ER7671
global win_97 ER10574
global win_99 ER13730
global win_01 ER17799
global win_03 ER21403
global win_05 ER25400
global win_07 ER36405
global win_09 ER42434
global win_11 ER47752
global win_13 ER53458
global win_15 ER60473
global win_17 ER66486
global win_19 ER72488
global win_21 ER78530
global win_23 ER82518

* Hours worked: head
global hhr_68 V47
global hhr_69 V465
global hhr_70 V1138
global hhr_71 V1839
global hhr_72 V2439
global hhr_73 V3027
global hhr_74 V3423
global hhr_75 V3823
global hhr_76 V4332
global hhr_77 V5232
global hhr_78 V5731
global hhr_79 V6336
global hhr_80 V6934
global hhr_81 V7530
global hhr_82 V8228
global hhr_83 V8830
global hhr_84 V10037
global hhr_85 V11146
global hhr_86 V12545
global hhr_87 V13745
global hhr_88 V14835
global hhr_89 V16335
global hhr_90 V17744
global hhr_91 V19044
global hhr_92 V20344
global hhr_93 V21634
global hhr_94 ER4096
global hhr_95 ER6936
global hhr_96 ER9187
global hhr_97 ER12174
global hhr_99 ER16471
global hhr_01 ER20399
global hhr_03 ER24080
global hhr_05 ER27886
global hhr_07 ER40876
global hhr_09 ER46767
global hhr_11 ER52175
global hhr_13 ER57976
global hhr_15 ER65156
global hhr_17 ER71233
global hhr_19 ER77255
global hhr_21 ER81582
global hhr_23 ER85436

* Hours worked: wife
global whr_68 V53
global whr_69 V475
global whr_70 V1148
global whr_71 V1849
global whr_72 V2449
global whr_73 V3035
global whr_74 V3431
global whr_75 V3831
global whr_76 V4344
global whr_77 V5244
global whr_78 V5743
global whr_79 V6348
global whr_80 V6946
global whr_81 V7540
global whr_82 V8238
global whr_83 V8840
global whr_84 V10131
global whr_85 V11258
global whr_86 V12657
global whr_87 V13809
global whr_88 V14865
global whr_89 V16365
global whr_90 V17774
global whr_91 V19074
global whr_92 V20374
global whr_93 V21670
global whr_94 ER4107
global whr_95 ER6947
global whr_96 ER9198
global whr_97 ER12185
global whr_99 ER16482
global whr_01 ER20410
global whr_03 ER24091
global whr_05 ER27897
global whr_07 ER40887
global whr_09 ER46788
global whr_11 ER52196
global whr_13 ER57997
global whr_15 ER65177
global whr_17 ER71254
global whr_19 ER77276
global whr_21 ER81603
global whr_23 ER85457

* Respondent and respondent race
global resp_68 V180
global resp_69 V800
global resp_70 V1489
global resp_71 V2201
global resp_72 V2827
global resp_73 V3248
global resp_74 V3670
global resp_75 V4149
global resp_76 V4700
global resp_77 V5618
global resp_78 V6165
global resp_79 V6764
global resp_80 V7397
global resp_81 V8049
global resp_82 V8673
global resp_83 V9359
global resp_84 V11006
global resp_85 V12354
global resp_86 V13607
global resp_87 V14654
global resp_88 V16128
global resp_89 V17525
global resp_90 V18856
global resp_91 V20156
global resp_92 V21462
global resp_93 V23318
global resp_94 ER2013
global resp_95 ER5012
global resp_96 ER7012
global resp_97 ER10015
global resp_99 ER13016
global resp_01 ER17019
global resp_03 ER24073
global resp_05 ER27879
global resp_07 ER40869
global resp_09 ER46697
global resp_11 ER52097
global resp_13 ER57901
global resp_15 ER65081
global resp_17 ER71164
global resp_19 ER77186
global resp_21 ER81522
global resp_23 ER85379

global race_68 V181
global race_69 V801
global race_70 V1490
global race_71 V2202
global race_72 V2828
global race_73 V3300
global race_74 V3720
global race_75 V4204
global race_76 V5096
global race_77 V5662
global race_78 V6209
global race_79 V6802
global race_80 V7447
global race_81 V8099
global race_82 V8723
global race_83 V9408
global race_84 V11055
global race_85 V11938
global race_86 V13565
global race_87 V14612
global race_88 V16086
global race_89 V17483
global race_90 V18814
global race_91 V20114
global race_92 V21420
global race_93 V23276
global race_94 ER3944
global race_95 ER6814
global race_96 ER9060
global race_97 ER11848
global race_99 ER15928
global race_01 ER19989
global race_03 ER23426
global race_05 ER27393
global race_07 ER40565
global race_09 ER46543
global race_11 ER51904
global race_13 ER57659
global race_15 ER64810
global race_17 ER70882
global race_19 ER76897
global race_21 ER81144
global race_23 ER85121

****************************************************
* 1) PROGRAM: wage/hours + respondent race
****************************************************
capture program drop make_rolevars
program define make_rolevars
    version 16.0

    * -----------------------
    * Wage and hours by role
    * -----------------------
    foreach pref in p c {

        foreach yy in $yy_list {

            local REL  "${rel_`yy'}"
            local HIN  "${hin_`yy'}"
            local WIN  "${win_`yy'}"
            local HHR  "${hhr_`yy'}"
            local WHR  "${whr_`yy'}"

            capture confirm variable `pref'_`REL'
            if _rc continue

            * Wage
            capture drop `pref'_wage_`yy'
            gen double `pref'_wage_`yy' = .

            capture confirm variable `pref'_`HIN'
            if !_rc replace `pref'_wage_`yy' = `pref'_`HIN' if `pref'_`REL' == $REL_HEAD

            capture confirm variable `pref'_`WIN'
            if !_rc replace `pref'_wage_`yy' = `pref'_`WIN' if inlist(`pref'_`REL', $REL_WIFE, $REL_HUSBAND_OF_HEAD)

            * Work hours
            capture drop `pref'_work_hours_`yy'
            gen double `pref'_work_hours_`yy' = .

            capture confirm variable `pref'_`HHR'
            if !_rc replace `pref'_work_hours_`yy' = `pref'_`HHR' if `pref'_`REL' == $REL_HEAD

            capture confirm variable `pref'_`WHR'
            if !_rc replace `pref'_work_hours_`yy' = `pref'_`WHR' if inlist(`pref'_`REL', $REL_WIFE, $REL_HUSBAND_OF_HEAD)
        }
    }

    * -----------------------
    * Respondent race (one variable)
    * Your respondent coding:
    * 1 Head
    * 2 Wife, responding for self (Wife considered Head)
    * 3 Wife, responding for husband
    * 7 Other
    * 9 NA
    * -----------------------
    foreach pref in p c {
        capture drop `pref'_race
        gen double `pref'_race = .

        foreach yy in $yy_list {

            local RELV  "${rel_`yy'}"
            local RESPV "${resp_`yy'}"
            local RACEV "${race_`yy'}"

            capture confirm variable `pref'_`RELV'
            if _rc continue
            capture confirm variable `pref'_`RESPV'
            if _rc continue
            capture confirm variable `pref'_`RACEV'
            if _rc continue

            * respondent=1 -> Head respondent
            replace `pref'_race = `pref'_`RACEV' if missing(`pref'_race) ///
                & `pref'_`RESPV' == 1 ///
                & `pref'_`RELV' == $REL_HEAD

            * respondent=2 -> Wife respondent for self (wife is head)
            replace `pref'_race = `pref'_`RACEV' if missing(`pref'_race) ///
                & `pref'_`RESPV' == 2 ///
                & `pref'_`RELV' == $REL_WIFE

            * respondent=3 -> Wife respondent for husband (still wife respondent)
            replace `pref'_race = `pref'_`RACEV' if missing(`pref'_race) ///
                & `pref'_`RESPV' == 3 ///
                & `pref'_`RELV' == $REL_WIFE

            * respondent=7 other -> cannot safely assign to head or wife row
            * respondent=9 NA -> skip
        }
    }
end

****************************************************
* 2) RUN
****************************************************
make_rolevars

*-------------
* 3) CHECKS
/*-------------
describe p_wage_68 p_work_hours_68 c_wage_68 c_work_hours_68 p_race c_race
summ p_wage_68 p_work_hours_68 p_race
*/