
$(function() {

    // Get the container element
    var btnContainer = document.getElementById("MyNavbar");

    // Get all buttons with class="btn" inside the container
    var btns = btnContainer.getElementsByClassName("mynav");

    // Loop through the buttons and add the active class to the current/clicked button
    for (var i = 0; i < btns.length; i++) {
        btns[i].addEventListener("click", function () {
            console.log(btns[1]);
            var current = document.getElementsByClassName("active");
            current[0].className = current[0].className.replace(" active", "");
            this.className += " active";
        });
    }

});






