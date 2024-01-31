library(tidyverse)
library(emmeans)
library(shellpipes)

dat <- rdsRead()

### BMB's method, create the interaction of the different combinations

dat2 <- (dat
	|> mutate(vax_type.lag = interaction(vax_type, lag, drop = TRUE))
	|> group_by(vax_type.lag)
	|> mutate(wavg = weighted.mean(prop,w=size))
)

print(dat2)

mod2 <- glm(prop ~ month + vax_type.lag
	, weights = size
	, data=dat2
	, family = binomial()
)
coef(mod2)    


## vignette("comparisons", package = "emmeans")

## Transforms back to the probability scale?!? when type = response

emm1 <- emmeans(mod2, ~ vax_type.lag,type="response")
gg <- plot(emm1, type = "response")

print(gg 
	+ ggtitle("Effects") 
	+ geom_point(data=dat2,aes(y=vax_type.lag,x=wavg),color="red")
)

print(confint(emm1))

## Create the contrast to test things or grouping effects?!?

print(contrast(emm1))

cc <- contrast(emm1
	, list(mono=c(0,0,1/2,0,1/2)
		, bi = c(0, 1/2, 0, 1/2,0)
		, unvax = c(1, 0, 0, 0, 0)
		, mono_vs_bi = c(0,1/2,-1/2,1/2,-1/2)
	)
	, type = "response"
)

print(cc)

print(confint(cc))

print(plot(cc)+ggtitle("contrast"))


