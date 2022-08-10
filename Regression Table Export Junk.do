clear all
sysuse auto
eststo: quietly regress price weight mpg
eststo: quietly regress price weight mpg foreign
esttab, noisily notype
estout, 
 cells(b(fmt(a3) star) t(fmt(2) par("{ralign @modelwidth:{txt:(}" "{txt:)}}")))
 stats(N, fmt(%18.0g) labels(`"N"'))
 starlevels(* 0.05 ** 0.01 *** 0.001)
 varwidth(12)
 modelwidth(12)
 abbrev
 delimiter(" ")
 smcltags
 prehead(`"{hline @width}"')
 posthead("{hline @width}")
 prefoot("{hline @width}")
 postfoot(`"{hline @width}"' `"t statistics in parentheses"' `"@starlegend"')
 varlabels(, end("" "") nolast)
 mlabels(, depvar)
 numbers
 collabels(none)
 eqlabels(, begin("{hline @width}" "") nofirst)
 interaction(" # ")
 notype
 level(95)
 style(esttab)

return list
