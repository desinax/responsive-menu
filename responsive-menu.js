var menuButton = document.getElementById("menu-button");
var menu = document.getElementById("large");

menuButton.addEventListener("click", function(event) {

    var style = window.getComputedStyle(menu);

    console.log("Click: " + style.display);

    if (style.display === "none") {
        menu.classList.toggle("mobile");
        menu.classList.toggle("desktop");
        menuButton.classList.toggle("clicked");
        menu.style.display = "block";
    } else {
        menu.style.display = "none";
        menu.classList.toggle("mobile");
        menu.classList.toggle("desktop");
        menuButton.classList.toggle("clicked");
    }

/*
    menuButton.classList.toggle("clicked");
    menu.classList.toggle("desktop");
    menu.classList.toggle("mobile");
*/
    event.preventDefault();
});

window.addEventListener("resize", function() {
    console.log("resize");
    menu.style.display = "";
    menu.classList.remove("mobile");
    menu.classList.add("desktop");
    menuButton.classList.remove("clicked");
});
