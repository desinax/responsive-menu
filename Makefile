#!/usr/bin/make -f
#

# Colors
NO_COLOR		= \033[0m
TARGET_COLOR	= \033[32;01m
OK_COLOR		= \033[32;01m
ERROR_COLOR		= \033[31;01m
WARN_COLOR		= \033[33;01m
ACTION			= $(TARGET_COLOR)--> 
HELPTEXT 		= "$(ACTION)" `egrep "^\# target: $(1) " Makefile | sed "s/\# target: $(1)[ ]\+- / /g"` "$(NO_COLOR)"



# Add local bin path for test tools
BIN 		= bin
VENDORBIN 	= vendor/bin
NPMBIN		= node_modules/.bin

# LESS and CSS
LESS 		 	= src/less/style.less
LESS_MODULES	= src/less/
LESS_OPTIONS 	= --strict-imports --include-path=$(LESS_MODULES)
CSSLINT_OPTIONS = --quiet



# The JavaScript fileset
#
JS_FILES 	= src/js/responsive-menu.js
#JS_MINIFIED = $(JS_FILES:.js=.min.js)



#
# Tool to check and minimize javascript code
#
JS_CODESTYLE 			= jscs
JS_CODESTYLE_OPTIONS 	=

JS_LINT 				= jshint
JS_LINT_OPTIONS 		=

JS_MINIFY 			= uglifyjs
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
	@echo $(call HELPTEXT,$@)
	@echo "Usage:"
	@echo " make [target] ..."
	@echo "target:"
	@egrep "^# target:" Makefile | sed 's/# target: / /g'



# target: clean              - Remove all generated files.
.PHONY:  clean
clean:
	@echo $(call HELPTEXT,$@)
	rm -rf build
	rm -f npm-debug.log



# target: clean-all          - Remove all installed files.
.PHONY:  clean-all
clean-all: clean
	@echo $(call HELPTEXT,$@)
	rm -rf node_modules



# target: prepare-build      - Clear and recreate the build directory.
.PHONY: prepare-build
prepare-build:
	@echo $(call HELPTEXT,$@)
	install -d build/css build/lint build/js



# target: test               - Execute all tests.
.PHONY: test
test: less-lint js-cs js-lint
	@echo $(call HELPTEXT,$@)



# target: build              - Build all files and install in htdocs
.PHONY: build
build: less js-minify
	@echo $(call HELPTEXT,$@)



# ------------------------------------------------------------------------
#
# LESS
#

# target: less               - Compile and minify the stylesheet.
.PHONY: less
less: prepare-build
	@echo $(call HELPTEXT,$@)
	lessc $(LESS_OPTIONS) $(LESS) build/css/style.css
	lessc --clean-css $(LESS_OPTIONS) $(LESS) build/css/style.min.css
	cp build/css/style*.css htdocs/css/



# target: less-lint          - Lint the less stylesheet.
.PHONY: less-lint
less-lint: less
	@echo $(call HELPTEXT,$@)
	lessc --lint $(LESS_OPTIONS) $(LESS) > build/lint/style.less
	- csslint $(CSSLINT_OPTIONS) build/css/style.css > build/lint/style.css
	ls -l build/lint/



# ------------------------------------------------------------------------
#
# JavaScript
#
.PHONY: js-cs js-lint 
	
# target: js-minify          - Minify JavaScript files to min.js
js-minify: prepare-build
	@echo $(call HELPTEXT,$@)
	@for file in $(JS_FILES); do \
		filename=$$(basename "$$file"); \
		extension="$${filename##*.}"; \
		filename="$${filename%%.*}"; \
		target="build/js/$${filename}.min.$${extension}"; \
		echo "==> Minifying $$file > $$target"; \
		$(JS_MINIFY) $(JS_MINIFY_OPTIONS) --output $$target $$file; \
		echo "==> Installing to htdocs/js/$$target"; \
		cp $$target $$file htdocs/js; \
	done

	

#%.min.js: %.js
#	@echo '==> Minifying $<'
#	$(JS_MINIFY) $(JS_MINIFY_OPTIONS) --output $@ $<



# target: js-cs              - Check codestyle in javascript files
js-cs:
	@echo $(call HELPTEXT,$@)
	@for file in $(JS_FILES); do \
		echo "==> JavaScript codestyle $$file"; \
		$(JS_CODESTYLE) $(JS_CODESTYLE_OPTIONS) $$file; \
	done



# target: js-lint            - Lint javascript files
js-lint:
	@echo $(call HELPTEXT,$@)
	@for file in $(JS_FILES); do \
		echo "==> JavaScript lint $$file"; \
		$(JS_LINT) $(JS_LINT_OPTIONS) $$file; \
	done
	@echo



# ------------------------------------------------------------------------
#
# Local test environment
#
# target: npm-install-dev    - Install npm packages for development.
.PHONY: npm-install-dev
npm-install-dev:
	@echo "$(ACTION)Install npm packages for development$(NO_COLOR)"
	npm install --only=dev



# target: npm-update-dev     - Update npm packages for development.
.PHONY: npm-update-dev
npm-update-dev:
	@echo "$(ACTION)Update npm packages for development$(NO_COLOR)"
	npm update --only=dev



# target: automated-tests-prepare - Prepare for automated tests.
.PHONY: automated-tests-prepare
automated-tests-prepare: npm-install-dev
	@echo "$(ACTION)Prepared for automated tests$(NO_COLOR)"



# target: automated-tests-check   - Check version and enviroment for automated tests.
.PHONY: automated-tests-check
automated-tests-check:
	@echo "$(ACTION)Check version and environment for automated tests$(NO_COLOR)"
	
	npm list



# target: automated-tests-run     - Run all automated tests.
.PHONY: automated-tests-run
automated-tests-run: test
	@echo "$(ACTION)Executed all automated tests$(NO_COLOR)"
