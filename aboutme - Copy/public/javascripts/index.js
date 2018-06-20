

$(function() {

    var width = 720;
    var animationSpeed = 2000;
    var pause = 4000;
    var currentSlide = 1;
    var interval;

    var $slider = $('#slider');
    var $slideContainer = $slider.find('.slides');
    var $slides = $slideContainer.find('.slide');



    function startSlider() {
        interval = setInterval(function () {

            $slideContainer.animate({'margin-left': '-=' + width}, animationSpeed, function () {
                currentSlide++;
                if (currentSlide === $slides.length) {
                    currentSlide = 1;
                    $slideContainer.css('margin-left', 0);
                }
            });
        }, pause);
    }
    function stopSlider() {
        clearInterval(interval);
    }
   startSlider()
   $slider.on('mouseenter', pauseSlider).on('mouseleave', startSlider);

});












