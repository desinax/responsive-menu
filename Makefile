#!/usr/bin/make -f
#
#

# Detect OS
OS = $(shell uname -s)

# Defaults
ECHO = echo

# Make adjustments based on OS
# http://stackoverflow.com/questions/3466166/how-to-check-if-running-in-cygwin-mac-or-linux/27776822#27776822
ifneq (, $(findstring CYGWIN, $(OS)))
	ECHO = /bin/echo -e
endif

# Colors and helptext
NO_COLOR	= \033[0m
ACTION		= \033[32;01m
OK_COLOR	= \033[32;01m
ERROR_COLOR	= \033[31;01m
WARN_COLOR	= \033[33;01m

# Which makefile am I in?
WHERE-AM-I = $(CURDIR)/$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))
THIS_MAKEFILE := $(call WHERE-AM-I)

# Echo some nice helptext based on the target comment
HELPTEXT = $(ECHO) "$(ACTION)--->" `egrep "^\# target: $(1) " $(THIS_MAKEFILE) | sed "s/\# target: $(1)[ ]*-[ ]* / /g"` "$(NO_COLOR)"

# Check version  and path to command and display on one line
CHECK_VERSION = printf "%-15s %-10s %s\n" "`basename $(1)`" "`$(1) --version $(2)`" "`which $(1)`"

# Add local bin path for test tools
BIN 		= bin
VENDORBIN 	= vendor/bin
NPMBIN		= node_modules/.bin

# LESS and CSS
LESS 		 	= src/less/style.less
LESS_MODULES	= src/less/
LESS_OPTIONS 	= --strict-imports --include-path=$(LESS_MODULES)

STYLELINT := $(NPMBIN)/stylelint
LESSC     := $(NPMBIN)/lessc



# The JavaScript fileset
#
JS_FILES 	= src/js/responsive-menu.js
#JS_MINIFIED = $(JS_FILES:.js=.min.js)



#
# Tool to check and minimize javascript code
#
# JS_CODESTYLE 			= jscs
# JS_CODESTYLE_OPTIONS 	=

JS_LINT 				= $(NPMBIN)/eslint
JS_LINT_OPTIONS 		=

JS_MINIFY 			= $(NPMBIN)/uglifyjs
JS_MINIFY_OPTIONS 	= --mangle --compress --screw-ie8 --comments



# Add local bin path for test tools
#SHELL 	:= /bin/bash
#PATH	:= "$(PWD)/node_modules/.bin:$(PATH)"
#SHELL 	:= env PATH=$(PATH) /bin/bash



# ------------------------------------------------------------------------
#
# General and combined targets
#

# target: help               - Displays help.
.PHONY:  help
help:
	@$(call HELPTEXT,$@)
	@$(ECHO) "Usage:"
	@$(ECHO) " make [target] ..."
	@$(ECHO) "target:"
	@egrep "^# target:" Makefile | sed 's/# target: / /g'



# target: clean              - Remove all generated files.
.PHONY:  clean
clean:
	@$(call HELPTEXT,$@)
	rm -rf build
	rm -f npm-debug.log



# target: clean-all          - Remove all installed files.
.PHONY:  clean-all
clean-all: clean
	@$(call HELPTEXT,$@)
	rm -rf node_modules



# target: prepare-build      - Clear and recreate the build directory.
.PHONY: prepare-build
prepare-build:
	@$(call HELPTEXT,$@)
	install -d build/css build/lint build/js



# target: install            - Install all tools neded.
.PHONY: install
install:
	@$(call HELPTEXT,$@)
	npm install
	cp node_modules/css-styleguide/.stylelintrc.json .
	cp node_modules/javascript-style-guide/.eslintrc.json .



# target: test               - Execute all tests.
.PHONY: test
test: less-lint js-cs js-lint
	@$(call HELPTEXT,$@)



# target: build              - Build all files and install in htdocs
.PHONY: build
build: less js-minify
	@$(call HELPTEXT,$@)




# target: check              - Check versions of all installed tools.
.PHONY: check
check:
	@$(call HELPTEXT,$@)
	@$(call CHECK_VERSION, node)
	@$(call CHECK_VERSION, npm)
	@$(call CHECK_VERSION, $(STYLELINT))
	@$(call CHECK_VERSION, $(LESSC), | cut -d ' ' -f 2)
	@$(call CHECK_VERSION, $(JS_LINT))
	@$(call CHECK_VERSION, $(JS_MINIFY), | cut -d ' ' -f 2)



# ------------------------------------------------------------------------
#
# LESS
#

# target: less               - Compile and minify the stylesheet.
.PHONY: less
less: prepare-build
	@$(call HELPTEXT,$@)
	$(LESSC) $(LESS_OPTIONS) $(LESS) build/css/style.css
	$(LESSC) --clean-css $(LESS_OPTIONS) $(LESS) build/css/style.min.css
	cp build/css/style*.css htdocs/css/



# target: less-lint          - Lint the less stylesheet.
.PHONY: less-lint
less-lint: less
	@$(call HELPTEXT,$@)
	$(LESSC) --lint $(LESS_OPTIONS) $(LESS) > build/lint/style.less
	- $(STYLELINT) build/css/style.css > build/lint/style.stylelint.css
	ls -l build/lint/



# ------------------------------------------------------------------------
#
# JavaScript
#
.PHONY: js-cs js-lint 
	
# target: js-minify          - Minify JavaScript files to min.js
js-minify: prepare-build
	@$(call HELPTEXT,$@)
	@for file in $(JS_FILES); do \
		filename=$$(basename "$$file"); \
		extension="$${filename##*.}"; \
		filename="$${filename%%.*}"; \
		target="build/js/$${filename}.min.$${extension}"; \
		$(ECHO) "==> Minifying $$file > $$target"; \
		$(JS_MINIFY) $(JS_MINIFY_OPTIONS) --output $$target $$file; \
		$(ECHO) "==> Installing to htdocs/js/$$target"; \
		cp $$target $$file htdocs/js; \
	done

	

#%.min.js: %.js
#	@$(ECHO) '==> Minifying $<'
#	$(JS_MINIFY) $(JS_MINIFY_OPTIONS) --output $@ $<



# target: js-cs              - Check codestyle in javascript files
# js-cs:
# 	@$(call HELPTEXT,$@)
# 	@for file in $(JS_FILES); do \
# 		$(ECHO) "==> JavaScript codestyle $$file"; \
# 		$(JS_CODESTYLE) $(JS_CODESTYLE_OPTIONS) $$file; \
# 	done



# target: js-lint            - Lint javascript files
js-lint:
	@$(call HELPTEXT,$@)
	@for file in $(JS_FILES); do \
		$(ECHO) "==> JavaScript lint $$file"; \
		$(JS_LINT) $(JS_LINT_OPTIONS) $$file; \
	done
