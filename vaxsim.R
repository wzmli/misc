library(tidyverse)
library(shellpipes)

loadEnvironments()

basic_sim <- function(pop,vax_prop,ve,foi){
	dd <- data.frame(vax = c("unvax","vax")
		, size = pop*c(1-vax_prop, vax_prop)
		, prop = c(foi,foi*(1-ve))
	)
	return(dd)
}

basic_dat <- basic_sim(pop=pop,vax_prop=vprop,ve=ve,foi=foi)

print(basic_dat)


rdsSave(basic_dat)

