function TableHelper(containerId, data, option, url) {
    let This = this;
    let defaultOptions = {
        dom: "rtpi",
        autoWidth: true,
        ordering: false,
        select: 'single',
        language: {
            "info": "顯示 _START_ 到 _END_ 筆資料，共 _TOTAL_ 筆資料", // 自訂 info 區域的文字"
            "lengthMenu": "顯示 _MENU_ 筆資料",
            "search": "搜索：",
            "zeroRecords": "沒有資料",
            "info": "顯示 _START_ ~ _END_ 筆資料，共 _TOTAL_ 筆資料",
            "infoEmpty": "共 0 筆資料",
            "infoFiltered": "(從 _MAX_ 筆資料中過濾)",
            "infoSelected": " ",
            "paginate": {
                "first": "首頁",
                "previous": "上一頁",
                "next": "下一頁",
                "last": "末頁"
            },
            "sSelect": {
                "rows": {
                    "_": "選取 %d 筆資料", // " 選取 %d 筆資料"
                    "0": " ", //  
                    "1": "選取 1 筆資料", //" 選取 1 筆資料" 
                }
            }
        },
        processing: true,
        serverSide: true,
        paging: true,
        pageLength: 10,
        ajax: {
            url: url,
            type: 'POST',
            dataType: "json",
            dataSrc: "data",
            data: function (d) {
                This.searchObj.PageStart = d.start;
                This.searchObj.PageSize = This.json.pageLength;
                return This.searchObj;
            }
        },
    };

    this.isEditType = option.isEditType == false ? option.isEditType : true;
    this.containerId = containerId;
    this.json = Object.assign({}, defaultOptions, option || {});
    this.json.data;
    this.dataTable = null;
    This.searchObj = data;
    This.validEdit = This.json.editCallback != null;
    This.validDelete = This.json.deleteCallback != null;

    this.updateData = function (data, callbackFunc) {
        This.searchObj = data;
        This.dataTable.ajax.reload(function () {
            // if (This.isEditType) bindEvent();


        });
    }


    function getTableColumns(columns) {
        if (!Array.isArray(columns)) return [];
        let columnDefs = columns.map((item) => {
            let isVisible = item.visible || true;
            return Object.assign({}, item, {
                data: item.field,
                visible: isVisible,
                searchable: isVisible,
            });
        });
        if (This.isEditType) columnDefs = columnDefs.concat(getEditColumnBtn());

        return columnDefs;
    }

    function getEditColumnBtn() {

        return [{
            "title": "",
            "width": "100px",
            "render": function (data, type, row) {
                let id = row.Id;
                let editIconCss = This.json.editIcon ?? "fa-regular fa-pen-to-square";
                let deleteIconCss = This.json.deleteIcon ?? "fa-solid fa-trash";
                let btns = "";
                if (This.json.canEditDisplay == null || This.json.canEditDisplay(data, type, row)) {
                    btns = This.validEdit ? `<a href="#" class="editBtn mx-3" edit-data="${id}"><i class="${editIconCss} me-lg-2"></i></a>` : "";
                    btns += This.validDelete ? `<a href="#" class="deleteBtn" edit-data="${id}"><i class="${deleteIconCss} me-lg-2"></i></a>` : "";
                }
                return btns;
            }
        }];
    }


    function build() {
        This.json.columns = getTableColumns(This.json["columns"]);
        This.dataTable = $(`#${This.containerId} table`).DataTable(This.json);

        if (This.isEditType) bindEvent();
    };

    function bindEvent() {
        let $table = $(`#${This.containerId} table`);
        let editEvent = This.json.editCallback;
        let deleteEvent = This.json.deleteCallback;

        if (This.validEdit) {
            $table.on('click', "a.editBtn[edit-data][edit-data!='']", function () {
                let id = $(this).attr("edit-data");
                editEvent(id);
            });
        }
        if (This.validDelete) {
            $table.on('click', "a.deleteBtn[edit-data][edit-data!='']", function () {
                let id = $(this).attr("edit-data");
                deleteEvent(id);
            });

        }
    }


    build(This);
}

