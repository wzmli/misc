library(tidyverse)
library(emmeans)
library(shellpipes)

loadEnvironments()


basic_fit <- glm(prop~vax
	, weights = size
	, data = rdsRead()
	, family = binomial()
)

print(summary(basic_fit))


basic_emm <- emmeans(basic_fit, ~vax, type = "response")

gg <- plot(basic_emm, type = "response")

print(gg)


basic_con <- contrast(basic_emm)

print(basic_con)

basic_con2 <- contrast(basic_emm
	, list(vaxComp = c(0,-1,1)
		, testComp = c(0, 1, -1)
		, moreStuff = c(1, -1/2, -1/2)
	)
	, ratios=FALSE
)

print(basic_con2)

print(plot(basic_con2))

## Recovering VE

cc <- coef(basic_fit)
1- exp(cc[2])
1 - plogis(cc[1]+cc[2])/plogis(cc[1])


