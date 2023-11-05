$(document).ready(function () {


    let option = {
        url: '/api/FileApi/$action',
        validFiles: ['xls', 'xlsb', 'xlsx'],
    }

    UploadFileHelper("uploadBtn", "formFile", function (msg) {
        $("div.alert-success").text(msg).show();
    }, option);

})