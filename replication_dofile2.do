
	
	/*
	
	Replication Package: The Effect of Benefit Underreporting on Estimates of 
	Poverty in the United States
	
	Dofile 2 of 2: Estimating Poverty Rates with TRIM-Adjusted Benefits
	
	*/
	
	* Set file path to folder where you saved the TRIM-adjusted CPS:
		
			global pathsave "C:\Users\...\TRIM3\complete"
	
		cd $pathsave
		use trim_ipumsMERGED_2015.dta, replace 
			* Change to match respective year. If you are including 
			* multiple years of data, you can append them at this point.
			* See Stata's append command.
		
		
		*************************
		* Step One: Prepare Data
		*************************
		
		* This may not be necessary if you merged the TRIM imputations
		* into an existing version of the CPS ASEC.
		
	
			* Change any missing variables for TANF
			replace ssit = 0 if ssit ==.
			
			* Persons in household
			qui by year hseq, sort: egen perhh = max(pernum) 
			qui lab var perhh "Number of persons in household"
			qui notes perhh: CPS: derived: a-lineno lineno ph-seq ppseqnum
			
			* Children in household 
			qui by year hseq, sort: egen u14hh = total(age<14)
			qui lab var u14hh "Number of children in household"
			
			* CPI Variables
		
			gen cpiu = .			
				replace cpiu = 	0.164	if year ==	1970
				replace cpiu = 	0.171	if year ==	1971
				replace cpiu = 	0.177	if year ==	1972
				replace cpiu = 	0.188	if year ==	1973
				replace cpiu = 	0.208	if year ==	1974
				replace cpiu = 	0.227	if year ==	1975
				replace cpiu = 	0.240	if year ==	1976
				replace cpiu = 	0.256	if year ==	1977
				replace cpiu = 	0.275	if year ==	1978
				replace cpiu = 	0.307	if year ==	1979
				replace cpiu = 	0.348	if year ==	1980
				replace cpiu = 	0.384	if year ==	1981
				replace cpiu = 	0.408	if year ==	1982
				replace cpiu = 	0.421	if year ==	1983
				replace cpiu = 	0.439	if year ==	1984
				replace cpiu = 	0.455	if year ==	1985
				replace cpiu = 	0.463	if year ==	1986
				replace cpiu = 	0.480	if year ==	1987
				replace cpiu = 	0.500	if year ==	1988
				replace cpiu = 	0.524	if year ==	1989
				replace cpiu = 	0.552	if year ==	1990
				replace cpiu = 	0.575	if year ==	1991
				replace cpiu = 	0.593	if year ==	1992
				replace cpiu = 	0.610	if year ==	1993
				replace cpiu = 	0.626	if year ==	1994
				replace cpiu = 	0.644	if year ==	1995
				replace cpiu = 	0.663	if year ==	1996
				replace cpiu = 	0.678	if year ==	1997
				replace cpiu = 	0.689	if year ==	1998
				replace cpiu = 	0.704	if year ==	1999
				replace cpiu = 	0.728	if year ==	2000
				replace cpiu = 	0.748	if year ==	2001
				replace cpiu = 	0.760	if year ==	2002
				replace cpiu = 	0.777	if year ==	2003
				replace cpiu = 	0.798	if year ==	2004
				replace cpiu = 	0.825	if year ==	2005
				replace cpiu = 	0.852	if year ==	2006
				replace cpiu = 	0.876	if year ==	2007
				replace cpiu = 	0.910	if year ==	2008
				replace cpiu = 	0.906	if year ==	2009
				replace cpiu = 	0.921	if year ==	2010
				replace cpiu = 	0.950	if year ==	2011
				replace cpiu = 	0.970	if year ==	2012
				replace cpiu = 	0.984	if year ==	2013
				replace cpiu = 	1.000	if year ==	2014
				replace cpiu = 	1.001	if year ==	2015
				replace cpiu = 	1.014	if year ==	2016
			
			* Address Missings with Inefficent Code
			cap replace eitc = 0 if eitc== 9999
			cap replace ctccrd  = 0 if ctccrd== 999999
			cap replace actccrd  = 0 if actccrd== 99999
			replace inctot = 0 if inctot== 99999999 
			replace fedtax = 0 if fedtax == 999999
			replace statetax = 0 if statetax == 999999
			replace fedr = 0 if fedr == 999999
			replace incwage = 0 if incwage == 9999999  
			replace incbus = 0 if incbus == 9999999 
			replace incfa = 0 if incfa == 9999999 
			replace incdivid = 0 if incdivid == 999999  
			replace incint = 0 if incint == 99999
			replace incrent = 0 if incrent == 99999  
			replace incretir = 0 if incretir == 999999
			replace incc = 0 if incc == 99999
			replace incas = 0 if incas == 99999
			replace inceduc = 0 if inceduc == 99999
			replace incoth = 0 if incoth == 99999
			replace incss = 0 if  incss == 99999
			replace incssi = 0 if  incssi == 99999
			replace incunemp = 0 if incunemp == 99999
			replace incwk = 0 if incwk == 99999
			replace incvet = 0 if incvet == 99999
			replace incdisab = 0 if incdisab == 999999
			replace incsurv = 0 if incsurv == 999999
			replace incwelf = 0 if incwelf == 99999
			replace fica = 0 if fica == 99999
			cap replace incalim = 0 if incalim == 99999
			cap replace incalim = 0 if incalim == .
			cap replace fedtaxac = 0 if fedtaxac == 999999
			cap replace statax = 0 if statax == 999999
			cap replace ahrsworkt = 0 if ahrsworkt == 999
			replace earnweek = 0 if earnweek > 9999.98
			replace hourwage = 0 if hourwage > 99.98
			cap replace mwpval = 0 if mwpval ==999
			replace increti1  = 0 if increti1 ==99999
			replace increti2  = 0 if increti2 ==99999
			
			* Create Vars that Exist in Certain Years 
				cap gen mwpval = 0
					cap replace mwpval = 0 if mwpval ==.
				cap gen stimulus = 0
					cap replace stimulus = 0 if stimulus ==.
				cap gen actccrd = 0
					cap replace actccrd = 0 if actccrd ==.
				cap gen ctccrd = 0
					cap replace ctccrd = 0 if ctccrd ==.
					
			* Variable for State Welfare That is Not TANF (General Assistance)
				gen socassist = 0
				replace socassist = incwelfr if srcwelfr ==2
					gen tanfdiff = incwelfr - tanftrim_p
					replace tanfdiff = 0 if tanfdiff < 0
				replace socassist = tanfdiff if srcwelfr ==3
				
			* Back Out State Credits: 2004 and Before
			
			cap gen scred = statetax - stataxac 
				cap gen scred = 0
				cap replace scred = 0 if scred < 0
				cap replace scred = 0 if scred ==.
				
				qui sum scred if scred>0, de
				replace scred = r(p99)*2 if scred > (r(p99)*2) & scred!=.
			
	
				* sEITC from 1993 to 2003
					
					recode scred (.=0)
					replace statetax = 0 if statetax < 0
				
					* Colorado: 8
						replace scred = eitc * .085 if statef==8 & year==1999
						replace scred = eitc * .1 if statef==8 & (year==2000 | year==2001)
					* DC: 11
						replace scred = eitc * .1 if statef==11 & year==2000
						replace scred = eitc * .25 if statef==11 & inrange(year,2001,2003)
					* IL: 17
						replace  scred = eitc * .05 if statef==17 & inrange(year,2000,2003)
					* IN: 18
						replace  scred = (.034 * (12000-incwage)) if statef==17 & inrange(year,1999,2002) & u14hh >0 & incwage<12001
						replace scred = eitc * .06 if statef==17 & year==2003
					* IA: 19 // non-refund
						replace scred = eitc * .065 if statef==19 & inrange(year,1992,2003)
							replace scred = statetax if scred > statetax & statef==19 & inrange(year,1992,2003)		
					* KS: 20
						replace scred = eitc * .1 if statef==20 & inrange(year,1998,2001)
						replace scred = eitc * .15 if statef==20 & inrange(year,2002,2003)
					* ME: 23
						replace scred = eitc * .05 if statef==23 & inrange(year,2000,2002)
							replace scred = statetax if scred > statetax & statef==23 & inrange(year,2000,2002)	
						replace scred = eitc * .0492 if statef==23 & year==2003
							replace scred = statetax if scred > statetax & statef==23 & year==2003	
					* MD: 24 // nonrefund
						replace scred = eitc * .5 if statef==24 & inrange(year,1993,2003)
							replace scred = statetax if scred > statetax & statef==24 & inrange(year,1993,2003)	
					* MA: 25
						replace scred = eitc * .1 if statef==25 & inrange(year,1997,2000)
						replace scred = eitc * .15 if statef==25 & inrange(year,2001,2003)
					* NJ: 34
						replace scred = eitc * .1 if statef==34 & year==2000
						replace scred = eitc * .15 if statef==34 & year==2001
						replace scred = eitc * .175 if statef==34 & year==2002
						replace scred = eitc * .2 if statef==34 & year==2003
					* NY: 36
						replace scred = eitc * .075 if statef==36 & year==1994
						replace scred = eitc * .1 if statef==36 & year==1995
						replace scred = eitc * .2 if statef==36 & inrange(year,1996,1999)
							replace scred = statetax if scred > statetax & statef==36 & inrange(year,1996,1999)
						replace scred = eitc * .225 if statef==36 & year==2000
							replace scred = statetax if scred > statetax & statef==36 & year==2000
						replace scred = eitc * .25 if statef==36 & year==2001
							replace scred = statetax if scred > statetax & statef==36 & year==2001
						replace scred = eitc * .275 if statef==36 & year==2002
							replace scred = statetax if scred > statetax & statef==36 & year==2002
						replace scred = eitc * .3 if statef==36 & year==2003
							replace scred = statetax if scred > statetax & statef==36 & year==2003
					* OK: 40
						replace scred = eitc * .05 if statef==40 & (year==2002 | year==2003)
					* OR: 41
						replace scred = eitc * .05 if statef==41 & inrange(year,1997,2003)
							replace scred = statetax if scred > statetax & statef==41 & inrange(year,1997,2003)
					* RI: 44
						replace scred = eitc * .255 if statef==44 & inrange(year,2001,2003)
							replace scred = statetax if scred > statetax & statef==44 & inrange(year,2001,2003)	
					* VT: 50
						replace scred = eitc * .28 if statef==50 & year==1993
						replace scred = eitc * .25 if statef==50 & inrange(year,1994,1999)
						replace scred = eitc * .32 if statef==50 & inrange(year,2000,2003)
					* WI: 55 / varies by kids
						replace scred = eitc * .05 if statef==55 & year==1993 & u14hh==1
						replace scred = eitc * .25 if statef==55 & year==1993 & u14hh==2
						replace scred = eitc * .75 if statef==55 & year==1993 & u14hh>2
						
						replace scred = eitc * .12 if statef==55 & year==1994 & u14hh==1
						replace scred = eitc * .188 if statef==55 & year==1994 & u14hh==2
						replace scred = eitc * .63 if statef==55 & year==1994 & u14hh>2
						
						replace scred = eitc * .04 if statef==55 & year==1995 & u14hh==1
						replace scred = eitc * .16 if statef==55 & year==1995 & u14hh==2
						replace scred = eitc * .5 if statef==55 & year==1995 & u14hh>2
						
						replace scred = eitc * .04 if statef==55 & inrange(year,1996,2003) & u14hh==1
						replace scred = eitc * .14 if statef==55 & inrange(year,1996,2003) & u14hh==2
						replace scred = eitc * .43 if statef==55 & inrange(year,1996,2003) & u14hh>2
							
				
			* Disposable Income Concept, With TRIM
			
				gen pinc_trim = (incwage + incbus + incfarm + incss + incretir + incint ///
				+ incunemp + incwkcom + incvet + incsurv + incdisab + incdiv ///
				+ incrent + inceduc + incchild + incalim + incasist + incoth + ///
				eitc + actcc + ctcc + mwpval + scred + stimulus + socassist) 
				
				replace pinc_trim = 0 if pinc_trim==.
				
				* Person-Level Welfare, Corrected 
				gen pwelf_trim = snaptrim + ssitrim_p + tanftrim_p  
				
				* Total Person Income 
				gen pi = pinc_trim + pwelf_trim
					
				gen pxit = (fedtax + statet + fedret + fica)
				gen pil = (incwage + incbus + incfarm)
				
				* Household Income
					
					* HI
					by year hseq, sort: egen hinc_pretax_trim = total(pi) 
					gen hi = hinc_pretax_trim + heatval + SPMu_SchLunch + SPMu_CapHouseSub // housing + lunch at household/unit level
					drop hinc_pretax_trim
					
					* HXIT
					by year hseq, sort: egen hxit = total(pxit) 
					
					* HIL
					by year hseq, sort: egen hil = total(pil) 
			
				* Aggregates
			
					gen dhi = hi - hxit
					sum dhi if relate == 101

					gen mi = hil
					sum mi if relate == 101
					
					gen dmi = hil - hxit
					sum dmi if relate==101
					
			* Disposable Income Concept, Pre-TRIM
			
					* PI/HI: Income
					gen pi_pretrim = (inctot + eitc + actcc + ctcc + mwpval + scred + stimulus)
					by year hseq, sort: egen hi_pretrim = total(pi_pretrim)
						replace hi_pretrim = hi_pretrim + stampval + heatval + SPMu_SchLunch + SPMu_CapHouseSub
					
					* PXIT/HXIT: Taxes
					gen pxit_pretrim = (fedtax + statetax + fedret + fica)
					by year hseq, sort: egen hxit_pretrim = total(pxit_pretrim)
										
					gen dhi_pretrim = hi_pretrim - hxit_pretrim
					gen mi_pretrim = mi
					
			* Equivalence Scales:
				gen edhi = dhi/(sqrt(perhh))
				drop if edhi==.
				replace edhi = 0 if edhi<0
				
				gen emi = mi/(sqrt(perhh))
				drop if emi==.
				replace emi = 0 if emi<0
				
			** Conversions to $2010 using CPI

				gen dhir = (dhi/cpi)
				gen edhir = dhir/(sqrt(perhh))
				drop if edhir==.
				
					gen mir = mi/cpi
					gen emir = mir/(sqrt(perhh))
					
				gen dhir_pretrim = (dhi_pretrim/cpi)
				gen edhir_pretrim = dhir_pretrim/(sqrt(perhh))
				drop if edhir_pretrim==.
				
					gen mir_pretrim = mi_pretrim/cpi
					gen emir_pretrim = mir_pretrim/(sqrt(perhh))	
				
			** Bottom-Code DHI at Zero
					foreach var in  edhir  edhir_pretrim emir_pretrim {
						replace `var' = 0 if `var' < 0
					}
					
	
		*************************
		* Step Two: Prepare Data
		*************************
		
			* Set folder where Historical SPM Data is located.
			global pathspm "C:\Users\...\Historical SPM Thresholds\"
		
			cap drop serial
			gen serial = hseq
	
			cap drop _merge
			cd $pathspm
			merge m:m year serial lineno sex age  using spm1416.dta
			cap drop if statef==.
			
			rename SPMu_Poor_Metadj spmpov
			rename SPMu_ID spmunit
			
			sum spmpov [w=wtsupp]
			sum spmpov [w=wtsupp] if age> 65	
		
			cap gen spm_dhi = SPMu_Resources2
			gen expenses =  SPMu_CapWknChCareXpns + SPMu_MedOOPnMCareB + SPMu_ChildSupPd
			gen taxes = SPMu_FedTax + SPMu_FICA + SPMu_stTax 
			
			* Create Relative Poverty Lines: 50 Percent of National Median Eq. HH Income
				levelsof year, local(levels)
				foreach x of local levels {
					cap gen fedline50 = 0
					qui sum edhir [w=wtsupp] if year==`x', de
					replace fedline50 = (r(p50) * .5) if year==`x'
				}
				
			* Create Relative Poverty Variables
				
				* Pre-TRIM
				gen pre_fpov50 = 0
				replace pre_fpov50 = 1 if edhir_pretrim < fedline50
				
				* Post-TRIM
				gen fpov50 = 0
				replace fpov50 = 1 if edhir < fedline50
					
				* Disposable SPM Income = 
				cap drop check_spm
				
				gen check_spm =  SPMu_totval+SPMu_SNAPSub+ SPMu_CapHouseSub+SPMu_SchLunch+ SPMu_EngVal+SPMu_WICval + ///
				SPMu_Stimulus +SPMu_FedEcRecov -SPMu_FedTax -SPMu_FICA -SPMu_stTax -SPMu_CapWknChCareXpns - ///
				SPMu_MedOOPnMCareB - SPMu_ChildSupPd
				 
				sum check_spm SPMu_Resources2, de
			
				* SPMu_totval =
					
					cap drop checktot
					
					bysort year spmunit: egen checktot = sum(incwage + incbus + incfarm + incss + incwelfr + incretir + ///
					incssi + incint + incunemp  + incwkcom + incvet  + incsurv  + incdisab  + incdivid  + incrent  +  ///
					inceduc  + incchild + incalim  + incasist  +  incother )
									
					sum checktot SPMu_totval, de 	
					
			******************************************
			*** Bringing in TRIM SSI, SNAP, TANF:
			******************************************
			
				bysort year spmunit: egen spmtrim_tanf = sum(tanftrim_p)
				bysort year spmunit: egen spmtrim_ssi = sum(ssitrim_p)
				bysort year spmunit: egen spmtrim_snap = sum(snaptrim)
				
				* Create new "Cash" Var with SSI, TANF:
				
				bysort year spmunit: egen spm_cash_trim = sum(incwage + incbus + incfarm + incss + tanftrim_p + socassist + incretir + ///
				ssitrim_p + incint + incunemp  + incwkcom + incvet  + incsurv  + incdisab  + incdivid  + incrent  +  ///
				inceduc  + incchild + incalim  + incasist  +  incother )
				
				* Now, add to SPM collection with TRIM Substitutes
				
				gen spm_dhi_trim =  spm_cash_trim+spmtrim_snap+ SPMu_CapHouseSub+SPMu_SchLunch+ SPMu_EngVal+SPMu_WICval + ///
				SPMu_Stimulus +SPMu_FedEcRecov -SPMu_FedTax -SPMu_FICA -SPMu_stTax -SPMu_CapWknChCareXpns - ///
				SPMu_MedOOPnMCareB - SPMu_ChildSupPd

				sum spm_dhi spm_dhi_trim [w=wtsupp], de
				
				******************************************
				***  New Pov Vars:
				******************************************
	
					gen povthresh = SPMu_PovThreshold_Metadj
					
					* Check:
						gen povtest = 0
						replace povtest = 1 if spm_dhi < povthresh
						sum povtest spmpov
						* All good.
						
					* New SPM Pov Variable:
					
						gen spmpov_trim = 0
						replace spmpov_trim = 1 if spm_dhi_trim < povthresh
						
					* Means of Pre/Post-TRIM Poverty Variables
						ci mean spmpov spmpov_trim pre_fpov50 fpov50 [w=wtsupp] if year==2015
						ci mean spmpov spmpov_trim pre_fpov50 fpov50 [w=wtsupp] if year==2015 & child
						ci mean spmpov spmpov_trim pre_fpov50 fpov50 [w=wtsupp] if year==2015 & child & (singmom | singdad)
								
				
				
				***********************************
				* Estimating Take-Up & Levels of Benefits
				***********************************
				
				
					* 1) Make Post-Trim Vars
						gen yestanf = 0
						gen yessnap = 0
						gen yesssi = 0
						
						replace yestanf = 1 if spmtrim_tanf > 0 & spmtrim_tanf!=.
						replace yessnap = 1 if spmtrim_snap > 0 & spmtrim_snap!=.
						replace yesssi = 1 if spmtrim_ssi > 0 & spmtrim_ssi!=.
						
						sum yestanf yessnap yesssi [w=wtsupp] if year==2015
						
							
					* 2) Make Pre-Trim Vars
					
						gen pretanf = 0
						replace pretanf = incwelfr if srcwelf == 1 | srcwelf == 3
						
						bysort year spmunit: egen cps_tanf = sum(pretanf)
						bysort year spmunit: egen cps_ssi = sum(incssi)
						bysort year spmunit: egen cps_snap = sum(stampval)
							replace cps_snap = cps_snap / SPMu_NumPer if cps_snap!=0 & cps_snap!=.
						
						gen pre_yestanf = 0
						gen pre_yessnap = 0
						gen pre_yesssi = 0
						
						replace pre_yestanf = 1 if cps_tanf > 0 & cps_tanf!=.
						replace pre_yessnap = 1 if cps_snap > 0 & cps_snap!=.
						replace pre_yesssi = 1 if cps_ssi > 0 & cps_ssi!=.
						
						sum pre_yestanf pre_yessnap pre_yesssi [w=wtsupp] if year==2015
						
						* Can now estimate share of households receiving benefits.
						
						
				* 3) Measuring Extent of Underreporting in Data Pre/Post TRIM
	
					* Pre-TRIM
					set more off
					foreach x of numlist 2013 / 2015 {
						foreach y in cps_snap cps_tanf cps_ssi  {
						
							qui sum `y' [w=hwtsupp] if  year==`x' & rel==101, de
							di "`x'", "`y'", ( r(sum_w) * r(mean)   )
						
					}
					}
					
					set more off
					foreach x of numlist 2013 / 2015 {
						foreach y in spmtrim_snap spmtrim_ssi spmtrim_tanf  {
						
							qui sum `y' [w=hwtsupp] if year==`x' & rel==101, de
							di "`x'", "`y'", ( r(sum_w) * r(mean)   )
						
					}
					}			
						
				
				* 4) Mapping Benefits over the Gross Income Distribution
				keep if year==2015
				
				gen inc2 = inctot -  incwelf - incssi - incdivid - incrent
				bysort year hseq: egen hhincome2 = sum(inc2)
				xtile grossrank = hhincome2 [w=hwtsupp], nq(100)
				
				
				set more off
				foreach z in yessnap pre_yessnap yestanf pre_yestanf yesssi pre_yesssi {
				
					cap gen `z'_low = .
					cap gen `z'_high = . 
				
				
				foreach x of numlist 1/ 50 {
				
					qui ci mean `z' [w=wtsupp] if grossrank==`x'
					replace `z'_low = r(lb) if grossrank==`x' 
					replace `z'_high = r(ub) if grossrank==`x' 
					
				}
				}
				
			collapse (mean) yessnap pre_yessnap yestanf pre_yestanf yesssi pre_yesssi ///
				yessnap_low pre_yessnap_low yestanf_low pre_yestanf_low yesssi_low pre_yesssi_low ///
				yessnap_high pre_yessnap_high yestanf_high pre_yestanf_high yesssi_high pre_yesssi_high [w=wtsupp], by(grossrank)
			
				keep if grossrank < 51
					
				twoway line yessnap pre_yessnap yessnap_high pre_yessnap_high yessnap_low pre_yessnap_low ///
					grossrank, name(a, replace) ylab(0(.1)1) lcolor(gs0 gs0 gs12 gs12 gs12 gs12) ///
					lpat(solid  dash shortdash shortdash shortdash shortdash ) xtit("Gross Income Percentile") ///
					legend(order(1 "With TRIM" 2 "Pre-TRIM")) graphregion(color(white)) tit("SNAP")
				
				twoway line yestanf pre_yestanf yestanf_high pre_yestanf_high yestanf_low pre_yestanf_low ///
					grossrank, name(b, replace) ylab(0(.1)1) lcolor(gs0 gs0 gs12 gs12 gs12 gs12) ///
					lpat(solid  dash shortdash shortdash shortdash shortdash ) xtit("Gross Income Percentile") ///
					legend(order(1 "With TRIM" 2 "Pre-TRIM")) graphregion(color(white)) tit("TANF")
				
				
				twoway line yesssi pre_yesssi yesssi_high pre_yesssi_high yesssi_low  pre_yesssi_low ///
					grossrank, name(c, replace) ylab(0(.1)1) lcolor(gs0 gs0 gs12 gs12 gs12 gs12) ///
					lpat(solid  dash shortdash shortdash shortdash shortdash ) xtit("Gross Income Percentile") ///
					legend(order(1 "With TRIM" 2 "Pre-TRIM")) graphregion(color(white)) tit("SSI")
				
				grc1leg a b c, legendfrom(a) graphregion(color(white))
