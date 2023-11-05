let modalWrap = null;
function Modal(jsonData) {


    let defaultJson = {
        title: "",
        description: "",
        noBtnLabel: "取消",
        onlyDisplayCancel: false,
        yesBtnLabel: "確定",
        yesCallback: null,
        noCallback: null,
        closeCallback: null,
        style: "modal"  //"static","modal"
    };


    let json = Object.assign({}, defaultJson, jsonData || {});

    let defaultDiv = {
        "element": 'div',
        "class": ["modal"],
        "props": {
            //"data-bs-backdrop": json.style,
            //"data-bs-keyboard": "false",

            "id": "modalView",
            "tabindex": "-1",
            "aria-labelledby": "modalViewLabel",
            "aria-hidden": true
        },
        "children": [
            {
                "element": 'div',
                "class": ["modal-dialog"],
                "props": {
                    "id": "modalView"
                },
                "children": [
                    {
                        "element": 'div',
                        "class": ["modal-content"],
                        "children": [
                            {
                                "element": 'div',
                                "class": ["modal-header"],
                            },
                            {
                                "element": 'div',
                                "class": ["modal-body"]
                            },
                            {
                                "element": 'div',
                                "class": ["modal-footer"],
                            }

                        ]
                    }

                ]
            }
        ]
    };

    function createModal(json) {
        modalWrap = document.createElement('div');
        let div = formHelper.buildElement(defaultDiv);
        modalWrap.append(div);
        document.body.append(modalWrap);

        let hearder = modalWrap.querySelector(".modal-header");
        createHeader(hearder);
        let footer = modalWrap.querySelector(".modal-footer");
        createFooterView(footer);

        createBody(json);
    }


    function createBody(json) {
        let body = modalWrap.querySelector(".modal-body");
        body.innerHTML = "";

        if (json.bodyHtml != null) {
            $(body).html(json.bodyHtml);
            return;
        }
        if (Array.isArray(json.bodyColumns)) {
            let data = json.data || {};
            let content = "";
            json.bodyColumns.forEach(function (item) {
                if (!item.visible) return;
                let val = data[item.field] || "";
                let divHtml = `
                <div class="row mb-3">
                    <label for="${item.field}" class="col-sm-2 col-form-label">${item.title}</label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" id="input${item.field}" value="${val}">
                    </div>
                </div>`;
                content += divHtml;
            });
            $(body).html(content);
        }
    }

    function createHeader(element) {
        element.innerHTML = `<h5 class="modal-title" id="modalViewLabel">${json.title}</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>`;
    }

    function createFooterView(element) {
        let btn = {
            "element": 'button',
            "class": ["btn"],
        };
        let yesObj = Object.assign({}, btn, { "class": ["btn", "btn-primary", "modal-success-btn"], "innerText": json.yesBtnLabel });
        let cancelObj = Object.assign({}, btn, { "class": ["btn", "btn-secondary", "modal-cancel-btn"], "innerText": json.noBtnLabel });

        let yesBtn = formHelper.buildElement(yesObj, null);
        let cancelBtn = formHelper.buildElement(cancelObj, null);


        element.append(cancelBtn);
        if (!json.onlyDisplayCancel) {
            element.append(yesBtn);
        }

        $("#modalView").on("hidden.bs.modal", function () {
            if (json.closeCallback != null) json.closeCallback();
        });
    }


    function setBtnEvent() {
        let successBtn = modalWrap.querySelector('.modal-success-btn');
        let cancelBtn = modalWrap.querySelector('.modal-cancel-btn');
        let yesCallback = json.yesCallback, noCallback = json.noCallback;
        if (!json.onlyDisplayCancel) {
            if (yesCallback != null) {
                successBtn.onclick = () => yesCallback(function (valid) {
                    if (typeof valid === 'boolean' && valid == false) return;
                    $('.modal').modal('hide');
                });
            } else successBtn.setAttribute('data-bs-dismiss', "modal");
        }
       

        if (noCallback != null) {
            cancelBtn.onclick = () => noCallback(function (valid) {
                if (typeof valid === 'boolean' && valid == false) return;
                $('.modal').modal('hide');
            });
        } else cancelBtn.setAttribute('data-bs-dismiss', "modal");

    }

    this.show = function () {
        if (modalWrap == null) {
            createModal(json);
        } else {
            let hearder = modalWrap.querySelector(".modal-title");
            hearder.innerText = json.title;
            createBody(json);
            let footer = modalWrap.querySelector(".modal-footer");
            footer.innerHTML = "";
            createFooterView(footer);
        }

        setBtnEvent();

        var div = modalWrap.querySelector('.modal');
        var modal = new bootstrap.Modal(div);

        modal.show();
    };


}
