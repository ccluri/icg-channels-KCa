TITLE CaGk
: Calcium activated K channel.
: Modified from Moczydlowski and Latorre (1983) J. Gen. Physiol. 82

UNITS {
	(molar) = (1/liter)
}

UNITS {
	(mV) =	(millivolt)
	(mA) =	(milliamp)
	(mM) =	(millimolar)
}


NEURON {
	SUFFIX cagk
	:USEION nca READ ncai VALENCE 2
	:USEION lca READ lcai VALENCE 2
	:USEION tca READ tcai VALENCE 2
	USEION ca READ cai
	USEION k READ ek WRITE ik
	RANGE gkbar,gkca, ik
	GLOBAL oinf, otau
}

UNITS {
	FARADAY = (faraday)  (kilocoulombs)
	R = 8.313424 (joule/degC)
}

PARAMETER {
	celsius		(degC)
	v		(mV)
	gkbar=.01	(mho/cm2)	: Maximum Permeability
	:cai = 5.e-5	(mM)
	ek		(mV)
	cai (mM)
	d1 = .84
	d2 = 1.
	k1 = .48e-3	(mM)
	k2 = .13e-6	(mM)
	abar = .28	(/ms)
	bbar = .48	(/ms)
        st=1            (1)
	:lcai		(mV)
	:ncai		(mV)
	:tcai		(mV)
}

ASSIGNED {
	ik		(mA/cm2)
	oinf
	otau		(ms)
        gkca          (mho/cm2)
}

INITIAL {
	:cai= ncai + lcai + tcai
        rate(v,cai)
        o=oinf
}

STATE {	o }		: fraction of open channels

BREAKPOINT {
	SOLVE state METHOD cnexp
	gkca = gkbar*o^st
	ik = gkca*(v - ek)
}

DERIVATIVE state {	: exact when v held constant; integrates over dt step
	rate(v, cai)
	o' = (oinf - o)/otau
}

FUNCTION alp(v (mV), c (mM)) (1/ms) { :callable from hoc
	alp = c*abar/(c + exp1(k1,d1,v))
}

FUNCTION bet(v (mV), c (mM)) (1/ms) { :callable from hoc
	bet = bbar/(1 + c/exp1(k2,d2,v))
}

FUNCTION exp1(k (mM), d, v (mV)) (mM) { :callable from hoc
	exp1 = k*exp(-2*d*FARADAY*v/R/(273.15 + celsius))
}

PROCEDURE rate(v (mV), c (mM)) { :callable from hoc
	LOCAL a
	a = alp(v,c)
	otau = 1/(a + bet(v, c))
	oinf = a*otau
}

