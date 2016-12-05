COMMENT

kca.mod

Calcium-dependent potassium channel
Based on
Pennefather (1990) -- sympathetic ganglion cells
taken from
Reuveni et al (1993) -- neocortical cells

Author: Zach Mainen, Salk Institute, 1995, zach@salk.edu

Kole: the caix increased from 1 -> 4, Ra 0.01 to 0.05 and Rb 0.02 to 0.1, according to Schaefer et al, 2003 to allow BAC firing
	
ENDCOMMENT

INDEPENDENT {t FROM 0 TO 1 WITH 1 (ms)}

NEURON {
	SUFFIX kca
	USEION k READ ek WRITE ik
	USEION ca READ cai
	RANGE n, gkca, ikca, gbar
	RANGE ninf, ntau
	GLOBAL Ra, Rb, caix
	GLOBAL q10, temp, tadj, vmin, vmax
}

UNITS {
	(mA) = (milliamp)
	(mV) = (millivolt)
	(pS) = (picosiemens)
	(um) = (micron)
} 

PARAMETER {
	gbar = 10   	(pS/um2)	: 0.03 mho/cm2
	v 		(mV)
	cai  		(mM)
	caix = 4	
									
	Ra   = 0.05	(/ms)		: max act rate  
	Rb   = 0.1	(/ms)		: max deact rate 

	dt		(ms)
	celsius		(degC)
	temp = 23	(degC)		: original temp 	
	q10  = 2.3			: temperature sensitivity

	vmin = -120	(mV)
	vmax = 100	(mV)
} 


ASSIGNED {
	a		(/ms)
	b		(/ms)
	ik 		(mA/cm2)
	ikca 		(mA/cm2)
	gkca		(pS/um2)
	ek		(mV)
	ninf
	ntau 		(ms)	
	tadj
}
 

STATE { n }

INITIAL { 
	rates(cai)
	n = ninf
}

BREAKPOINT {
        SOLVE states METHOD cnexp
	gkca =gbar*n
	ikca = (1e-4) * gkca * (v - ek)
	ik = ikca
} 

LOCAL nexp

DERIVATIVE states {   :Computes state variable n 
        rates(cai)      :             at the current v and dt.
        n' =  (ninf-n)/ntau

}

PROCEDURE rates(cai(mM)) {  

        

        a = Ra * cai^caix
        b = Rb

        tadj = q10^((celsius - temp)/10)

        ntau = 1/tadj/(a+b)
	ninf = a/(a+b)

 
:        tinc = -dt * tadj
:        nexp = 1 - exp(tinc/ntau)
}



