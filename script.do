* randomizzazione nella valutazione d'impatto

* scenario 1: autoselezione 
clear 

set seed 1634450

global volte = 2000

set obs $volte 
gen diff = .
gen reg_semplice = .
gen reg_multipla = .
gen aggiunta = .
save risultati_bias, replace 

global N = 1000

forv i = 1/$volte {
	clear 
	set obs $N
	
	gen femmina = (uniform() <= 0.4)
	gen straniero = (uniform() <= 0.20)
	gen eta = ceil(18+uniform()*7) //tra 18 e 25
	gen anni_istruzione = ceil(13+uniform()*5) //tra 13 e 18
	gen motivazione = rnormal()
	gen epsilon = rnormal()

	gen trattati = (motivazione >= 0)

	gen reddito = ceil(1500 + 100*trattati - 200*femmina - 300*straniero + 20*eta + 10*anni_istruzione +50*motivazione + epsilon)
	
	* modo1:
	qui sum reddito if trattati == 1
	global reddito_T = r(mean)
	qui sum reddito if trattati == 0
	global reddito_C = r(mean)
	global diff = $reddito_T - $reddito_C

	* modo2:
	qui reg reddito trattati, robust
	global reg_semplice = e(b)[1,1]
	
	* modo3:
	qui reg reddito trattati femmina straniero eta anni_istruzione, robust
	global reg_multipla = e(b)[1,1]
	
	* aggiunta
	qui reg motivazione trattati, robust 
	global aggiunta = e(b)[1,1]
	
	* risultati 
	di "run: " `i' 
	di "differenza: " ${diff}	
	di "stima reg semplice: " ${reg_semplice} 
	di "stima reg multipla: " ${reg_multipla}
	di ""
	di ""
	
	use risultati_bias.dta, clear
	foreach v in diff reg_semplice reg_multipla aggiunta {
		replace `v' = $`v' in `i'
	}
	save risultati_bias.dta, replace 

}

use risultati_bias, clear 

foreach v in diff reg_semplice reg_multipla {
	qui sum `v'
	global `v'_bias = r(mean)
}

di "effetto medio su " $volte " simulazioni: "
di "con differenza: " $diff_bias
di "con reg semplice: " $reg_semplice_bias
di "con reg multipla: " $reg_multipla_bias 

file open myfile_cc using risultati_bias.csv, write replace
file write myfile_cc " " "," "stima media"
file write myfile_cc _n "Differenza" "," ($diff_bias)
file write myfile_cc _n "Regressione semplice" "," ($reg_semplice_bias)
file write myfile_cc _n "Regressione Multipla" "," ($reg_multipla_bias)
file close myfile_cc
type risultati_bias.csv


* scenario 2: randomizzazione
clear 

global volte = 2000

set obs $volte 
gen diff = .
gen reg_semplice = .
gen reg_multipla = .
save risultati_rand, replace 

global N = 1000

forv i = 1/$volte {
	clear 
	set obs $N
	
	gen femmina = (uniform() <= 0.4)
	gen straniero = (uniform() <= 0.20)
	gen eta = ceil(18+uniform()*7) //tra 18 e 25
	gen anni_istruzione = ceil(13+uniform()*5) //tra 13 e 18
	gen motivazione = rnormal()
	gen epsilon = rnormal()

	gen trattati = (uniform() <= 0.5)

	gen reddito = ceil(1500 + 100*trattati - 200*femmina - 300*straniero + 20*eta + 10*anni_istruzione +50*motivazione + epsilon)
	
	* modo1:
	qui sum reddito if trattati == 1
	global reddito_T = r(mean)
	qui sum reddito if trattati == 0
	global reddito_C = r(mean)
	global diff = $reddito_T - $reddito_C

	* modo2:
	qui reg reddito trattati, robust
	global reg_semplice = e(b)[1,1]
	
	* modo3:
	qui reg reddito trattati femmina straniero eta anni_istruzione, robust
	global reg_multipla = e(b)[1,1]
	
	* risultati 
	di "run: " `i' 
	di "differenza: " ${diff}	
	di "stima reg semplice: " ${reg_semplice} 
	di "stima reg multipla: " ${reg_multipla}
	di ""
	di ""
	
	use risultati_rand.dta, clear
	foreach v in diff reg_semplice reg_multipla {
		replace `v' = $`v' in `i'
	}
	save risultati_rand.dta, replace 

}

use risultati_rand, clear 

foreach v in diff reg_semplice reg_multipla {
	qui sum `v'
	global `v'_rand = r(mean)
}

di "effetto medio su " $volte " simulazioni: "
di "con differenza: " $diff_rand
di "con reg semplice: " $reg_semplice_rand
di "con reg multipla: " $reg_multipla_rand

file open myfile_cc using risultati_rand.csv, write replace
file write myfile_cc " " "," "stima media"
file write myfile_cc _n "Differenza" "," ($diff_rand)
file write myfile_cc _n "Regressione semplice" "," ($reg_semplice_rand)
file write myfile_cc _n "Regressione Multipla" "," ($reg_multipla_rand)
file close myfile_cc
type risultati_rand.csv

* appendice: sovrastima dell'effetto
clear 
use "risultati_bias"

sum aggiunta
global delta = r(mean)

di 100+50*$delta
di $reg_multipla_bias

* formula: b_tilde(trattamento) = b_vero(trattamento) + b_vero(motivazione)*delta(motivazione,trattamento)
