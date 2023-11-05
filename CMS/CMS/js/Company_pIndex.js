$(document).ready(function () {

    let table = null;
    let url = `/api/DataApi/GetProjects`;
    

    function EditView(rowId) {
        modal = new Modal({
            "title": "",
            noBtnLabel: "退件",
            yesBtnLabel: "通過",
            description: "",
            yesCallback: editYesCallback(rowId, "Submit"),
            noCallback: editYesCallback(rowId, "Refund"),
            closeCallback: function () { modal = null; },
            bodyHtml: `<div id="ProjectFormId" class="container" >
                            <div class="row"><label class="col-form-label text-center">是否通過審核？</label></div>
                            <div class="row mb-1"><span class="field-validation-valid text-danger" data-valmsg-for="error" data-valmsg-replace="true"></span></div>
                        </div>`,
        });
        modal.show();
    }

    function editYesCallback(rowId, key) {
        return function (callbackFunc) {
            $.ajax({
                url: `/api/DataApi/${key}Project?id=${rowId}`,
                type: 'POST',
                success(result) {
                    if (!result.success) {
                        var oError = formHelper.getErrorObject(result);
                        formHelper.setErrorMessage("ProjectFormId", oError);
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
            editCallback: EditView,
            editIcon: "fa fa-check",
            selectRow: true,
            scrollX: true, 
            scrollY: "60vh",
            canEditDisplay: function (data, type, row) {
                return row["StatusName"] == "審核中";
            },
            columns: [
                { field: 'CategoryName', title: '類別' },
                { field: 'Name', title: '活動名稱' },
                { field: 'Goal', title: '目標金額' },
                { field: 'Enabled', title: '狀態',
                    render: function (data, type, row) {
                        return data == false ? "申請中" : (data == true ? "通過" : "");
                    }
                },  //申請中、退件
                {
                    field: 'ApplyTime', title: '申請時間',
                    render: function (data, type, row) {
                        return dateHelper.toString(data, true);
                    }
                }
            ]
        };
    }

    function getSearchData() {
        return {
            SearchValue: $("#search-Value").val(),
            Type: $("#typesDDL").val(),
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