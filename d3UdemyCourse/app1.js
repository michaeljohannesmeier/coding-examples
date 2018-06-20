d3.csv( 'data.csv').then(function( data ){
    //generate( data.columns );
});

d3.json( 'data.json').then(function( data ){
    generate( data )
});


function generate( dataset ) {
    var el     =       d3.select( 'body' )
        .selectAll( 'p')
        .data( dataset )
        .enter()
        .append( 'p')
        .text(function( d ) {
            return 'This p is binded to number ' + d
        })

}
