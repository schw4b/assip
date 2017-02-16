# by Simon Schwab, schwab@puk.unibe.ch, 2015
# University Hospital of Psychiatry, and University of Bern.

# Statistical analysis for the ASSIP trial
# Gysin-Maillart A, Schwab S, Soravia LM, Megert M, & Michel K (2016).
# A Novel Brief Therapy for Patients Who Attempt Suicide: A 24-months follow-up
# randomized controlled study of the Attempted Suicide Short Intervention Program (ASSIP).
# PLoS Medicine. Manuscript accepted for publication.

# This is a short analysis script to replicate the main findings of our study
# using the original data. Results in our paper may slightly differ because
# these are based on twenty imputed dataset.

# install and load required package(s)
install.packages("survival")
library(survival)

# loading  data ----
setwd("~/workspace/assip/")
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

# Restructure data for non-recurring events ----
E='Suizidversuch (mind. 1)'
time=rep(NA,120)
event=rep(NA,120)
for (i in 1:120) {
  f = c(mydata$repeater_t2[i]==E, mydata$repeater_t3[i]==E, mydata$repeater_t4[i]==E, mydata$repeater_t5[i]==E)
  if (sum(f, na.rm = T) > 0) { # time to event
    time[i]=which(f)[1]*6; event[i]=1
  } else {  # censoring
    c=tail(which(!f), n=1)
    if (length(c) > 0) {time[i]=c*6; event[i]=0}
    else {time[i]=0; event[i]=0}
  }
}
# survival (Kaplan-Meier) ----
fit = survfit(Surv(time, event) ~ mydata$ITT, type="kaplan-meier")
summary(fit)
# group difference (Mantel-Haenszel) ----
survdiff(Surv(time, event) ~ mydata$ITT, rho=0)
# Cox hazard for discrete data ----
hazard <- coxph(Surv(time, event) ~ mydata$ITT, ties="exact")
summary(hazard)

# Non-recurring analysis of imputed data ----
load("repeaterImp.Rdata")
E='Suizidversuch (mind. 1)'

time =array(NA, dim=c(120,20))
event=array(NA, dim=c(120,20))
for (m in 1:20) {
  for (i in 1:120) {
    f=as.logical(repeater.imp[c(i,120+i,240+i,360+i),m])
    if (sum(f, na.rm = T) > 0) { # time to event
      time[i,m]=which(f)[1]*6; event[i,m]=1
    } else {  # censoring
      c=tail(which(!f), n=1)
      if (length(c) > 0) {time[i,m]=c*6; event[i,m]=0}
      else {time[i,m]=0; event[i,m]=0}
    }
  }
}

# Cox hazard for discrete data ----
risk=rep(NA,20)
for (m in 1:20) {
  hazard <- coxph(Surv(time[,m], event[,m]) ~ mydata$ITT, ties="exact")
  s=summary(hazard)
  risk[m]=exp(-s$coefficients[1])
}
c(median(1-risk), min(1-risk), max(1-risk))
