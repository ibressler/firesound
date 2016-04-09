# Makefile
#
# Copyright (c) 2016 Ingo Bressler (dev@ingobressler.net)
#
# This file is part of the FireSound scripts,
# licensed under the terms of the GPLv3.

# build&package script

SRC_DIR = src
SCRIPT_DIR = scripts
DOC_DIR = doc
FILES = LICENSE README

PCKG_DIR = firesound

.PHONY: binary

all: binary

binary:
	$(MAKE) -C $(SRC_DIR)

package: binary
	mkdir -p $(PCKG_DIR)
	cp $(SCRIPT_DIR)/*.sh $(PCKG_DIR)
	cp $(SRC_DIR)/*.so $(PCKG_DIR)
	cp $(FILES) $(PCKG_DIR)
	cp -R $(DOC_DIR) $(PCKG_DIR)

clean:
	$(MAKE) -C $(SRC_DIR) clean

