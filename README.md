# Data and analysis for the ASSIP trial
This repository contains data and analyses from the ASSIP 24-months follow-up randomized controlled study.

We provide a short analysis script (`survival.R`) to replicate the main findings of our study using the original data (`assip.RData`). Results in our paper may slightly differ because these are based on twenty imputed dataset. Variable description and statistical output see below.

Gysin-Maillart A, Schwab S, Soravia LM, Megert M, & Michel K (2015). A novel brief therapy for attempted suicide: Two year follow-up randomized controlled study of the Attempted Suicide Short Intervention Program (ASSIP). Manuscript submitted for publication.

## Variable description
    amb_sess_t1_6M	    Number of outpatient sessions at time one (t1), including the last 6 months
    bdisum2				BDI (Beck Depression Intventory) sum, after 6 months (t2)
    bdisum3				BDI (Beck Depression Intventory) sum, after 12 months (t3)
    bdisum4				BDI (Beck Depression Intventory) sum, after 18 months (t4)
    bdisum5				BDI (Beck Depression Intventory) sum, after 24 months (t5)
    BSS_T2				BSS (Beck Scale for Suicide Ideation) mean, after 6 months (t2)
    BSS_T3				BSS (Beck Scale for Suicide Ideation) mean, after 12 months (t3)
    BSS_T4				BSS (Beck Scale for Suicide Ideation) mean, after 18 months (t4)
    BSS_T5				BSS (Beck Scale for Suicide Ideation) mean, after 24 months (t5)
    ITT			        Intention to treat
    repeater_t2			repeated suicide attempts (patient), 1-6 months, dichotomous(0, minimum 1 suicide attempt)
    repeater_t3			repeated suicide attempts (patient), 6-12 months, dichotomous(0, minimum 1 suicide attempt)
    repeater_t4			repeated suicide attempts (patient), 12-18 months, dichotomous(0, minimum 1 suicide attempt)
    repeater_t5			repeated suicide attempts (patient), 18-24 months, dichotomous(0, minimum 1 suicide attempt)
    stat_days_t1		Inpatient days at baseline (6 months backward)
    sum_stat_12months	Sum of inpatient days after 12 months
    sum_stat_24months	Sum of outpatient days after 24 months
    
## Output
### Survival
	Call: survfit(formula = Surv(time, repeater) ~ group, type = "kaplan-meier")
	
	65 observations deleted due to missingness 
	                group=ASSIP & ASSIP Drop out 
	 time n.risk n.event survival std.err lower 95% CI upper 95% CI
	    6    229       1    0.996 0.00436        0.987            1
	   12    170       1    0.990 0.00727        0.976            1
	   18    111       1    0.981 0.01143        0.959            1
	   24     56       2    0.946 0.02671        0.895            1
	
	                group=CG & CG Drop out 
	 time n.risk n.event survival std.err lower 95% CI upper 95% CI
	    6    186       7    0.962  0.0140        0.935        0.990
	   12    134       5    0.926  0.0207        0.887        0.968
	   18     84       5    0.871  0.0308        0.813        0.934
	   24     42       5    0.768  0.0513        0.673        0.875
	
### Group difference
	> 
	> # group difference (Mantel-Haenszel) ----
	> survdiff(Surv(time, repeater) ~ group, rho=0)
	Call:
	survdiff(formula = Surv(time, repeater) ~ group, rho = 0)
	
	n=415, 65 observations deleted due to missingness.
	
	                               N Observed Expected (O-E)^2/E (O-E)^2/V
	group=ASSIP & ASSIP Drop out 229        5     15.2      6.83      16.1
	group=CG & CG Drop out       186       22     11.8      8.78      16.1
	
	 Chisq= 16.1  on 1 degrees of freedom, p= 5.99e-05 

### Cox hazard ratio

For hazard ratio see ``exp(-coef)`` below

	> # Cox hazard for discrete data ----
	> hazard <- coxph(Surv(time, repeater) ~ group, ties="exact")
	> summary(hazard)
	Call:
	coxph(formula = Surv(time, repeater) ~ group, ties = "exact")
	
	  n= 415, number of events= 27 
	   (65 observations deleted due to missingness)
	
	                        coef exp(coef) se(coef)     z Pr(>|z|)    
	groupCG & CG Drop out 1.7826    5.9451   0.5006 3.561 0.000369 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
	
	                      exp(coef) exp(-coef) lower .95 upper .95
	groupCG & CG Drop out     5.945     0.1682     2.229     15.86
	
	Rsquare= 0.04   (max possible= 0.421 )
	Likelihood ratio test= 16.75  on 1 df,   p=4.268e-05
	Wald test            = 12.68  on 1 df,   p=0.0003695
	Score (logrank) test = 16.11  on 1 df,   p=5.992e-05
	
	
