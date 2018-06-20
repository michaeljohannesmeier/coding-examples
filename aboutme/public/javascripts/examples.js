

var descriptionExample = [
    "The Fruits page is a single page application programmed in Angular. There is no database connection. The page shows styling and animation.",
    "The Angular Recipes page is a single page application programmed in Angular. It is to the backend connected to a MongoDB database" +
        " where data is queried and stored via a REST Api.",
    "The Angular Bikes page is a single page application programmed in Angular. Similar to the Recipes Page it is to the backend connected to a MongoDB database" +
    " where data is queried and stored via a REST Api.",
    "The Internet Shop page site is running with NodeJs and MongoDB on the backend and with the view engine handlebars " +
        "as well as with Javascript and JQuery on the client side.",
    "The World Bank Data Visualizer is running with NodeJs and JQuery using Ajax requests to get data over the REST Api " +
        "of the world bank page. The page is currently under construction so that the page is not visitable at the moment.",
    "The Pig Game site is a web site entirely programmed with pure Javascript.",
    "The Data Visualization Tool site is a R-Shiny app hosted on a R-Shiny server. The app calculates several statistical measures and " +
        "shows visualisation techniques with the charting library plotly.",
    "The Budget Calculator page is a site based on pure Javascript code.",
    "The Gym Page site is a site without interactions or databases. It will show the styling possibilities with pure css."
];

var hrefs = [
    "/fruits",
    "/recipe",
    "/bikes",
    "/shoppingcart",
    "",
    "/piggame",
    "https://michaelmeier.shinyapps.io/datavisualization/",
    "/budgetcalc",
    "/thegym",

]


$(function() {

    $('.aTagsExamplepages').on('click', function() {
        var numObject = $(this).attr('id');
        $('#headlineexamplesDescription').text("Description:");
        $('#examplesDescription').text(descriptionExample[numObject]);
        if (numObject == 4){
            $('#buttonPageDescription').html('');
        } else {
            $('#buttonPageDescription').html('<a href="' + hrefs[numObject] + '"><button type="button" class="btn btn-default btn-xs">Visit page</button></a>');
        }
    });

});







