library(tidyverse)
library(shellpipes)

loadEnvironments()

basic_dat <- basic_sim(pop=pop,vax_prop=vprop,ve=ve,foi=foi)

print(basic_dat)


rdsSave(basic_dat)

