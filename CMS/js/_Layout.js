let modal = null;

let spinner = function () {
    setTimeout(function () {
        if ($('#spinner').length > 0) {
            $('#spinner').removeClass('show');
        }
    }, 1);
};

(function ($) {

    spinner();
    // Sidebar Toggler
    $('.sidebar-toggler').click(function () {
        $('.sidebar, .content').toggleClass("open");
        return false;
    });

    $("a[source='server'][href!='#']").click(function (e) {
        e.preventDefault();

        let urlString = $(this).attr("href");
        $.ajax({
            url: urlString,
            type: 'GET',
            success: function (result) {
                $("#RenderBody").html("");
                $("#RenderBody").html(result);
            }
        });
    });





})(jQuery);
