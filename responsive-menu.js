/**
 * Get the items needed for the menu to work.
 */
(function() {
    "use strict";

    var menuButton = document.getElementById("rm-menu-button");
    var menu = document.getElementById("large");
    var submenus = document.getElementsByClassName("rm-submenu");


    /**
     * Show the submenu
     */
    var showSubmenu = function(event) {
        console.log("Show submenu");

        if (this.parentNode.classList.contains("rm-desktop")) {
            // This should not use the click event
            console.log("Cancel show submenu");

            //event.preventDefault();
            //event.stopPropagation();

            return;
        }

        this.classList.toggle("rm-submenu-open");
        this.querySelector("ul").classList.toggle("rm-show-submenu");

        //event.preventDefault();
        //event.stopPropagation();
    };



    /**
     * Add eventlisteners for each li holding a submenu
     */
    Array.prototype.filter.call(submenus, function(element) {
        element.addEventListener("click", showSubmenu);
        console.log("found submenu");
    });



    menuButton.addEventListener("click", function(event) {

        var style = window.getComputedStyle(menu);

        console.log("Click: " + style.display);

        if (style.display === "none") {
            menu.classList.toggle("rm-mobile");
            menu.classList.toggle("rm-desktop");
            menuButton.classList.toggle("clicked");
            menu.style.display = "block";
        } else {
            menu.style.display = "none";
            menu.classList.toggle("rm-mobile");
            menu.classList.toggle("rm-desktop");
            menuButton.classList.toggle("clicked");
        }

        event.preventDefault();
        event.stopPropagation();
    });



    var clearMenu = function (event) {
        console.log("Clear menu");
        menu.style.display = "";
        menu.classList.remove("rm-mobile");
        menu.classList.add("rm-desktop");
        menuButton.classList.remove("clicked");
        event.preventDefault();
    };

    window.addEventListener("resize", clearMenu);
    //document.addEventListener("click", clearMenu);

})();
