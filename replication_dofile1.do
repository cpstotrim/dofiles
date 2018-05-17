
	/*
	
	Replication Package: The Effect of Benefit Underreporting on Estimates of 
	Poverty in the United States
	
	
	Dofile 1 of 2: Merging TRIM into CPS ASEC
	
	After downloading the TRIM files, you can now merge them into the CPS ASEC. 
	This process consists of three steps: the first is to merge the separate 
	TRIM files into one unified file. The second step is to merge the unified 
	TRIM file into the CPS. The third step then treats the adjusted CPS ASEC 
	file to account for the presence of high-income clones and alien replicates 
	within the TRIM data.


	
	*************
	** Step One: 
	**************
	
		 Read the instructions in Appendix II of the text for accessing and 
		 downloading the TRIM files. Once you have the files save on your 
		 computer, proceed to step two.
		
		From the TRIM website, you will then download, at a minimum, the following 
		files, selecting the “extract data” link next to each. The sub-bullets 
		below each file name indicate the variables within each extract that you 
		should select prior to download:
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
			Under “formatting options”, select Stata 2.1 format (if using Stata) 
			and extract each set of data. Follow the link on the proceeding page 
			to begin the download. Save each file into a local folder. If downloading 
			files from multiple years, I recommend saving them into separate folders 
			with the respective year as the folder title. Recommended file names 
			for the 2015 downloads (useful if following the merge instructions in 
			the dofile) are, respectively:
			input2015p, input2015h, input2015f, snap2015, ssi2015, tanf2015.

		*/				
	
	***********************************
	** Step Two: Merging TRIM Files into Single File
	***********************************	
		
		* Set file path to folder where TRIM downloads are saved
			
			global pathtrim "C:\Users\...\TRIM3\merges"
			
				* Within this folder, create subfolders for each year of TRIM
				* data you plan to merge (i.e. 2013, 2014, 2015). Move the TRIM
				* files into the folder 
			
		* Set file path to folder where IPUM CPS (or Census download) is saved
			
			global pathcps "C:\Users\...\CPS\"
			
				* If using IPUMS CPS: Within this folder, include the IPUMS dofile (i.e. cps_0001.do) 
				* that opens and labels your CPS file for the respective year.
				* This does not apply if you are not using IPUMS or if you have 
				* a CPS ASEC file already created and simply wish to merge the 
				* TRIM imputations into that. 
				
		* Set file path to folder where you would like to merged TRIM file to be save:
			
			global pathsave "C:\Users\...\TRIM3\complete"
		
		* Change to specify which year(s) of TRIM data you plan to merge into the CPS
			
			global yr "2015"
	
	foreach yr in $yr {	

		qui cd $pathtrim
		qui cd `yr' // change if folder name of respective year's TRIM files is labeled differently
		qui use input`yr'p.dta, clear 
			* this refers to the Alien Person file for the given year. If you
			* have labeled the file differently, be sure to adjust this.
		
		set more off
		merge m:1 househol using input`yr'h.dta // refers to Alien Household file
			drop _merge
		merge m:1 househol familyid using input`yr'f.dta // refers to Alien Family file
			drop _merge
			cap ren cpsident cpsfamid

		merge m:1 househol personid using ssi`yr'.dta // refers to SSI file
			drop _merge
			describe annuals1 // note: be sure this refers to benefit receipt at the person level
			ren annuals1 ssitrim_p 
			
		merge m:1 househol personid using snap`yr'.dta // refers to SNAP file
			drop _merge	
			describe annualbe // note: be sure this refers to benefit receipt at the person level
			ren annualbe snaptrim 
			
		merge m:1 househol personid using tanf`yr'.dta // refers to TANF file
			drop _merge
			ren annualbe tanftrim_p
			cap drop annual
			
		capture drop year
		capture gen year = `yr'
		ren oldid hseq
		ren linenum lineno
		sort hseq lineno
		save trimcorrections`yr'.dta, replace
	}
		
	************************************************
	** Step Three: Merging TRIM Files into CPS ASEC
	************************************************	
		
		
		******************************************
		* OPTION A: IF MERGING TRIM INTO EXISTING CPS FILE
		******************************************
			
			* Be sure that you have a variable labeled "year" that refers
			* to reference years (ex: 2016 CPS ASEC should have "year" variable
			* labeled as 2015 for all individuals in sample).
			
			clear
			qui cd $pathcps
			use [INSERT NAME OF EXISTING CPS FILE].dta
			
			foreach yr in $yr {	

					qui cd $pathtrim
					qui cd `yr' // change if folder name of respective year's TRIM files is labeled differently
				
					sort year hseq lineno
					merge m:m year hseq lineno using trimcorrections`yr'.dta, update
				
					qui cd $pathsave
					
					drop _merge
				
				}
				
				save trim_ipumsMERGED_`yr'.dta, replace
		
		
		********************************
		* OPTION B: IF USING A NEW IPUMS CPS FILE:
		********************************
		
			qui cd $cpspath
			clear
			
			qui do cps_00071.do // change name of IPUMS dofile 
		
			* Year variable will always refer to reference year. SYear = Survey year.
				ren year syear
				gen year = syear
				replace year = year - 1
		
				foreach yr in $yr {	

					qui cd $pathtrim
					qui cd `yr' // change if folder name of respective year's TRIM files is labeled differently
				
					sort year hseq lineno
					merge m:m year hseq lineno using trimcorrections`yr'.dta, update
				
					qui cd $pathsave
					
					drop _merge
				
				}
				
				save trim_ipumsMERGED_`yr'.dta, replace
		
		
		
	****************************************************************
	** Step Four: Preparing CPS ASEC & Taking Replicates Into Account
	****************************************************************		
		
		/* For this paper, I remove TRIM's alien replicates and high-income clones.
		Leaving them in does not affect the findings within the paper, but will
		make this replication package more difficult to follow. The code below
		removes the replicates that the TRIM imputations have added and addresses
		the weighting of the benefits accordingly. See the documentation on the
		TRIM website for more information about the high-income clones and alien replicates.
		*/
		
		qui cd $pathsave
		 use trim_ipumsMERGED_`yr'.dta, clear 
			* this should refer to CPS ASEC file with TRIM merged in, as created above.
			
		* Merge Imputed Benefits into Single Household from Replicates
		
			sort year hseq lineno
			foreach x in snaptrim tanftrim_p housesubtrim_h ssitrim_p  {
				qui gen orig_`x' = `x'
				gen wtben`x' = (`x'*personwe)
				bysort year hseq lineno: egen weightsum`x' = sum(personwe)
				bysort year hseq lineno: egen weightbensum`x' = sum(wtben`x')	
				bysort year hseq lineno: gen `x'2 = weightbensum`x'/weightsum`x'
				qui drop weightbensum*  weightsum* wtben*
				qui replace `x' = `x'2
				qui drop `x'2
			
			sum `x' [w=wtsupp] if highinc < 2 & alien < 2 & year==2015
			sum orig_`x' [w=personwe] if year==2015
				** These should show identical results for each benefit if done properly.
		
		}	
				
		** Drop replicates:
			
			cap replace alien = 0 if alien==.
			cap replace highinco = 0 if highinco ==.
			
			cap drop if alien > 1 & alien!=.
			cap drop if highinco > 1 & alien!=.
			
			
		save trim_ipumsMERGED_`yr'.dta, replace 	
			