cd "~/Documents/Research/product-aesthetic"
use aesthetic.dta, clear
drop if WTP > 1000
drop ResponseId
rename fun1 lubricity
rename fun2 bleed

* Use continuous measures rather than factors
replace Version = "Aa" if inlist(Version, "AH-FMa", "AL-FMa")
replace Version = "Ab" if inlist(Version, "AH-FMb", "AL-FMb")
replace Version = "ANEa" if inlist(Version, "AHNE-FMa", "ALNE-FMa")
replace Version = "ANEb" if inlist(Version, "AHNE-FMb", "ALNE-FMb")
replace Version = "Fa" if inlist(Version, "FHa", "FLa")
replace Version = "Fb" if inlist(Version, "FHb", "FLb")
replace Version = "FNEa" if inlist(Version, "FHNEa", "FLNEa")
replace Version = "FNEb" if inlist(Version, "FHNEb", "FLNEb")
encode Version, gen(version)

* Define remaining factors
gen F_first = 0
replace F_first = 1 if inlist(Version, "Fa", "Fb", "FNEa", "FNEb")
gen A_first = 1 - F_first

gen EE = 0
replace EE = 1 if inlist(Version, "Aa", "Ab", "Fa", "Fb")
gen LE = 1 - EE

gen bleed_first = 0
replace bleed_first = 1 if inlist(Version, "Ab", "ANEb", "Fb", "FNEb")
gen lub_first = 1 - bleed_first

*-----------------
* Cascade A -> F
*-----------------

** Lubricity 
* Significant 4-way.  Wow.
reg lubricity EE##c.aesthetic##c.bleed##lub_first if A_first ==1, noconst
			 
** Bleed
* 4-way is significant
*reg bleed EE##lub_first##c.aesthetic##c.lubricity if A_first == 1, noconst
*gen four_way = EE * lub_first * aesthetic * lubricity
*gen EE_lubf_aes = EE * lub_first * aesthetic

* Let's do it without the insignificant 3-ways
*reg bleed EE##lub_first EE#c.aesthetic EE#c.lubricity lub_first#c.aesthetic ///
*	lub_first#c.lubricity c.aesthetic##c.lubricity ///
*	EE_lubf_aes four_way if A_first == 1, noconst
* Four way turns out insignificant above.  Now without four-way:
*reg bleed EE##lub_first EE#c.aesthetic EE#c.lubricity lub_first#c.aesthetic ///
*	lub_first#c.lubricity c.aesthetic##c.lubricity ///
*	EE_lubf_aes if A_first == 1, noconst
* Last remaining 3-way turns insignificant.  Dropping that:
*reg bleed EE##lub_first EE#c.aesthetic EE#c.lubricity lub_first#c.aesthetic ///
*	lub_first#c.lubricity c.aesthetic##c.lubricity if A_first == 1, noconst
* Dropping insignificant 2-ways:
reg bleed EE lub_first lub_first#c.lubricity ///
	c.aesthetic##c.lubricity if A_first == 1, noconst
* Both EE and aesthetic main effects are insignificant
	
	

*-----------------
* Cascade F -> A
*-----------------

*reg aesthetic EE##lub_first##c.lubricity##c.bleed if F_first == 1, noconst
* 4-way interaction not significant 
*reg aesthetic EE##lub_first##c.lubricity ///
*			  EE##lub_first##c.bleed ///
*			  EE##c.lubricity##c.bleed ///
*			  lub_first##c.lubricity##c.bleed ///
*			  if F_first == 1, noconst
* After dropping the 4-way, all 3-ways are NS (reg above).  Dropping 3-ways:
*reg aesthetic EE lub_first bleed lubricity EE#lub_first EE#c.lubricity ///
*			  lub_first#c.lubricity EE#c.bleed lub_first#c.bleed ///
*			  c.lubricity#c.bleed ///
*			  if F_first == 1, noconst
* Only one of the 2-way interactions is significant.  Dropping the rest:
reg aesthetic EE lub_first bleed lubricity c.lubricity#c.bleed ///
			  if F_first == 1, noconst
	
*---------------	
* WTP 
*---------------
*reg WTP EE##lub_first##c.lubricity##c.bleed##A_first, noconst
* What do you know?  The 5-way and none of the 4-ways are significant
*reg WTP EE##lub_first##c.lubricity EE##lub_first##c.bleed ///
*		EE##c.lubricity##c.bleed lub_first##c.lubricity##c.bleed ///
*		EE##lub_first##A_first EE##A_first##c.lubricity ///
*		lub_first##A_first##c.lubricity EE##A_first##c.bleed ///
*		lub_first##A_first##c.bleed ///
*		A_first##c.lubricity##c.bleed, noconst
* None of the 3-ways are significant either, same with 2-ways
reg WTP A_first aesthetic lubricity bleed lub_first, noconst

drop if WTP > 100
reg WTP A_first aesthetic lubricity bleed lub_first, noconst
