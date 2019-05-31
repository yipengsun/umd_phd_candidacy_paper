# Author: Yipeng Sun <syp at umd dot edu>
#
# Based on: https://tex.stackexchange.com/questions/40738/how-to-properly-make-a-latex-project
# Last Change: Fri May 31, 2019 at 06:52 AM -0400

# Set LaTeX compiler
MAKE_TEX	:=	lualatex

# Basic variables
BASEFILE	?=	$(basename $(wildcard *.tex))
PDF_FILE	:=	$(BASEFILE).pdf
ZIP_FILE	:=	yipengsun-$(BASEFILE).zip

# Detect changes for included latex files
ASSET_DIRS = $(shell find include/ -type d)
ASSET_FILES = $(shell find include/ -type f -name '*.tex')

.PHONY: all clean pack

all: $(PDF_FILE)

%.pdf: %.tex $(ASSET_DIRS) $(ASSET_FILES)
	@latexmk -pdf \
		-pdflatex="$(MAKE_TEX) -interaction=nonstopmode -synctex=1" \
		-use-make \
		-jobname=build/$(basename $(@F)) \
		$(basename $(@F))
	@mv build/$@ .
	@mv build/$(basename $(@F)).synctex.gz .

clean:
	@rm -rf build/*

pack:
	@echo "Packing all files into a zip bundle..."
	@apack $(ZIP_FILE) ./Makefile ./README.md ./*.tex ./*.pdf ./res ./schematics
