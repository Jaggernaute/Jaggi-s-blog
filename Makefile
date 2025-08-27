PDF_TARGETS += index.pdf
PDF_TARGETS += posts/article-template.pdf
PDF_TARGETS += posts/artificial-non-intelligence/artificial-non-intelligence.pdf
PDF_TARGETS += posts/electronics/electronics.pdf
PDF_TARGETS += posts/learning-c/learning-c.pdf
HT_TARGETS = $(addsuffix .html,$(basename $(PDF_TARGETS)))
SRC_DIR = src
DEPS_DIR = .deps
OUTPUT_DIR = output
BUILD_DIR = .aux
LATEXMK = latexmk -shell-escape -recorder -use-make -deps -norc -auxdir=$(BUILD_DIR) \
      -e 'warn qq(In Makefile, turn off custom dependencies\n);' \
      -e '@cus_dep_list = ();' \
      -e 'show_cus_dep();'
MAKE4HT = make4ht -u -c config.cfg -B $(BUILD_DIR)

all : pdf html

pdf : $(addprefix $(OUTPUT_DIR)/,$(PDF_TARGETS))

html : $(addprefix $(OUTPUT_DIR)/,$(HT_TARGETS))

clean:
	rm -rf $(BUILD_DIR) $(DEPS_DIR)

fclean: clean
	rm -rf $(OUTPUT_DIR)

re: fclean all


.PHONY : all pdf html clean fclean re

# $(foreach file,$(PDF_TARGETS),$(eval -include $(DEPS_DIR)/$(OUTPUT_DIR)/$(file)P))
$(DEPS_DIR) $(OUTPUT_DIR) :
	mkdir $@
$(OUTPUT_DIR)/%.pdf : $(SRC_DIR)/%.tex
	tex-fmt $<
	$(LATEXMK) -pdf -dvi- -ps- -deps-out=$(DEPS_DIR)/$@P -outdir=$(dir $@) $<
$(OUTPUT_DIR)/%.html : $(SRC_DIR)/%.tex $(OUTPUT_DIR)/%.pdf config.cfg
	$(MAKE4HT) -d $(dir $@) $< "fn-in"
$(OUTPUT_DIR)/%.pdf : $(SRC_DIR)/%.fig
	fig2dev -Lpdf $< $@
