library(tidyverse)
library(shellpipes)

loadEnvironments()

dat <- vec_sims(pop=pop,vax_vec=vax,vp_vec=vprop,ve_vec=ve,foi=foi)

print(dat)

rdsSave(dat)

