cd "\\Client\C$\Users\jasonbell\Dropbox\Aesthetics\"
use aesthetic.dta, clear
drop ResponseId
rename fun1 lubricity
rename fun2 bleed

*** Show that H/L manipulations actually produce variation
gen A_H = 0
replace A_H= 1 if inlist(Version, "AH-FMa", "AH-FMb", "AHNE-FMa", "AHNE-FMb")
reg aesthetic A_H
gen F_H = 0
replace F_H= 1 if inlist(Version, "FHa", "FHb", "FHNEa", "FHNEb")
reg lubricity F_H
reg bleed F_H

*** Combine high and low groups, use continuous measure instead of factors
replace Version = "Aa" if inlist(Version, "AH-FMa", "AL-FMa")
replace Version = "Ab" if inlist(Version, "AH-FMb", "AL-FMb")
replace Version = "ANEa" if inlist(Version, "AHNE-FMa", "ALNE-FMa")
replace Version = "ANEb" if inlist(Version, "AHNE-FMb", "ALNE-FMb")
replace Version = "Fa" if inlist(Version, "FHa", "FLa")
replace Version = "Fb" if inlist(Version, "FHb", "FLb")
replace Version = "FNEa" if inlist(Version, "FHNEa", "FLNEa")
replace Version = "FNEb" if inlist(Version, "FHNEb", "FLNEb")
encode Version, gen(version)

*** Create Factor Dummies *
* Order: functional or aesthetic
gen F_first = 0
replace F_first = 1 if inlist(Version, "Fa", "Fb", "FNEa", "FNEb")
gen A_first = 1 - F_first
* Order: lubricity vs. bleed
gen lub_first = 0
replace lub_first = 1 if inlist(Version, "Fa", "FNEa", "Aa", "ANEa")
gen bleed_first = 1 - lub_first
* Evaluation: early or late
gen eval_early = 0
replace eval_early = 1 if inlist(Version, "ANEa", "ANEb", "FNEa", "FNEb")
*** Cascade from A -> F
gen F_first = 0
replace F_first = 1 if inlist(Version, "Fa", "Fb", "FNEa", "FNEb")
gen A_first = 1 - F_first
reg lubricity aesthetic if A_first == 1
reg bleed aesthetic if A_first == 1
* Hold out is ANEa: shown lubricity before bleeding, eval at very end
reg lubricity c.aesthetic##i.version if A_first == 1, noconst
