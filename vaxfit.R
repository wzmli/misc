library(tidyverse)
library(shellpipes)

vaxdat <- rdsRead()

vaxonly <- (vaxdat 
#	%>% filter(vax != "unvax")
	%>% mutate(NULL
		, month = as.factor(month)
		, lag = as.factor(lag)
	)
)

mod1 <- glm(prop ~ 0 + month + vax*lag
	, weights = size
	, data=vaxonly
)

print(summary(mod1))

mm <- model.matrix(mod1)

print(mm)

class(mm)

# mod2 <- glm(prop ~ 0 + mm, data=vaxonly, weight = size)

# print(mod2)

print(vaxonly)

mmvaxonly <- (vaxonly
	%>% mutate(NULL
		, month2 = ifelse(month == 2,1,0)
		, month3 = ifelse(month == 3,1,0)
		, lag1 = ifelse(lag == 1, 1, 0)
		, lag2 = ifelse(lag == 2, 1, 0)
		, lag1 = ifelse(is.na(lag1),0,lag1)
		, lag2 = ifelse(is.na(lag2),0,lag2)
		, unvax = ifelse(vax == "unvax", 1, 0)
		, vaxmono = ifelse(vax == "mono", 1, 0)
		, vaxbi = ifelse(vax == "bi", 1, 0)
		, monolag1 = ifelse((lag1 == 1) & (vaxmono == 1),1,0)
		, monolag2 = ifelse((lag2 == 1) & (vaxmono == 1),1,0)
		, bilag1 = ifelse((lag1 == 1) & (vaxbi == 1),1,0)
		, bilag2 = ifelse((lag2 == 1) & (vaxbi == 1),1,0)
	)
	%>% select(-(names(vaxonly)))
	%>% as.matrix()
)

print(mmvaxonly)

mod3 <- (glm(prop ~ 0 + mmvaxonly,weight=size, data=vaxonly))

print(mod3)

