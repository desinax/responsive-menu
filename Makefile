#
JS_BASENAME := responsive-menu
JS_FILE 	:= $(JS_BASENAME).js
STYLESHEET 	:= responsive-menu



#
# all
#
all: test build



#
# less
#
.PHONY: less

less:
	lessc --clean-css $(STYLESHEET).less $(STYLESHEET).min.css
	lessc $(STYLESHEET).less $(STYLESHEET).css



#
# uglifyjs
#
.PHONY: uglifyjs

UGLIFYJS_OPTIONS := "--mangle --compress --screw-ie8 --comments"

uglifyjs:
	uglifyjs $(UGLIFYJS_OPTIONS) --output $(JS_BASENAME).min.js $(JS_FILE)



#
# jscs
#
.PHONY: jscs

jscs:
	jscs $(JS_FILE)



#
# jshint
#
.PHONY: jshint

jshint:
	jshint $(JS_FILE)



#
# test
#
.PHONY: test

test: jscs jshint



#
# build
#
.PHONY: build

build: less uglifyjs
