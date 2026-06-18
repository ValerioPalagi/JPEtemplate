# Replication Package for: Intergenerational Mobility and maternal age at birth
## May 2026
Replication package structure, the main folder includes:

- README.txt

- Setup.do to be modified by the data editor, sets directory and global paths

- "ASCII" contains the raw data files, namely:
	- BLS_CPI_6823.txt
	- Earnings_ASCII.txt
	- Gid_pro_ASCII.txt
	- Income_ASCII.txt
	- Main_data_ASCII.txt

- "do" contains several dofiles used in the analyisis, namely:
	- 0_Main.do
	- Data_cleaning.do
	- Deflate.do
	- Earnings_reader.do
	- Gen_Income_Earnings.do
	- Gid_pro_cleaner.do
	- Gid_pro_reader.do
	- Income_reader.do
	- Main_data_reader.do
	- Merging_GID_main.do
	- Pill_IV.do
	- RebaseCPI.do
	- Regressions.do
	- Role_related_variables.do

- "dta" will contain produced data files

- "tex" will contain produced images (in "tex/Images") and tables (in "tex/Tables")

## Author

Luca Emanuele Marcianò - PhD Student, Collegio Carlo Alberto

## Instructions to replicators

- Open the file "Setup.do", replace "YOUR_DIR" with the directory in which such file (and the rest of the package sits)

- Open the folder "root/do"

- Run "root/do/0_Main.do" [it is important to run it after haveing opened the folder!]


##Images and Tables
"Pill_IV.do" creates the tables displayed in "root/tex/Images":

- "pill_by_state.png" line: 360

"Regressions.do" creates the tables displayed in "root/tex/Tables":

- "Table1_covariates.tex", "Table2_covariates.tex", "Table3_covariates.tex" lines: 1248-1308

- "Table_Educ_1.tex" and "Table_Educ_2.tex" lines:1339-1397

## Data availability and provenance statements

### Statement about rights
The author(s) of the manuscript have legitimate access to and permission to use the data used in this manuscript.

### Summary of availability
All data available in this replication package *are* publicly available.

### Details on each data source
Panel Study of Income Dynamics, public use dataset. Produced and distributed by the Survey Research Center, Institute for Social Research, University of Michigan, Ann Arbor, MI (2025).

U.S. Bureau of Labor Statistics. (2025). CPI-U.

## Runtime & System Info
2.25 mins 

On Lenovo ThinkPad T480s, specs:

- OS		Microsoft Windows 11 Pro

- Processor	Intel(R) Core(TM) i7-8650U CPU @ 1.90GHz, 2112 Mhz, 4 core, 8 processori logici

- RAM 		24,0 GB


## Software
Run on vanilla stata 19.0, no further packages required.




