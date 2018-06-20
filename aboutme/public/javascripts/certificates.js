$(function() {
    $('.lineAndTextCert').hide(2000);
    $('.headCert').on('click', function() {
        var numObject = $(this).attr('id');
        $('#objectCert' + numObject).slideToggle(200);
    });
    $('.headCert').on('mouseover', function() {
        var numObject = $(this).attr('id');
        $('#' + numObject).css('color', '#fffd3b');
    });
    $('.headCert').on('mouseleave', function() {
        var numObject = $(this).attr('id');
        $('#' + numObject).css('color','#7337b4');
    });
});