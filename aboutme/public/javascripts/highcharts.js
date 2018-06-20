
myHChartFunction = function (data, allCountryNames, allCountryIds, dates, dateFrom, dateTo) {

    var customSeries = [];
    for (i = 0; i < allCountryIds.length; i++) {
        customSeries[i] = {
            name: allCountryNames[i],
            data: data[allCountryIds[i]]
        }
    }
    var mytext = "Poplulaton " + dateFrom + ":" + dateTo;

    Highcharts.chart('hchartsContainer1', {


        title: {
            text: mytext
        },

        subtitle: {
            text: 'Source: www.worldbank.org'
        },

        yAxis: {
            title: {
                text: 'Population'
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