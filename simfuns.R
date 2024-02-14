library(shellpipes)

loadEnvironments()


vec_sims <- function(pop,vax_vec, vp_vec, ve_vec, foi){
	f = foi*c(1,1-ve_vec)
	dd <- data.frame(vax=c("unvax",vax_vec)
		, size = pop*c(1-sum(vp_vec),vp_vec)
		## , prop = f
		, prop = 1-exp(-f)
	)
}


saveEnvironment()
