library(tidyverse)
library(shellpipes)
## We want to simulate fake data that looks like the real data
## We don't want to include people getting vaccinated and reported positive within the same month.
## We want at least 1 month lag since vaccination

vax <- c("mono","bi")
month <- c(2,3)
lag <- c(1,2)

vax <- (expand.grid(month=month,lag=lag,vax_type=vax)
	%>% filter(month>lag)
	%>% mutate(vax_month=month-lag
		, vax_month = as.character(vax_month)
		, lag = as.character(lag)
	)
	%>% select(month,vax_month,lag,vax_type)
)

unvax <-data.frame(month = month
	, vax_month = "blank"
	, lag = "blank"
	, vax_type = "unvax"
)

dat <- (bind_rows(vax,unvax))

print(dat)
