$(function() {
    $('.lineAndTextCv').hide(2000);
    $('.headCv').on('click', function() {
        var numObject = $(this).attr('id');
        $('#object' + numObject).slideToggle(200);
    });
    $('.headCv').on('mouseover', function() {
        var numObject = $(this).attr('id');
        $('#' + numObject).css({color: 'grey'});
    });
    $('.headCv').on('mouseleave', function() {
        var numObject = $(this).attr('id');
        $('#' + numObject).css({color: 'black'});
    });
});