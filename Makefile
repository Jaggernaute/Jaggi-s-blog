all: re

%.bbl: %.bib
	biber $(subst bbl,,$@)

outputs :=

define each-file-cmd
    tex-fmt $(strip $2)
	make4ht -u -c config.cfg -d $(strip $1) $(strip $2) "fn-in"
	pdflatex -interaction=nonstopmode -output-directory $(strip $1) $(strip $2)
endef

define mk-bib-deriv

$(subst .bib,.bbl,$(notdir $(strip $1))): $(notdir $(strip $1)) $(strip $2)
	biber $(subst .bib,,$(notdir $(strip $1)))

$(notdir $(strip $1)): $(strip $1)
	cp $$< $$@

endef

define plop

.PHONY: $(strip $1)
$(strip $1): $(strip $2)
	@ mkdir -p $$@
	$(call each-file-cmd, $(strip $1), $(strip $2))

$(foreach b, $(strip $3), $(call mk-bib-deriv, $b, $(strip $1)))

$(strip $1).ok: $(strip $1) $(subst .bib,.bbl,$(notdir $(strip $3)))
ifneq ($(strip $3),)
	$(call each-file-cmd, $(strip $1), $(strip $2))
	$(call each-file-cmd, $(strip $1), $(strip $2))
endif
	touch $$@

outputs += $(strip $1).ok

endef

SPACE != echo -n " "
SRC_TEX != find src -type f -name "*.tex"

$(foreach f, $(SRC_TEX), $(eval $(call plop, \
    $(subst src, output, $(dir $f)), $f, $(wildcard $(dir $f)*.bib))) )

output: $(outputs)
	@ find output -type f -name "*.ok" -delete
	@ $(foreach f, $(SRC_TEX:src/%=output/%),\
        $(RM) $(subst .tex,,$f).$(subst $(SPACE),, \
            {aux,bcf,out,run.xml,toc} \
        ) ;)
	@ $(foreach f, $(SRC_TEX),\
        $(RM) $(subst .tex,,$(notdir $f)).$(subst $(SPACE),, \
            {tex,4{ct,tc},aux,b{bl,bc,cf,ib,lg},css,dvi,html,\
                idv,lg,log,run.xml,xml,tmp,xref,png,svg} \
        ) ;)
	@ $(RM) -f *.png *.svg

fclean:
	@ $(RM) -r output

.NOTPARALLEL: re
re: fclean output

.PHONY: all clean fclean re
