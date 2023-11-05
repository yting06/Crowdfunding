$(document).ready(function () {

    let table = null;
    let url = `/api/DataApi/GetManagers`;
    function editView(rowId) {
        var url = `/Manager/Edit?id=${rowId}`;
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
                    closeCallback: function () { modal = null; },
                    bodyHtml: result,
                });
                modal.show();
            }
        });

    }

    function editYesCallback(rowId) {
        return function (callbackFunc) {
            var key = "managerFormId";
            var formData = formHelper.getFormData(key);
            formData["Id"] = rowId;
            $.ajax({
                url: "/api/DataApi/UpdateManager",
                type: 'POST',
                data: formData,
                success(result) {
                    var isSuccess = result.success || result.IsSuccess;
                    if (!isSuccess) {
                        var oError = getErrorObject(result);
                        formHelper.setErrorMessage(key, oError);
                    } else {
                        updateTable();
                        callbackFunc(isSuccess);
                    }
                }
            });
        };
    }

    function bindEvent() {
        let btnModal = null;
        function GetUploadModalConfig(body, saveFunc) {
            return {
                yesCallback: function () {
                },
                closeCallback: function () {
                    btnModal = null;
                },
                bodyHtml: body
            };
        }

        $("button[control-act='importExcel']").on('click', function () {
            let title = "匯入Excel檔案";
            let path = "";
            let d_source = "UploadManagers";
            let url = `/WebContents/UploadFile?title=${title}&path=${path}&act=${d_source}`;
            $.ajax({
                url: url,
                type: 'GET',
                success: function (result) {
                    let config = GetUploadModalConfig(result);
                    config.yesCallback = GetSaveFunc();
                    config.title = "增加多位使用者";
                    btnModal = new Modal(config);
                    btnModal.show();
                }
            });
        });
        $("button#addUser").on('click', function () {
            let url = `/Manager/Create`;
            let createUrl = `/api/DataApi/CreateManager`;
            let key = "managerFormId";
            $.ajax({
                url: url,
                type: 'GET',
                success: function (result) {
                    let config = GetUploadModalConfig(result);
                    config.yesCallback = GetSaveFunc(createUrl, key);
                    config.title = "新增使用者";
                    btnModal = new Modal(config);
                    btnModal.show();
                }
            });
        });

        function GetSaveFunc(urlStr, key) {
            return function (callbackFunc) {
                var formData = formHelper.getFormData(key);
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
    };

    function getErrorObject(result) {
        if (result.error != null) return JSON.parse(result.error);
        return { "error": result.ErrorMessage };
    }


    function GetTableOption() {
        return {
            isEditType: true,
            editCallback: editView,
            selectRow: true,
            scrollX: true,
            scrollY: "60vh",
            columns: [
                { field: 'Account', title: '帳號' },
                { field: 'Email', title: 'Email' },
                {
                    field: '',
                    title: '姓名',
                    render: function (data, type, row) {
                        return row.LastName + row.FirstName;
                    }
                },
                {
                    field: 'Birthday', title: '生日',
                    render: function (data, type, row) {
                        return data == null || data == "" ? "" : dateHelper.toString(data);
                    }
                },
                {
                    field: 'Enabled', title: '啟用',
                    render: function (data, type, row) {
                        if (row.IsConfirmed == true) return data ? "啟用" : "凍結";
                        return "尚未驗證";
                    }
                }
            ]
        };
    }

    function getSearchData() {
        return {
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
});