var containers = ['container1', 'container2', 'container3'];
var stopLevels = ['', '0.9', '0.7', '0.5','0.9', '0.7', '0.5', '0.6', '0.9', '0.7', '0.5', '0.6',
    '0.7', '0.9', '0.7', '0.5','0.9', '0.7', '0.5', '0.6', '0.9', '0.7', '0.5', '0.6', '0.7', '0.8', '0.8'];
for (i=1; i<=26; i++) {
    var bar = new ProgressBar.Line(eval('container'+i), {

        strokeWidth: 20,
        easing: 'easeInOut',
        duration: 1400,
        color: '#428bca',
        trailColor: '#eee',
        trailWidth: 1,
        svgStyle: {width: '100%', height: '100%'}
    });
    bar.animate(stopLevels[i]);  // Number from 0.0 to 1.0
}