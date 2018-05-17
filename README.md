# dofiles
Replication package for "The Effects of Benefit Underreporting on Estimates of Poverty in the United States"

The documentation below provides guidance on adjusting for benefit underreporting in the CPS ASEC and for replicating the
analyses in this paper. The replication packages contains five steps:

    I.	Accessing TRIM
    II.	Accessing the CPS ASEC
    III.	Downloading TRIM Files
    IV.	Merging TRIM to the CPS ASEC
    V.	Re-Estimating Poverty Rates
      a.	Supplemental Poverty Measure
       b.	50% of Median Income

I.	Accessing TRIM
Researchers can request access the Urban Institute’s TRIM3 simulation model upon registration via online form. 
The link to register is: http://trim3.urban.org/Registration/. There is no charge to access the baseline data, 
but users must share their intended use of the TRIM data. Registration is necessary to download the TRIM data on imputed SNAP, 
TANF, and SSI benefit receipt.  

  More information on TRIM: http://trim3.urban.org 
  More information on the Urban Institute: http://urban.org 

  II.	Accessing the CPS ASEC
There are multiple ways to access the Annual Social and Economic Supplement of the Current Population Survey 
(CPS ASEC, also referred to as the March CPS files). Two options include:
      U.S. Census Bureau: https://thedataweb.rm.census.gov/ftp/cps_ftp.html 
      IPUMS CPS (after registration): https://cps.ipums.org/cps/

The replication package presented here uses the 2014 – 2016 CPS ASEC files (referring to reference years 2013 to 2015) from 
IPUMS CPS. Researchers using the Census files should be aware that some of the variable labels in the dofiles presented below
may need to be converted from IPUMS to Census labeling schema (i.e. changing hseq to h_seq). 

To compute Supplemental Poverty Measure (SPM) rates, I utilize historical SPM data from the Center on Poverty & Social Policy 
at Columbia University. Researchers can access the public-use files after registering at:
https://www.povertycenter.columbia.edu/historical-spm-data-reg. 
Download the 2016 “Stata 12 DTA” file (CPS ASEC 2016 referring to reference year 2015) and save locally. 
The code provided in Dofile 2 (below) will merge the file into the CPS ASEC and allow for re-estimation of SPM poverty 
rates with TRIM-adjusted benefits. 

  III.	Download TRIM Files 
After registering for and receiving access to TRIM, you can then download the files needed to correct for benefit 
underreporting in the CPS ASEC. To do so, visit the TRIM website (trim3.urban.org) and select the TRIM3 Navigator 
link using your login credentials. On the next page, select “Microdata” or “Microdata Examiner.”

This paper uses the 2013 to 2015 microdata files, but TRIM files are available for the 1993 March CPS onward 
(if using the older files, however, take note that TRIM imputation procedures may have changed over time). Here, I detail 
how to download and merge the 2015 TRIM file into the CPS ASEC, but the same procedure applies for other years.

Select the 2015 (2016 CPS ASEC) input data set. You will then download, at a minimum, the following files, selecting the “extract data” link next to each. The sub-bullets below each file name indicate the variables within each extract that you should select prior to download:
    •	Alien2015 Person
        o	HOUSEHOLDID
        o	FAMILYID
       o	PERSONID
       o	CpsPersonID
       o	LineNumber
        o	PersonWeight
    •	Alien2015 Household
        o	HOUSEHOLDID
        o	AlienHouseholdSplit
       o	HouseholdWeight
       o	HighIncomeClone
        o	OldIdentifier
    •	Alien2015 Family
        o	HOUSEHOLDID
        o	FAMILYID
       o	CpsIdentifier
    •	SN2015_
        o	HOUSEHOLDID
       o	PERSONID
       o	ANNUALBENEFITSRECEIVED
    •	SSI2015_
       o	HOUSEHOLDID
        o	PERSONID
       o	ANNUALSSIBENEFITSRECEIVED
    •	TF2015_
       o	HOUSEHOLDID
        o	PERSONID
       o	ANNUALBENEFITSRECEIVED

Under “formatting options”, select Stata 2.1 format (if using Stata) and extract each set of data. 
Follow the link on the proceeding page to begin the download. Save each file into a local folder. 
If downloading files from multiple years, I recommend saving them into separate folders with the respective 
year as the folder title. Recommended file names for the 2015 downloads (useful if following the merge instructions 
in the dofiles below) are, respectively: input2015p, input2015h, input2015f, snap2015, ssi2015, tanf2015.

IV.	Merging TRIM into CPS ASEC

After downloading the TRIM files, you can now merge them into the CPS ASEC. This process consists of three steps: 
the first is to merge the separate TRIM files into one unified file. The second step is to merge the unified TRIM file into the CPS. 
The third step then treats the adjusted CPS ASEC file to account for the presence of high-income clones and alien replicates within the
TRIM data.

See this repository to download the first dofile.


V.	Re-Estimating Poverty Rates
The Stata dofile below contains the code to estimate poverty rates with the TRIM-adjusted benefits and to replicate each of 
the analyses in this paper. 

See this repository to download the second dofile.
