#
	
#
# The fileset
#
JS_FILES 	= responsive-menu.js
JS_MINIFIED = $(JS_FILES:.js=.min.js)

LESS_FILES 		= responsive-menu.less
LESS_COMPILED 	= $(LESS_FILES:.less=.css)
LESS_MINIFIED 	= $(LESS_FILES:.less=.min.css)

HTML_FILES	= $(wildcard *.html)



#
# Tool to compile and minify less code
#
LESS_COMPILE			= lessc
LESS_COMPILE_OPTIONS 	= 

LESS_MINIFY				= $(LESS_COMPILE)
LESS_MINIFY_OPTIONS 	= --clean-css

LESS_LINT				= $(LESS_COMPILE)
LESS_LINT_OPTIONS 		= --lint



#
# Tool to minimize javascript code
#
JS_MINIFY 			= uglifyjs
JS_MINIFY_OPTIONS 	= --mangle --compress --screw-ie8 --comments



#
# Tool to lint HTML code
#
HTML_LINT 			= htmlhint
HTML_LINT_OPTIONS 	= 



# ------------------------------------------------------------------------
#
# General and combined targets
#

# target: all - Default target, run tests and build
all: test build


# target: test - Do all tests
test: jscs jshint less-lint html-lint



# target: build - Do all build
build: less-compile less-minify js-minify



# target: clean - Removes generated files and directories.
clean:
	@echo "Target clean not implemented."
	#rm -f $(CSS_MINIFIED) $(JS_MINIFIED)



# target: help - Displays help.
help:
	@echo "make [target] ..."
	@echo "target:"
	@egrep "^# target:" Makefile | sed 's/# target: / /g'



# ------------------------------------------------------------------------
#
# LESS
#

# target: less-compile - Compile LESS to CSS
less-compile: $(LESS_FILES) $(LESS_COMPILED)

%.css: %.less
	@echo '==> LESS compiling $<'
	$(LESS_COMPILE) $(LESS_COMPILE_OPTIONS) $< $@ 



# target: less-minify - Minify LESS files to min.css
less-minify: $(LESS_FILES) $(LESS_MINIFIED)

%.min.css: %.less
	@echo '==> LESS minifying $<'
	$(LESS_MINIFY) $(LESS_MINIFY_OPTIONS) $< $@



# target: less-lint - Lint LESS files
less-lint: $(LESS_FILES)
	@echo '==> LESS linting $<'
	$(LESS_LINT) $(LESS_LINT_OPTIONS) $<



# ------------------------------------------------------------------------
#
# JavaScript
#

# target: js-minify - Minify JavaScript files to min.js
js-minify: $(JS_FILES) $(JS_MINIFIED)

%.min.js: %.js
	@echo '==> Minifying $<'
	$(JS_MINIFY) $(JS_MINIFY_OPTIONS) --output $@  $<



# target: jscs - Check codestyle in javascript files
jscs: $(JS_FILES)
	@echo '==> Check JavaScript codestyle'
	jscs $(JS_FILES)



# target: jshint - Lint javascript files
jshint: $(JS_FILES)
	@echo '==> Check JavaScript linter'
	jshint $(JS_FILES)



# ------------------------------------------------------------------------
#
# HTML
#
.PHONY:	html-lint

# target: html-lint - Lint HTML files
html-lint:
	@for file in $(HTML_FILES); do \
		echo -n "==> HTML linting $$file"; \
		$(HTML_LINT) $(HTML_LINT_OPTIONS) $@ | grep -v "Config loaded: "; \
	done
