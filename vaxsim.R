library(tidyverse)
library(shellpipes)
## We want to simulate fake data that looks like the real data
## We don't want to include people getting vaccinated and reported positive within the same month.
## We want at least 1 month lag since vaccination

vax <- c("mono","bi")
month <- c(2,3)
lag <- c(1,2)

vaxlag <- (expand.grid(month=month,lag=lag,vax_type=vax)
	%>% filter(month>lag)
	%>% mutate(vax_month=month-lag
		, vax_month = as.character(vax_month)
		, lag = as.character(lag)
	)
	%>% select(month,vax_month,lag,vax_type)
)

print(vaxlag)


propdat <- data.frame(prop = c(0.8,0.7,0.6,0.3,0.2,0.1)
	, size = c(100,500,200,500,200,100)
)

vaxdat <- bind_cols(vaxlag,propdat)

print(vaxdat)

## creating unvax dataframe

unvaxdat <-data.frame(month = month
	, vax_month = "blank"
	, lag = "blank"
	, vax_type = "unvax"
	, prop = c(0.6, 0.5)
	, size = c(1000,600)
)

dat <- (bind_rows(vaxdat,unvaxdat)
)

print(dat)

rdsSave(dat)

