var xhttp = new XMLHttpRequest();

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
        var select = $('<select id="selectCountriesSelect" multiple class="demo-default" style="width:20%" placeholder="Select a state...">');
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