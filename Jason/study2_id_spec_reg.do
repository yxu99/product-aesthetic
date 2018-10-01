cd ~/Documents/Research/product-aesthetic/Jason


import delimited aesthetic-7-17.csv, clear
*drop pq* n* *wtp_sure *wtp_other d*
encode version, gen(condition)
rename cd* d*
rename *_wtp wtp_*
rename *_fev fev_*
rename *_aev aev_*
gen id = _n
reshape long wtp fev aev, i(id) j(prod) string
replace prod = subinstr(prod, "_", "", .)
encode prod, gen(product) 
save study2_long, replace
keep if version == "FAH" 
reg fev aev i.product


use study2_long, clear
keep if version == "AFH" 
reg aev fev i.product

