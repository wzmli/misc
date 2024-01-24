## ----setup, include=FALSE, warning=FALSE----------------------------------------------------------

library(tidyverse)
options(width = 100)



## ----vaxsim, echo=FALSE---------------------------------------------------------------------------
vax <- c("mono","bi")
month <- c(2,3)
lag <- c(1,2)

vaxlag <- (expand.grid(month=month,lag=lag,vax_type=vax)
   |> filter(month>lag)
   |> mutate(vax_month=month-lag)
   |> select(month,vax_month,lag,vax_type)
)

propdat <- data.frame(prop = c(0.4,0.3,0.2,0.3,0.2,0.1)
   , size = c(100,50,20,50,20,10)
)

vaxdat <- bind_cols(vaxlag,propdat)

## creating unvax dataframe

unvaxdat <-data.frame(month = month
   , vax_month = NA
   , lag = NA
   , vax_type = "unvax"
   , prop = c(0.5, 0.5)
   , size = c(1000,600)
)

dat <- (bind_rows(vaxdat,unvaxdat)
   |> mutate(NULL
      , month = as.factor(month)
      , vax_month = as.factor(vax_month)
      , lag = as.factor(lag)
      , vax_type = as.factor(vax_type)
   )
)

print(dat)

####
dat2 <- (dat
    |> mutate(across(where(is.factor), as.character))
    |> replace_na(list(vax_month = "", lag = ""))
    |> mutate(across(where(is.character), as.factor))
    |> mutate(vax_type.lag = interaction(vax_type, lag, drop = TRUE))
)


mod2 <- glm(prop ~ month + vax_type.lag,
          , weights = size
          , data=dat2
          , family = "binomial"
)
coef(mod2)    
library(emmeans)
## vignette("comparisons", package = "emmeans")
## ----fit------------------------------------------------------------------------------------------
emm1 <- emmeans(mod2, ~ vax_type.lag)
plot(emm1)

cc <- contrast(emm1,
               list(mono=c(0,0,1/2,0,1/2),
                    bi = c(0, 1/2, 0, 1/2),
                    unvax_vs_mono = c(-1, 0, 1/2, 0, 1/2),
                    unvax_vs_bi = c(-1, 1/2, 0, 1/2, 0))
         )

mod_default <- glm(prop ~ month + vax_type*lag
   , weights = size
   , data=dat
   , family = "binomial"
)

print(mod_default)


## ----mmfit vaxonly,echo=FALSE---------------------------------------------------------------------

mm <- model.matrix(mod_default)

print(mm)

vaxonly <- dat |> filter(vax_type != "unvax")

mod_vaxonly <- glm(prop~0+mm
	, data = vaxonly
	, weight = size
	, family = "binomial"
)

print(mod_vaxonly)


## ----mm construction,echo=FALSE-------------------------------------------------------------------

mmfull <- (dat
   |> mutate(NULL
      , month2 = ifelse(month == 2,1,0)
      , month3 = ifelse(month == 3,1,0)
      , lag1 = ifelse(lag == 1, 1, 0)
      , lag2 = ifelse(lag == 2, 1, 0)
      , lag1 = ifelse(is.na(lag1),0,lag1)
      , lag2 = ifelse(is.na(lag2),0,lag2)
      , unvax = ifelse(vax_type == "unvax", 1, 0)
      , vaxmono = ifelse(vax_type == "mono", 1, 0)
      , vaxbi = ifelse(vax_type == "bi", 1, 0)
      , monolag1 = ifelse((lag1 == 1) & (vaxmono == 1),1,0)
      , monolag2 = ifelse((lag2 == 1) & (vaxmono == 1),1,0)
      , bilag1 = ifelse((lag1 == 1) & (vaxbi == 1),1,0)
      , bilag2 = ifelse((lag2 == 1) & (vaxbi == 1),1,0)
   )
   |> select(-(names(dat)))
   |> as.matrix()
)

print(mmfull)


## ----mmfit full-----------------------------------------------------------------------------------
mod_full <- glm(prop ~ 0 + mmfull
	, weight = size
	, data = dat
	, family = "binomial"
)

print(mod_full)

na.omit(coef(mod_full))
