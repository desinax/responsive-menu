#
# less
#
.PHONY: less

less:
	lessc --clean-css responsive-menu.less responsive-menu.min.css
	lessc responsive-menu.less responsive-menu.css
