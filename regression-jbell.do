cd "\\Client\C$\Users\jasonbell\Dropbox\Aesthetics\"
use aesthetic.dta, clear
drop ResponseId
replace Version = "Aa" if inlist(Version, "AH-FMa", "AL-FMa")
replace Version = "Ab" if inlist(Version, "AH-FMb", "AL-FMb")
replace Version = "ANEa" if inlist(Version, "AHNE-FMa", "ALNE-FMa")
replace Version = "ANEb" if inlist(Version, "AHNE-FMb", "ALNE-FMb")
replace Version = "Fa" if inlist(Version, "FHa", "FLa")
replace Version = "Fb" if inlist(Version, "FHb", "FLb")
replace Version = "FNEa" if inlist(Version, "FHNEa", "FLNEa")
replace Version = "FNEb" if inlist(Version, "FHNEb", "FLNEb")
