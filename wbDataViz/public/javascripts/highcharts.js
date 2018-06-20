
myHChartFunction = function (data, allCountryNames, allCountryIds, dates) {

    var customSeries = [];
    for (i = 0; i < allCountryIds.length; i++) {
        customSeries[i] = {
            name: allCountryNames[i],
            data: data[allCountryIds[i]].reverse()
        }
    }
    console.log(customSeries);
    console.log("testinsidehighcharter");

    var customXAxis = ["2000", "2001", "2002", "2003"];

    Highcharts.chart('hchartsContainer1', {


        title: {
            text: 'Solar Employment Growth by Sector, 2010-2016'
        },

        subtitle: {
            text: 'Source: thesolarfoundation.com'
        },

        yAxis: {
            title: {
                text: 'Number of Employees'
            }
        },

        xAxis: {
            categories:  dates
        },

        legend: {
            layout: 'vertical',
            align: 'right',
            verticalAlign: 'middle'
        },


        series: customSeries,

        responsive: {
            rules: [{
                condition: {
                    maxWidth: 500
                },
                chartOptions: {
                    legend: {
                        layout: 'horizontal',
                        align: 'center',
                        verticalAlign: 'bottom'
                    }
                }
            }]
        }

    });
}