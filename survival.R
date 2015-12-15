# by Simon Schwab, schwab@puk.unibe.ch, 2015
# University Hospital of Psychiatry, and University of Bern.

# Statistical analysis for the ASSIP trial
# Gysin-Maillart A, Schwab S, Soravia LM, Megert M, & Michel K (2015).
# A novel brief therapy for attempted suicide: Two year follow-up randomized
# controlled study of the Attempted Suicide Short Intervention Program (ASSIP).

# This is a short analysis script to replicate the main findings of our study
# using the original data. Result in our paper may slightly differ because
# these are based on twenty imputed dataset.

# install and load required package(s)
install.packages("survival")
library(survival)

# loading  data ----
load("assip.RData")
summary(mydata)

repeater = c(
  as.character(mydata$repeater_t2), #  6 months
  as.character(mydata$repeater_t3), # 12
  as.character(mydata$repeater_t4), # 18
  as.character(mydata$repeater_t5)) # 24 R cannot concat factors, conversion to char

repeater = as.factor(repeater) == 'Suizidversuch (mind. 1)'
group = rep(mydata$ITT,4) # repeat group coding for the 4 follow-up's
time = c(rep(6,120), rep(12,120), rep(18,120), rep(24,120)) # follow-up month

# survival (Kaplan-Meier) ----
fit = survfit(Surv(time, repeater) ~ group, type="kaplan-meier")
summary(fit)

# group difference (Mantel-Haenszel) ----
survdiff(Surv(time, repeater) ~ group, rho=0)
# Cox hazard for discrete data ----
hazard <- coxph(Surv(time, repeater) ~ group, ties="exact")
summary(hazard)
