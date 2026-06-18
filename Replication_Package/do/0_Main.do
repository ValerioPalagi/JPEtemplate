clear all

do "../Setup.do"

do "$DO\Main_data_reader"

do "$DO\Gid_pro_reader.do"

do "$DO\Gid_pro_cleaner.do"

do "$DO\RebaseCPI.do"

do "$DO\Income_Reader.do"

do "$DO\Earnings_reader.do"

do "$DO\Gen_Income_Earnings.do"

do "$DO\Merging_GID_main.do"

do "$DO\Data_cleaning.do"

do "$DO\Regressions"