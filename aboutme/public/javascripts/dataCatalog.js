var xhttp = new XMLHttpRequest();
var xhttpIndicators = new XMLHttpRequest();
/*
xhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {

        var parsedCounries = JSON.parse(this.responseText)[1];
        console.log(parsedCounries);
        var countries = {
            id: [],
            names: []
        };
        parsedCounries.forEach(function(e){
            countries.id.push(e.id)
            countries.names.push(e.name)

        });
        console.log(countries);
        var select = $('<select id="selectCountriesSelect" multiple class="demo-default" style="width:100%" placeholder="Select countries ...">');
        for (i = 0; i < countries.id.length; i++) {
            var option = $('<option></option>');
            option.attr('value', countries.id[i]);
            option.text(countries.names[i]);
            select.append(option);
        };
        $('#selectCountriesDiv').empty().append(select);
        $('#selectCountriesSelect').selectize({
            maxItems: 5
        });

    }
};
xhttp.open("GET", "http://api.worldbank.org/v2/countries?per_page=500&format=json", true);
xhttp.send();

/*
xhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {

        var parsedIndicators = JSON.parse(this.responseText)[1];
        console.log(parsedIndicators);

        var indicators = {
            id: [],
            names: []
        };
        parsedIndicators.forEach(function(e){
            indicators.id.push(e.id)
            indicators.names.push(e.name)

        });

        var select = $('<select id="selectIndicatorSelect" multiple class="demo-default" style="width:100%" placeholder="Select indicator ...">');
        for (i = 0; i < indicators.id.length; i++) {
            var option = $('<option></option>');
            option.attr('value', indicators.id[i]);
            option.text(indicators.names[i]);
            select.append(option);
        };
        $('#selectIndicatorDiv').empty().append(select);
        $('#selectIndicatorSelect').selectize({
            maxItems: 1
        });

    }

};
xhttp.open("GET", "http://api.worldbank.org/v2/indicators?per_page=50000&format=json", true);
xhttp.send();
*/