var data = [];

for(var i = 0; i<20; i++) {
    /*var num = Math.floor(Math.random() * 50);*/
    var num = Math.floor(d3.randomUniform(1,50)());
    data.push(num);
}


var svg = d3.select('#chart')
    .append('svg')
    .attr('width', 800)
    .attr('height', 400);

svg.selectAll('rect')
    .data(data)
    .enter()
    .append('rect')
    .attr('x', function(d,i){
        return i * 30;
    })
    .attr('y', function(d) {
        return d
    })
    .attr('width', 25)
    .attr('height',100);









