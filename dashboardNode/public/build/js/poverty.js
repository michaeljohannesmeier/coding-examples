$(".myCardInfo").hover( function(){
    $(this).children("#cardfront").animate({top: '0%'}, 200);
    $(this).children("#cardfront").animate({fontSize: '15px'}, 500);
    $(this).children("#cardhidden").fadeIn(3000);
});



var data = [];

for(var i = 0; i < 20; i++) {
    //var num = Math.floor(Math.random() * 50);
    var num = Math.floor(d3.randomUniform(1, 50)());
    data.push(num);
}

var chart_width = 800;
var chart_height = 400;
var bar_padding = 5;

var svg = d3.select('#chart')
    .append('svg')
    .attr('width', chart_width)
    .attr('height', chart_height);

var x_scale = d3.scaleBand()
    .domain(d3.range(data.length))
    .rangeRound([0, chart_width])
    .paddingInner(0.05);

var y_scale = d3.scaleLinear()
    .domain([0, d3.max(data)])
    .range([0, chart_height]);




svg.selectAll('rect')
    .data(data)
    .enter()
    .append('rect')
    .attr('x', function(d, i) {
        return x_scale(i);
    })
    .attr('y', function(d) {
        return chart_height - y_scale(d)
    })
    .attr('width', x_scale.bandwidth() )
    .attr('height', function(d) {
        return y_scale(d)
    })
    .attr('fill', '#7ED26D');


svg.selectAll('text')
    .data(data)
    .enter()
    .append('text')
    .text(function(d) {
        return d
    })
    .attr('x', function(d, i) {
        return x_scale(i) + x_scale.bandwidth() / 2;
    })
    .attr('y', function(d) {
        return chart_height - y_scale(d) + 15;
    })
    .attr('font-size', 14)
    .attr('fill', '#FFF')
    .attr('text-anchor', 'middle');

d3.select('#myButtonUpdateSVG').on('click', function() {
   //data.reverse();
    data[0] = 100;
    y_scale.domain([0,d3.max(data)]);

   svg.selectAll('rect')
       .data(data)
       .transition()
       .duration(1000)
       .delay(function(d,i){
           return i /data.length * 1000
       })
       //.ease(d3.easeElasticOut)
       .attr('y', function(d) {
           return chart_height - y_scale(d)
       })
       .attr('x', function(d, i) {
           return x_scale(i);
       })
       .attr('height', function(d) {
           return y_scale(d)
       });

    svg.selectAll('text')
        .data(data)
        .transition()
        .delay(function(d,i){
            return i /data.length * 1000
        })
        .duration(1000)
        //.ease(d3.easeElasticOut)
        .text(function(d) {
            return d
        })
        .attr('x', function(d, i) {
            return x_scale(i) + x_scale.bandwidth() / 2;
        })
        .attr('y', function(d) {
            return chart_height - y_scale(d) + 15;
        });


});

/*


d3.select('#myButtonAddSVG').on('click', function() {
   var new_num = Math.floor(Math.random() * d3.max(data));
   data.push(new_num);

    x_scale.domain(d3.range(data.length));
    y_scale.domain([0, d3.max(data, function(d) {
        return d
    })]);

    var bars = svg.selectAll('rect').data(data);

    bars.enter()
        .append('rect')
        .attr('x', function(d, i) {
            return x_scale(i);
        })
        .attr('width', x_scale.bandwidth())
        .attr('height', 0)
        .attr('fill', '#7ED26D')
        .merge(bars)
        .transition()
        .duration(1000)
        .attr('x', function(d, i) {
            return x_scale(i);
        })
        .attr('y', function(d) {
            return chart_height - y_scale(d)
        })
        .attr('width', x_scale.bandwidth() )
        .attr('height', function(d) {
            return y_scale(d)
        })

    var labels = svg.selectAll('text').data(data);

    labels.enter()
        .append('text')
        .text(function(d) {
            return d;
        })
        .attr('x', function(d, i) {
            return x_scale(i) + x_scale.bandwidth() /2;
        })
        .attr('y', chart_height)
        .attr("font-size", "14px")
        .attr('fill', '#fff')
        .attr("text-anchor", "middle")
        .merge(labels)
        .transition()
        .duration(1000)
        .attr('x', function(d,i) {
            return x_scale(i) + x_scale.bandwidth()/2
        })
        .attr('y', function(d){
            return chart_height - y_scale(d) + 15
        })

});


*/



// ------------------------- childPov -----------------



var svg = d3.select("svg"),
    margin = {top: 20, right: 20, bottom: 30, left: 40},
    width = +svg.attr("width") - margin.left - margin.right,
    height = +svg.attr("height") - margin.top - margin.bottom;

var x = d3.scaleBand().rangeRound([0, width]).padding(0.1),
    y = d3.scaleLinear().rangeRound([height, 0]);

var g = svg.append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")")
    .attr('class', 'transformer');

