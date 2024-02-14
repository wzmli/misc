current: target
-include target.mk

# -include makestuff/perl.def

vim_session:
	bash -cl "vmt README.md"

######################################################################

Sources += $(wildcard *.R) README.md

######################################################################

## local.mk needs to point to your Dropbox
Sources += $(wildcard *.local)
## jd.lmk:
%.lmk:
	ln -fs $*.local local.mk

-include local.mk

######################################################################

autopipeR = defined

######################################################################

params.Rout: params.R
	$(pipeR)

vaxsim.Rout: vaxsim.R params.rda
	$(pipeR)

vaxfit.Rout: vaxfit.R vaxsim.rds params.rda
	$(pipeR)

## vaxfit2.Rout: vaxfit2.R vaxsim.R
vaxfit2.Rout: vaxfit2.R vaxsim.rds 
	$(pipeR)

Sources += $(*.Rmd) vaxsim.Rmd

render.Rout: render.R vaxsim.Rmd
	$(pipeR)

Ignore += vaxsim.html
vaxsim.html: render.Rout vaxsim.Rmd

vaxsim_BMB.Rout: vaxsim_BMB.R
	$(pipeR)

######################################################################

### Makestuff

Sources += Makefile

## Sources += content.mk
## include content.mk

Ignore += makestuff
msrepo = https://github.com/dushoff

Makefile: makestuff/Makefile
makestuff/Makefile:
	git clone $(msrepo)/makestuff
	ls makestuff/Makefile

-include makestuff/os.mk

-include makestuff/pandoc.mk
-include makestuff/pipeR.mk
-include makestuff/chains.mk

-include makestuff/git.mk
-include makestuff/visual.mk
