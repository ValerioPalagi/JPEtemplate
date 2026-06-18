clear all

do "../Setup.do"

use "$DTA\Gid_pro_raw.dta", clear

*Remove non Parents
drop if G1TYPE == "I"

*Generate ids
gen p_id = G1ID68*1000+G1PN

gen c_id = G2ID68*1000+G2PN


save "$DTA\Gid_pro_clean.dta", replace

/*Tests and comments
isid p_id //No unique id because it might be you have more than one parent use this as master and merge m:1
*isid c_id //No unique id children because they are included at least twice for mother and father, again merge m:1 to solve the issue

bysort c_id: gen n_cid = _N
summarize n_cid, meanonly
display "Max repetitions of c_id = " r(max)
br if n_cid == r(max)

//Max # c_id is 3 and all of those are adopted children for whome you have AM AF and biological M 
/*