var data = [
    {
        "letter": "A",
        "frequency": ".08167"
    },
    {
        "letter": "B",
        "frequency": ".01492"
    },
    {
        "letter": "C",
        "frequency": ".02782"
    }
    ];
    x.domain(data.map(function(d) { return d.letter; }));
    y.domain([0, d3.max(data, function(d) { return d.frequency; })]);

    g.append("g")
        .attr("class", "axis axis--x")
        .attr("transform", "translate(0," + height + ")")
        .call(d3.axisBottom(x));

    g.append("g")
        .attr("class", "axis axis--y")
        .call(d3.axisLeft(y).ticks(10, "%"))
        .append("text")
        .attr("transform", "rotate(-90)")
        .attr("y", 6)
        .attr("dy", "0.71em")
        .attr("text-anchor", "end")
        .text("Frequency");

    g.selectAll(".bar")
        .data(data)
        .enter().append("rect")
        .attr("class", "bar")
        .attr("x", function(d) { return x(d.letter); })
        .attr("y", function(d) { return y(d.frequency); })
        .attr("width", x.bandwidth())
        .attr("height", function(d) { return height - y(d.frequency); });


d3.selectAll('#text1')
    .attr("font-size", "40px")
    .text("first this")
    .attr("fill", "red");

var myCounter = 1;

d3.select('#myButtonAddSVG').on('click', function() {
    if(myCounter == 1){
        $(".containerTextAnimation").css("display", "block");
        $(".titleTextAnimation").lettering();
        animation();
        myCounter += 1;
    } else if (myCounter > 1 && myCounter < 4) {

        if (myCounter == 2) {
            var newData = {
                "letter": "D",
                "frequency": ".09"
            };
            $("#titleAnimationSpan1").text("2 billion");
            $("#titleAnimationSpan2").text("of them");
            $("#titleAnimationSpan3").text("live in poverty");
        }
        if (myCounter == 3) {
            newData = {
                "letter": "E",
                "frequency": ".07"
            };
            $("#titleAnimationSpan1").text("1 billion");
            $("#titleAnimationSpan2").text("of them dont ");
            $("#titleAnimationSpan3").text("have a shelter");
        }
        data.push(newData);
        x.domain(data.map(function (d) {
            return d.letter;
        }));
        y.domain([0, d3.max(data, function (d) {
            return d.frequency;
        })]);

        var transformer = svg.selectAll('.transformer');
        var bars = transformer.selectAll('rect').data(data);
        bars.enter()
            .append('rect')
            .attr('x', function (d, i) {
                return x(d.letter);
            })
            .attr('width', x.bandwidth())
            .attr('height', 0)
            .attr("class", "bar")
            .merge(bars)
            .attr("class", "bar")
            .transition()
            .duration(1000)
            .attr('x', function (d, i) {
                return x(d.letter);
            })
            .attr('y', function (d) {
                return y(d.frequency)
            })
            .attr('width', x.bandwidth())
            .attr('height', function (d) {
                return height - y(d.frequency)
            });

        var xAxis = transformer.selectAll('.axis--x');

        xAxis
            .transition()
            .duration(1000)
            .call(d3.axisBottom(x));


        $(".titleTextAnimation").lettering();
        animation();



        myCounter += 1;
    }
});

function animation() {
    console.log("executing animation function");
    var title1 = new TimelineMax();
    title1.staggerFromTo(".titleTextAnimation span", 0.5,
        {ease: Back.easeOut.config(1.7), opacity: 0, bottom: -80},
        {ease: Back.easeOut.config(1.7), opacity: 1, bottom: 0}, 0.05);
}





















var data2 = [3, 1.9];

var chart_width2 = 800;
var chart_height2 = 400;
var bar_padding2 = 5;
var margin = 0;


var x_scale2 = d3.scaleBand()
    .domain(d3.range(data2.length))
    .rangeRound([0, chart_width2])
    .paddingInner(0.05);

var y_scale2 = d3.scaleLinear()
    .domain([0, d3.max(data2)])
    .range([0, chart_height2 -100]);



var svg2 = d3.select('#childPov')
    .append('svg')
    .attr('width', chart_width2)
    .attr('height', chart_height2);


svg2.selectAll('rect')
    .data(data2)
    .enter()
    .append('rect')
    .attr('x', function(d, i) {
        return x_scale2(i);
    })
    .attr('y', function(d) {
        return chart_height2 - y_scale2(d)
    })
    .attr('width', chart_width2 / data2.length - bar_padding2)
    .attr('height', function(d) {
        return y_scale2(d)
    })
    .attr('fill', '#7ED26D');



var xAxis = d3.axisBottom(x_scale2);

var xAxisTranslate = chart_height2/2 + 10;
svg2.append("g")
    .attr("transform", "translate(0," + xAxisTranslate + ")")
    .call(xAxis);




d3.select('#myButtonUpdateSVG2').on('click', function() {
    data2.push(100);

    x_scale2.domain(d3.range(data2.length));
    y_scale2.domain([0, d3.max(data2, function(d) {
        return d
    })]);

    var bars = svg2.selectAll('rect').data(data2);

    bars.enter()
        .append('rect')
        .attr('x', function(d, i) {
            return x_scale2(i);
        })
        .attr('width', x_scale2.bandwidth())
        .attr('height', 0)
        .attr('fill', '#7ED26D')
        .merge(bars)
        .transition()
        .duration(1000)
        .attr('x', function(d, i) {
            return x_scale2(i);
        })
        .attr('y', function(d) {
            return chart_height2 - y_scale2(d)
        })
        .attr('width', x_scale2.bandwidth() )
        .attr('height', function(d) {
            return y_scale2(d)
        })

});



