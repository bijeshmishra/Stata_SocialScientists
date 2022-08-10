preserve
/* https://www.statalist.org/forums/forum/general-stata-discussion/general/1413982-creating-stacked-bar-charts */
/* Plot Rating Scale */
sysuse auto, clear

contract rep78 foreign, nomiss
bys foreign (rep78) : replace _freq = sum(_freq)
bys foreign (rep78) : replace _freq = _freq/_freq[_N]*100

twoway bar _freq foreign if rep78 == 5 , barw(.5) || ///
       bar _freq foreign if rep78 == 4 , barw(.5) || ///
       bar _freq foreign if rep78 == 3 , barw(.5) || ///
       bar _freq foreign if rep78 == 2 , barw(.5) || ///
       bar _freq foreign if rep78 == 1 , barw(.5)    ///
       legend(order(1 "Excellent"                    ///
                    2 "Good"                         ///
                    3 "Average"                      ///
                    4 "Fair"                         ///
                    5 "Poor"))                       ///
       ytitle(percent)                               ///
       xlab(0/1, val)
restore
