clear all

do "../Setup.do"
#delimit ;

**************************************************************************
   Label           : fim15606_gidpro_BA_2_BAL
   Rows            : 90947
   Columns         : 8
   ASCII File Date : January 14, 2026
*************************************************************************;


infix 
         G1ID68                1 - 4    
         G1PN                  5 - 7    
   str   G1TYPE                8 - 9    
         G1POS                10 - 10   
         G2ID68               11 - 14   
         G2PN                 15 - 17   
   str   G2TYPE               18 - 19   
         G2POS                20 - 20   
using "$ASCII\Gid_pro_ASCII.txt", clear
;
label variable  G1ID68               "1968 INTERVIEW NUMBER OF G1" ;
label variable  G1PN                 "PERSON NUMBER OF G1" ;
label variable  G1TYPE               "PARENTAL TYPE OF G1" ;
label variable  G1POS                "GENERATION POSITION OF G1" ;
label variable  G2ID68               "1968 INTERVIEW NUMBER OF G2" ;
label variable  G2PN                 "PERSON NUMBER OF G2" ;
label variable  G2TYPE               "PARENTAL TYPE OF G2" ;
label variable  G2POS                "GENERATION POSITION OF G2" ;

save "$DTA\Gid_pro_raw.dta", replace;
