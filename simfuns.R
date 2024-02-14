library(shellpipes)

loadEnvironments()

basic_sim <- function(pop,vax_prop,ve,foi){
	dd <- data.frame(vax = c("unvax","vax")
		, size = pop*c(1-vax_prop, vax_prop)
		, prop = c(foi,foi*(1-ve))
	)
	return(dd)
}


saveEnvironment()
