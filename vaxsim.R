library(tidyverse)
library(shellpipes)
## We want to simulate fake data that looks like the real data
## We don't want to include people getting vaccinated and reported positive within the same month.
## We want at least 1 month lag since vaccination

vax <- c("mono","bi")
month <- c(2,3)
lag <- c(1,2)

vaxlag <- (expand.grid(month=month,lag=lag,vax=vax)
	%>% filter(month>lag)
	%>% mutate(month_vax=month-lag)
	%>% select(month,month_vax,lag,vax)
)

print(vaxlag)


propdat <- data.frame(prop = c(0.4,0.3,0.2,0.3,0.2,0.1)
	, size = c(100,50,20,50,20,10)
)

vaxdat <- bind_cols(vaxlag,propdat)

print(vaxdat)

## creating unvax dataframe

unvaxdat <-data.frame(month = month
	, month_vax = NA
	, lag = NA
	, vax = "unvax"
	, prop = c(0.5, 0.5)
	, size = c(1000,600)
)

dat <- bind_rows(vaxdat,unvaxdat)

print(dat)

rdsSave(dat)

