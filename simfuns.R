library(shellpipes)

loadEnvironments()

vec_sims <- function(pop,vax_vec, vp_vec, ve_vec, foi){
	dd <- data.frame(vax=c("unvax",vax_vec)
		, size = pop*c(1-sum(vp_vec),vp_vec)
		, prop = foi*c(1,1-ve_vec)
	)
}

saveEnvironment()
