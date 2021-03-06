: AHP Current, based on Stacey, Durand 2000
 

UNITS 
{
        (mA) = (milliamp)
        (mV) = (millivolt)
	(S) = (siemens)
	(molar) = (1/liter)
}
 
NEURON {
        SUFFIX KAHP
	USEION k READ ek WRITE ik
	USEION ca READ cai :VALENCE 2.0
        RANGE gAHPbar, gAHP
        GLOBAL qinf, qtau
}
 
PARAMETER 
{
    gAHPbar = 0.0033 (S/cm2)	<0,1e9>
    :eK = -95 (mV)
	qtau = 48 (ms)
	
}
 

STATE 
{
        q
}
 
ASSIGNED 
{
        ek (mV)
        v (mV)
        celsius (degC)
	gAHP (S/cm2)
        ik (mA/cm2)
	qinf
	cai (millimolar)
}
 

BREAKPOINT 
{
        SOLVE states METHOD cnexp
        gAHP = gAHPbar*q
	ik = gAHP*(v - ek)
}
 
 
INITIAL 
{
	rates(v)
	q = qinf
}

DERIVATIVE states 
{  
        rates(v)
 
	q' =  (qinf-q)/qtau
}
 
LOCAL q10


PROCEDURE rates(v(mV))   
                      
{
        LOCAL  alpha, beta, sum

UNITSOFF
               
        q10 = 3^((celsius - 6.3)/10)
               
        alpha = 0.0048 / exp((10 * log10(cai*1000)-35)/-2)
        beta =  0.012 / exp((10 * log10(cai*1000)+100) / 5)
        sum = alpha + beta
        qinf = alpha/sum
}
 
FUNCTION vtrap(x,y) {  :Traps for 0 in denominator of rate eqns.
        if (fabs(x/y) < 1e-6) {
                vtrap = y*(1 - x/y/2)
        }else{
                vtrap = x/(exp(x/y) - 1)
        }
}
 
 
UNITSON
