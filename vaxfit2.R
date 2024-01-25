library(tidyverse)
library(emmeans)
library(shellpipes)

dat <- rdsRead()

dat2 <- (dat
    |> mutate(vax_type.lag = interaction(vax_type, lag, drop = TRUE))
)

print(dat2)

mod2 <- glm(prop ~ month + vax_type.lag
          , weights = size
          , data=dat2
          , family = binomial()
)
coef(mod2)    


## vignette("comparisons", package = "emmeans")

emm1 <- emmeans(mod2, ~ vax_type.lag,type="response")
plot(emm1, type = "response")

print(confint(emm1))

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


