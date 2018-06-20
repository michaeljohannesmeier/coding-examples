
$(function() {
    console.log();
    // Get the container element
    var btnContainer = document.getElementById("MyNavbar");

    // Get all buttons with class="btn" inside the container
    var btns = btnContainer.getElementsByClassName("mynav");
    console.log(btns);
    // Loop through the buttons and add the active class to the current/clicked button
    for (var i = 0; i < btns.length; i++) {
        //console.log(btns[1]);
        btns[i].addEventListener("click", function () {
            //console.log(btns[1]);
            var current = document.getElementsByClassName("active");
            console.log(current);
            current[0].className = current[0].className.replace("active", "");
            console.log(this);
            this.className += " active";
        });
    }
});



