$(document).ready(function () {

    let table = null;
    let containerId = "dt-container";
    let url = `/api/DataApi/GetFAQs`;
    function editView(rowId) {
        var url = `/WebContents/FAQEdit?id=${rowId}`;
        $.ajax({
            url: url,
            type: 'Get',
            success: function (result) {
                modal = new Modal({
                    "title": "修改",
                    noBtnLabel: "取消",
                    yesBtnLabel: "更新",
                    description: "",
                    yesCallback: editYesCallback(rowId),
                    bodyHtml: result,
                });
                modal.show();
            }
        });
    }

    function editYesCallback(rowId) {
        return function (callbackFunc) {
            var key = "faqFormId";
            var formData = formHelper.getFormData(key);
            formData["Id"] = rowId;
            $.ajax({
                url: "/api/DataApi/UpdateFAQ",
                type: 'POST',
                data: formData,
                success(result) {
                    var isSuccess = result.success || result.IsSuccess;
                    if (!isSuccess) {
                        var oError = getErrorObject(result);
                        formHelper.setErrorMessage(key, oError);
                    } else {
                        updateTable();
                        callbackFunc(result.success);
                    }
                }
            });
        };
    }

    function getErrorObject(result) {
        if (result.error != null) return JSON.parse(result.error);
        return { "error": result.ErrorMessage };
    }


    function deleteView(rowId) {
        let deleteUrl = `/api/DataApi/DeleteFAQ`;
        modal = new Modal({
            "title": "",
            description: "",
            yesCallback: GetSaveFunc(deleteUrl, "", { Id: rowId }),
            bodyHtml: "<div><p>是否刪除該筆資料？</p></div>",
        });
        modal.show();
    }



    function bindEvent() {
        let modal = null;
        function GetUploadModalConfig(body) {
            return {
                yesCallback: function () {


                },
                closeCalback: function () {
                    modal = null;
                },
                bodyHtml: body
            };
        }

        $("button#addFAQ").on('click', function () {
            let url = `/WebContents/FAQsCreate`;
            let createUrl = `/api/DataApi/CreateFAQ`;
            let key = "faqFormId";
            $.ajax({
                url: url,
                type: 'GET',
                success: function (result) {
                    let config = GetUploadModalConfig(result);
                    config.title = "新增常見問答";
                    config.yesCallback = GetSaveFunc(createUrl, key);
                    modal = new Modal(config);
                    modal.show();
                }
            });
        });

        $("button#addFAQs").on('click', function () {
            let title = "匯入Excel檔案";
            let path = "";
            let d_source = "UploadFAQs";
            let url = `/WebContents/UploadFile?title=${title}&path=${path}&act=${d_source}`;
            $.ajax({
                url: url,
                type: 'GET',
                success: function (result) {
                    let config = GetUploadModalConfig(result);
                    config.yesCallback = null;
                    config.onlyDisplayCancel = true;
                    modal = new Modal(config);
                    modal.show();
                }
            });
        });
    };


    function GetSaveFunc(urlStr, key, data) {
        return function (callbackFunc) {
            var formData = data || formHelper.getFormData(key);
            $.ajax({
                url: urlStr,
                type: 'POST',
                data: formData,
                success(result) {
                    var isSuccess = result.success || result.IsSuccess;
                    if (!isSuccess) {
                        var oError = getErrorObject(result);
                        formHelper.setErrorMessage(key, oError);
                    } else {
                        updateTable();
                        callbackFunc(result.success);
                    }
                }
            });
        };
    }

    function GetTableOption() {
        return {
            isEditType: true,
            editCallback: editView,
            deleteCallback: deleteView,
            selectRow: true,
            scrollX: true, // 启用水平滚动
            scrollY: "60vh",    // 启用垂直滚动，并设置高度
            columns: [
                {
                    field: '',
                    title: '類型',
                    render: function (data, type, row) {
                        return row.CategoryName;
                    }
                },
                { field: 'Question', title: '問題', width: '280px' },
                { field: 'Answer', title: '回答', width: '420px' },
                { field: 'DisplayOrder', title: '排序' },
                {
                    field: 'UpdatedDate',
                    title: '最後更新時間',
                    render: function (data, type, row) {
                        return dateHelper.toString(data);
                    } }
            ],
            columnDefs: [
                { className: 'truncate-text', targets: [2] }
            ],
        };
    }

    function getSearchData() {
        return {
            Type: $("#typesDDL").val(),
            SearchValue: $("#search-Value").val(),
        };
    }

    function updateTable() {
        if (table == null) return;
        var searchData = getSearchData();
        table.updateData(searchData);
    }

    function init() {
        $("#search-btn").on('click', function () {
            updateTable();
        });

        var searchData = getSearchData();
        let option = GetTableOption();
        table = new TableHelper(containerId, searchData, option, url);

        bindEvent();
    }

    init();
});