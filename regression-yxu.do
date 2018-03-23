clear
cd "/Users/AaronXu/Research_Project/Product Design/Data Analysis/The raw data"
use "aesthetic.dta"

** how having aesthetic picture change the evaluation of function attributes 
gen condition_aesthetic =1 if Version =="AH-FMa"|Version =="AH-FMb"| Version=="AHNE-FMa"| Version=="AHNE-FMb"|Version=="AL-FMa"|Version=="AL-FMb"|Version=="ALNE-FMa"|Version=="ALNE-FMb"
replace condition_aesthetic =0 if condition_aesthetic ==.
gen condition_evaluate =1 if Version =="AH-FMa"|Version =="AH-FMb"| Version=="AL-FMa"|Version=="AL-FMb"|Version=="FHa"|Version=="FHb"|Version=="FLa"|Version=="FLb"
replace condition_evaluate=0 if condition_evaluate==.
gen condition_H =1 if Version =="AH-FMa"|Version =="AH-FMb"|Version=="FHa"|Version=="FHb"|Version =="AHNE-FMa"|Version =="AHNE-FMb"|Version=="FHa"|Version=="FHb"| Version=="FHNEa"|Version=="FHNEb"
replace condition_H=0 if condition_H==.

gen condition_a =1 if Version =="AH-FMa"|Version =="AHNE-FMa"|Version=="AL-FMa"|Version=="ALNE-FMa"|Version =="FHa"|Version =="FLa"|Version =="FHNEa"|Version =="FLNEa"
replace condition_a=0 if condition_a==.


reg fun1 condition_aesthetic##condition_evaluate##condition_H if condition_a==1
estimates store fun1
reg fun2 condition_aesthetic##condition_evaluate##condition_H if condition_a==1
estimates store fun2
coefplot(fun1, label("writing quality"))(fun2, label("control of bleeding")),coeflabel(1.condition_aesthetic = "AF" 1.condition_evaluate = "E" 1.condition_aesthetic#1.condition_evaluate ="AF&E" 1.condition_H="H" 1.condition_aesthetic#1.condition_H="AF&H"  1.condition_evaluate#1.condition_H="E&H" 1.condition_aesthetic#1.condition_evaluate#1.condition_H="AF&E&H") vertical  recast(bar) ciopts(recast(rcap)) citop barwidt(0.3) mlabgap(*2) mlabel("{it:p} = "+string(@pval,"%9.3f"))
coefplot(fun1, label("writing quality"))(fun2, label("control of bleeding")),coeflabel(1.condition_aesthetic = "AF" 1.condition_evaluate = "E" 1.condition_aesthetic#1.condition_evaluate ="AF&E" 1.condition_H="H" 1.condition_aesthetic#1.condition_H="AF&H"  1.condition_evaluate#1.condition_H="E&H" 1.condition_aesthetic#1.condition_evaluate#1.condition_H="AF&E&H") mlabgap(*2) mlabel("{it:p} = "+string(@pval,"%9.3f"))



reg fun2 condition_aesthetic##condition_evaluate##condition_H if condition_a==0
estimates store fun2
reg fun1 condition_aesthetic##condition_evaluate##condition_H if condition_a==0
estimates store fun1
coefplot(fun2, label("control of bleeding"))(fun1, label("writing quality")),coeflabel(1.condition_aesthetic = "AF" 1.condition_evaluate = "E" 1.condition_aesthetic#1.condition_evaluate ="AF&E" 1.condition_H="H" 1.condition_aesthetic#1.condition_H="AF&H"  1.condition_evaluate#1.condition_H="E&H" 1.condition_aesthetic#1.condition_evaluate#1.condition_H="AF&E&H") vertical  recast(bar) ciopts(recast(rcap)) citop barwidt(0.3) mlabgap(*2) mlabel("{it:p} = "+string(@pval,"%9.3f"))
coefplot(fun2, label("control of bleeding"))(fun1, label("writing quality")),coeflabel(1.condition_aesthetic = "AF" 1.condition_evaluate = "E" 1.condition_aesthetic#1.condition_evaluate ="AF&E" 1.condition_H="H" 1.condition_aesthetic#1.condition_H="AF&H"  1.condition_evaluate#1.condition_H="E&H" 1.condition_aesthetic#1.condition_evaluate#1.condition_H="AF&E&H") mlabgap(*2) mlabel("{it:p} = "+string(@pval,"%9.3f"))



gen condition_function =1 if condition_aesthetic==0
replace condition_function =0 if condition_aesthetic ==1
reg aesthetic condition_function##condition_evaluate##condition_H 
estimates store aesthetic
coefplot(aesthetic, label("aesthetic")),coeflabel(1.condition_function = "FF" 1.condition_evaluate = "E" 1.condition_function#1.condition_evaluate ="FF&E" 1.condition_H="H" 1.condition_function#1.condition_H="FF&H"  1.condition_evaluate#1.condition_H="E&H" 1.condition_function#1.condition_evaluate#1.condition_H="FF&E&H") mlabgap(*2) mlabel("{it:p} = "+string(@pval,"%9.3f"))


reg WTP condition_aesthetic##condition_evaluate##condition_H 
estimates store WTP
coefplot(WTP, label("willingness to pay price")),coeflabel(1.condition_aesthetic = "AF" 1.condition_evaluate = "E" 1.condition_aesthetic#1.condition_evaluate ="AF&E" 1.condition_H="H" 1.condition_aesthetic#1.condition_H="AF&H"  1.condition_evaluate#1.condition_H="E&H" 1.condition_aesthetic#1.condition_evaluate#1.condition_H="AF&E&H") mlabgap(*2) mlabel("{it:p} = "+string(@pval,"%9.3f"))


gen between_pollution =1 if Version =="AH-FMa"|Version =="AH-FMb"| Version=="AHNE-FMa"| Version=="AHNE-FMb"|Version=="AL-FMa"|Version=="AL-FMb"|Version=="ALNE-FMa"|Version=="ALNE-FMb"
replace between_pollution=0 if between_pollution==.

gen within_pollution =1 if Version =="AH-FMb"| Version=="AHNE-FMb"|Version=="AL-FMb"|Version=="ALNE-FMb"| Version=="FHb"|Version=="FLb"|Version=="FHNEb"|Version=="FLNEb"
replace within_pollution=0 if within_pollution==.

gen function_levelH =1 if Version =="FHb"| Version=="FHNEb"|Version =="FHa"| Version=="FHNEa"
replace function_levelH=0 if function_levelH==.

gen function_levelL =1 if Version =="FLb"| Version=="FLNEb"|Version =="FLa"| Version=="FLNEa"
replace function_levelL=0 if function_levelL==.

reg fun1 function_levelH function_levelL between_pollution##within_pollution##c.fun1 




gen condition_aestheticH =1 if Version =="AH-FMa"|Version =="AH-FMb"| Version=="AHNE-FMa"| Version=="AHNE-FMb"
replace condition_aestheticH =0 if condition_aestheticH ==.

gen condition_aestheticL =1 if Version =="AL-FMa"|Version =="AL-FMb"| Version=="ALNE-FMa"| Version=="ALNE-FMb"
replace condition_aestheticL =0 if condition_aestheticL ==.



reg fun1 condition_aestheticH condition_aestheticL
reg fun2 condition_aestheticH condition_aestheticL
