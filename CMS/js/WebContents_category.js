$(document).ready(function () {

    let table = null;
    let url = `/api/DataApi/GetCategories`;


    function editView(rowId) {
        var url = `/WebContents/CategoryEdit?id=${rowId}`;
        $.ajax({
            url: url,
            type: 'GET',
            success: function (result) {
                modal = new Modal({
                    "title": "修改",
                    noBtnLabel: "取消",
                    yesBtnLabel: "更新",
                    description: "",
                    yesCallback: editYesCallback(rowId),
                    bodyHtml: result
                });
                modal.show();
            }
        });
    }

    function editYesCallback(rowId) {
        return function (callbackFunc) {
            var formData = formHelper.getFormData('categoryFormId');
            formData["Id"] = rowId;
            $.ajax({
                url: "/api/DataApi/UpdateCategory",
                type: 'POST',
                data: formData,
                success(result) {
                    var isSuccess = result.success || result.IsSuccess;
                    if (!isSuccess) {
                        var oError = getErrorObject(result);
                        formHelper.setErrorMessage('categoryFormId', oError);
                    } else {
                        updateTable();
                        callbackFunc(isSuccess);
                    }
                }
            });

        };
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

        $("button#addCategory").on('click', function () {
            let url = `/WebContents/CategoryCreate`;
            let createUrl = `/api/DataApi/CreateCategory`;
            let key = "categoryFormId";
            $.ajax({
                url: url,
                type: 'GET',
                success: function (result) {
                    let config = GetUploadModalConfig(result);
                    config.yesCallback = GetSaveFunc(createUrl, key);
                    config.title = "新增類別";
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

    function getErrorObject(result) {
        if (result.error != null) return JSON.parse(result.error);
        return { "error": result.ErrorMessage };
    }


    function deleteView(rowId) {//todo delete
        let deleteUrl = `/api/DataApi/DeleteCategory`;
        modal = new Modal({
            "title": "",
            description: "",
            yesCallback: GetSaveFunc(deleteUrl, "", { Id: rowId }),
            bodyHtml: "<p>是否刪除該筆資料？</p>",
        });
        modal.show();
    }

    function GetTableOption() {
        return {
            isEditType: true,
            editCallback: editView,
            deleteCallback: deleteView,
            selectRow: true,
            columns: [
                {
                    field: 'Type', title: '類型', width: "150px",
                },
                { field: 'Name', title: '名稱' },
                { field: 'Description', title: '描述', width: "350px" },
                { field: 'DisplayOrder', title: '排序' },
            ]
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
        table = new TableHelper("dt-container", searchData, option, url);

        bindEvent();
    }

    init();
})