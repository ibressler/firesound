# Makefile
#
# Copyright (c) 2016 Ingo Bressler (dev@ingobressler.net)
#
# This file is part of the FireSound scripts,
# licensed under the terms of the GPLv3.

# build&package script

PROJECT_NAME = firesound
SRC_DIR = src
SCRIPT_DIR = scripts
DOC_DIR = doc
DOC_FILES = *_800.png
FILES = LICENSE README.md
PCKG_DIR = $(PROJECT_NAME)
VERSION = $(shell git show -s --format="%ci %h %d" HEAD | \
		awk '{ if($$7 && index($$6, "tag:")) \
				print gensub(",$$", "", 1, $$7); \
			else \
				print $$1"_"$$4; \
			}')
PCKG_FN = "$(PROJECT_NAME)_$(VERSION).zip"

.PHONY: binary

all: binary

binary:
	$(MAKE) -C $(SRC_DIR)

package: binary
	mkdir -p $(PCKG_DIR)
	cp $(SCRIPT_DIR)/*.sh $(PCKG_DIR)
	cp $(SRC_DIR)/*.so $(PCKG_DIR)
	cp $(FILES) $(PCKG_DIR)
	mkdir -p $(PCKG_DIR)/$(DOC_DIR)
	cp $(DOC_DIR)/$(DOC_FILES) $(PCKG_DIR)/$(DOC_DIR)
	zip -r -9 $(PCKG_FN) $(PCKG_DIR)
	sha1sum -b $(PCKG_FN) > $(PCKG_FN).sha

clean:
	$(MAKE) -C $(SRC_DIR) clean

