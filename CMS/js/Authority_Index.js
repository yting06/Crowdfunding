$(document).ready(function () {


    let modal;
    let roleViews = {
        add: {
            html: function () {
                return `<form id="RoleFormId" method="post">
                            <div class="row mb-2">
                                <label class="col-form-label col-md-3 text-end" for="Name">角色名稱</label>
                                <div class="col-sm-8"><input class="form-control text-box single-line" id="Name" name="Name" type="text" value=""></div>
                            </div>
                            <div class="row">
                                <span class="field-validation-valid text-danger text-center" data-valmsg-for="error" data-valmsg-replace="true"></span>
                            </div>
                        </form>`;
            },
            yesCallback: function (text, value) {
                return function (callbackFunc) {
                    let val = $("input#Name").val();
                    LoadData("AddNewRole", `roleName=${val}`, GetAfterRoleEventFunc(callbackFunc), "post");
                };
            }
        },
        edit: {
            html: function (key) {
                return `<form id="RoleFormId" method="post">
                            <div class="row mb-2">
                                <label class="col-form-label col-md-3 text-end" for="Name">角色名稱</label>
                                <div class="col-sm-8"><input class="form-control text-box single-line" id="Name" name="Name" type="text" value="${key}"></div>
                            </div>
                            <div class="row">
                                <span class="field-validation-valid text-danger text-center" data-valmsg-for="error" data-valmsg-replace="true"></span>
                            </div>
                        </form>`;
            },
            yesCallback: function (text, value) {
                return function (callbackFunc) {
                    let val = $("input#Name").val();
                    LoadData("UpdateRole", `id=${value}&roleName=${val}`, GetAfterRoleEventFunc(callbackFunc), "post");
                };
            }
        },
        delete: {
            html: function (key) {
                return `<form id="RoleFormId" method="post">
                            <div class="row"><label class="col-form-label" for="Name">是否刪除以下角色：</label></div>
                            <div class="row"><label class="col-form-label text-center" for="Name" >${key}</label></div>
                            <div class="row mb-1"><span class="field-validation-valid text-danger" data-valmsg-for="error" data-valmsg-replace="true"></span></div>
                        </form>`;
            },
            yesCallback: function (text, value) {
                return function (callbackFunc) {
                    LoadData("DeletRole", `ids=${value}`, GetAfterRoleEventFunc(callbackFunc), "post");
                };
            }
        },
    };

    let loadFunc = {
        pageList: GetSubListBuildFunc("pageList", "functionList", false, 'role'),
        functionList: GetSubListBuildFunc("functionList", "", false, 'role'),
        userRoleList: GetSubListBuildFunc("userRoleList", "", true, 'user'),
        SaveUserRoleRel: GetSaveRelFunc("userList", "userRoleList", InitUserView),
        SaveRolePageRel: GetSaveRelFunc("roleList", "pageList", InitRoleView),
        SaveRoleFuncsRel: GetSaveRelFunc("roleList", "functionList", InitRoleView),
        AddNewRole: GetEditFunc("新增角色", "add"),
        DeleteRoles: GetEditFunc("刪除角色", "delete"),
        EditRoles: GetEditFunc("編輯角色", "edit"),
    };


    let records = {
        role: {

        },
        user: {

        }
    }


    function GetSubListBuildFunc(containerId, subContainer, readOnly, keyWord) {
        let $container = $(`div#${containerId}`);
        let funcName = $container.attr("data-func");
        return function (paramStr) {
            LoadData(funcName, paramStr, function (result) {
                var $list = $('<ul class="list-group"></ul>');
                setRecords(keyWord, paramStr, result);
                result.forEach(function (item) {
                    var item = buildItem(readOnly, item.Enabled, item.Name, item.Id, subContainer);
                    $list.append(item);
                });
                $container.empty();
                $container.append($list);
            });
        };
    }

    function setRecords(keyWord, paramStr, result) {


    }


    function GetAfterRoleEventFunc(callbackFunc) {
        return function (result) {

            if (!result.success) {
                var oError = formHelper.getErrorObject(result);
                formHelper.setErrorMessage("RoleFormId", oError);
                return;
            }
            InitRoleView("");
            callbackFunc();
        };
    }

    function GetSaveRelFunc(container1, container2, func) {
        let $c1 = $(`#${container1}`), $c2 = $(`#${container2}`);
        return function ($that, text, value, action) {
            var idArray = getValueArray($c1.find("li.active"), "edit-data");
            var valueArray = getValueArray($c2.find("li:has(input:checked)"), "edit-data");
            if (idArray.length == 0) {
                alert(action.indexOf("User") ? "請選擇要設定角色的人員！" : "請選擇設定權限的角色！");
                return;
            }
            var pageId = $that.attr('b-action') != "SaveRoleFuncsRel" ? "" : $('#pageList li.active').first().attr("edit-data");
            var valusStr = valueArray.join(",");
            LoadData(action, `id=${idArray[0]}&data=${valusStr}&pageId=${pageId}`, function (result) {
                if (!result.success) {
                    alert(result.ErrorMessage);
                    return;
                } else {
                    alert("更新成功");
                   /* if (func) func("");*/
                }
            }, 'post')
            //todo 儲存 rel
        };
    }

    function getValueArray($list, key, element) {
        var items = [];
        $list.each(function () {
            let $a = !element ? $(this) : $(this).find('a');
            items.push($a.attr(key));
        });
        return items;
    }

    function GetEditFunc(title, key) {
        let oView = roleViews[key];
        return function ($that, text, value) {
            if ($that.attr("id") == "deleteRole") {
                var textArray = [], valArray = [];
                $("#roleList").find("li:has(input:checked)").each(function () {
                    let $a = $(this).find('a');
                    textArray.push($a.attr("b-text"));
                    valArray.push($a.attr("b-value"));
                });
                value = valArray.join(",");
                text = textArray.join(",");
                if (!value) {
                    alert("請勾選要刪除的角色！");
                    return;
                }
            }
            modal = new Modal({
                "title": title,
                noBtnLabel: "取消",
                yesBtnLabel: "確定",
                description: "",
                yesCallback: oView["yesCallback"](text, value),
                closeCallback: function () { modal = null; },
                bodyHtml: oView["html"](text),
            });
            modal.show();
        };
    }



    function LoadData(functionName, keyValues, callBackFunc, actType) {
        var url = `/api/AuthorizeApi/${functionName}?${keyValues}`;
        $.ajax({
            url: url,
            type: actType || 'Get',
            success: function (result) {
                if (callBackFunc != null) callBackFunc(result);
            }
        });
    }

    function InitRoleView(searchValue) {
        let $container = $("div#roleList");
        let funcName = $container.attr("data-func");
        LoadData(funcName, `searchValue=${searchValue}`, function (result) {
            var $list = $('<ul class="list-group"></ul>');
            result.forEach(function (item) {
                var item = buildRoleItem(!item.ReadOnly, item.Name, item.Id, "pageList");
                $list.append(item);
            });
            $container.empty();
            $container.append($list);
            $("div#roleList a").click(function () {
                event.stopPropagation();
                processBtnEvent($(this));
            });
        });

        $("div#pageList").empty();
        $("div#functionList").empty();
    }

    function processBtnEvent($that) {
        let value = $that.attr("b-Value"), text = $that.attr("b-Text"), action = $that.attr("b-action");
        if (loadFunc[action] != null)
            loadFunc[action]($that, text, value, action);
    }

    function InitUserView(searchValue) {
        let $container = $("div#userList");
        let funcName = $container.attr("data-func");
        LoadData(funcName, `searchValue=${searchValue}`, function (result) {
            var $list = $('<ul class="list-group"></ul>');
            result.forEach(function (item) {
                var item = buildItem(true, null, item.Name, item.Id, "userRoleList", true);
                $list.append(item);
            });
            $container.empty();
            $container.append($list);
        });
        $("div#userRoleList").empty();
    }

    function buildItem(readOnly, bEnabled, text, rowId, subContainer, noEdit) {
        var div = createElement("li", ["d-flex", "list-group-item", "list-group-item-action", "align-items-center", "py-2", "itemContainer"]);
        var input = createElement("input", ["form-check-input", "m-0"]);
        if (!noEdit) {
            input.setAttribute('type', 'checkbox');
            input.checked = bEnabled;
            input.readOnly = readOnly;
            div.appendChild(input);
        }

        var subdiv = createElement("div", ["w-100", "ms-3"]);
        var subdiv2 = createElement("div", ["d-flex", "w-100", "align-items-center", "justify-content-between"]);
        var subdiv2_span = createElement("span", [], text);

        subdiv2.appendChild(subdiv2_span);
        subdiv.appendChild(subdiv2);
        div.appendChild(subdiv);

        div.setAttribute('edit-data', rowId);
        if (subContainer != "") div.setAttribute('subContainer', subContainer);
        return div;
    }

    function buildRoleItem(canDelete, text, rowId, subContainer) {
        var div = createElement("li", ["d-flex", "list-group-item", "list-group-item-action", "align-items-center", "py-2", "itemContainer"]);
        if (canDelete) {
            var input = createElement("input", ["form-check-input", "m-0"]);
            input.setAttribute('type', 'checkbox');
            div.appendChild(input);
        }
        var subdiv = createElement("div", ["w-100", "ms-3"]);
        var subdiv2 = createElement("div", ["d-flex", "w-100", "align-items-center", "justify-content-between"]);
        var subdiv2_span = createElement("span", [], text);
        var subdiv2_a = createElement("a", ["editBtn", "mx-3"]);
        subdiv2_a.setAttribute('href', "#");
        subdiv2_a.setAttribute('b-Value', rowId);
        subdiv2_a.setAttribute('b-Text', text);
        subdiv2_a.setAttribute('b-action', "EditRoles");

        if (canDelete) {
            var subdiv2_a_i = createElement("i", ["fa-regular", "fa-pen-to-square", "me-lg-2"]);
            subdiv2_a.appendChild(subdiv2_a_i);
        }
        subdiv2.appendChild(subdiv2_span);
        subdiv2.appendChild(subdiv2_a);
        subdiv.appendChild(subdiv2);
        div.appendChild(subdiv);

        div.setAttribute('edit-data', rowId);
        div.setAttribute('subContainer', subContainer);
        return div;
    }

    function createElement(elementName, classArray, text) {
        var element = document.createElement(elementName);
        var classList = Array.isArray(classArray) ? classArray : [];
        element.classList.add(...classList);
        if (text != null) {
            element.textContent = text;
        }
        return element;
    }

    function BindEvent() {
        function throttle(func, delay) {
            let timeId = null;
            let previousTime = 0;
            return function (...args) {
                const nowTime = new Date().getTime();
                const remain = delay - (nowTime - previousTime);

                if (remain <= 0 || remain > delay) {
                    if (timeId) timeId = null;
                    previousTime = nowTime;
                    func.apply(this, args);
                } else if (!timeId) {
                    timeId = setTimeout(() => {
                        previousTime = new Date().getTime();
                        timeId = null;
                        func.apply(this, args);
                    }, remain)
                }
            }
        }

        let searchEvent = throttle(function ($input, searchValue) {
            console.log(searchValue);
            if ($input.attr("Id").includes("User")) {
                InitUserView(searchValue);
            } else InitRoleView(searchValue);

            console.log(searchValue);
        }, 350);

        $("#AuthorizeBlock")
            .on('click', 'button.btn', function () { processBtnEvent($(this)); })
            .on('click', 'li.list-group-item-action', function () {
                let $that = $(this);
                let $parent = $that.parent().closest('[data-func]');
                if (["userRoleList", "functionList"].includes($parent.attr("Id"))) return;

                setActive($that);
                let subContainer = $that.attr("subcontainer");
                let func = loadFunc[subContainer];
                if (func != null) {
                    let val = $that.attr("edit-data");

                    let params = `roleId=${val}`;
                    if (subContainer == "functionList") {
                        let roleId = $("#roleList li.active").attr("edit-data");
                        params = `roleId=${roleId}&pageId=${val}`;
                    } else if (subContainer == "userRoleList") params = `userId=${val}`;

                    func(params);
                }
            }).on('input', 'input.input-search', function () {
                let $that = $(this);
                let value = $that.val();
                searchEvent($that, value);
            });

    }

    function setActive($item) {
        let $that = $item;
        $that.parent().find('li.active').removeClass('active');
        $that.addClass('active');
    }

    function initView() {
        InitRoleView("");
        InitUserView("");

        BindEvent();
    }

    initView();

})

