
let stringHelper = {
    tryParseFloat: function (value) {
        let result = {
            isValid: false,
            value: 0
        };
        let number = Number(value);

        if (isNaN(number)) return result;

        result.isValid = true;
        result.value = number;
        return result;
    },
    toBool: function (str) {
        return str === 1 || Number(str) === 1 || str.toLowerCase() === "true" || str === "1";
    },
    isString: function (str) {
        return typeof (str) == "string";
    },
    reverseString: function (str) { //字串反轉
        if (!this.isString(str)) throw Error("please enter string");
        return str.split("").reverse().join("");
    },
    capitalizeFirstLetter: function (str) { //首字母大寫
        if (!this.isString(str)) throw Error("please enter string");
        return str.charAt(0).toUpperCase() + str.substring(1, str.length);
    },
    isFunction: function (value) {
        return value instanceof Function;
    }
};

let numberHelper = {
    isNumeric: function (value) {
        return typeof (value) === 'number';
    },
    isInt: function (value) {
        return !isNaN(value) && Math.floor(value) === value && isFinite(value);
    },
    findMax: function (param) {//找最大值
        if (!Array.isArray(param)) throw Error("請輸入陣列");
        return Math.max(param);
    },
    isEven: function (num) {//卻認為偶數
        if (!this.isNumeric(num)) throw Error("請輸入數字");
        return num % 2 == 0;
    },
    sumArray: function (arr) {//array sum
        if (!Array.isArray(arr)) throw Error("");
        return arr.reduce((accumulator, currentValue) => accumulator + currentValue, 0);
    },
    filterEvenNumbers: function (arr) {//找出 array 中的偶數
        if (!Array.isArray(arr)) throw Error("");
        return arr.filter(item => this.isEven(item));
    }

};

let dateHelper = {
    isDate: function (date) {
        return (date instanceof Date) && !isNaN(date);
    },
    addDays: function (date, days) {
        if (!this.isDate(days)) return Error(`${date} is not Date Type`);

        let dtTemp = new Date(date);
        return new Date(dtTemp.setDate(dtTemp.getDate() + days));
    },
    addMonths: function (date, months) {
        if (!this.isDate(date)) return Error(`${date} is not Date Type`);

        let dtTemp = new Date(date);
        let dtResult = new Date(dtTemp.setMonth(dtTemp.getMonth() + months));
        if (dtResult.getDate() !== date.getDate()) dtResult.setDate(0);
        return dtResult;
    },
    toString: function (date, withTime) {
        var dateTime = new Date(date);
        var year = dateTime.getFullYear();
        var month = (dateTime.getMonth() + 1).toString().padStart(2, '0');
        var days = dateTime.getDate().toString().padStart(2, '0');

        if (withTime) return `${year}-${month}-${days} ${dateTime.getHours()}:${dateTime.getMinutes()}`

        return `${year}-${month}-${days}`;
    }

};


let Triangle = {
    Left: function (rowCount, row) {
        if (!numberHelper.isNumeric(row)) throw Error("");
        return "*".repeat(row) + "\n";
    },
    Mid: function (rowCount, row) {
        if (!numberHelper.isNumeric(row)) throw Error("");
        if (!numberHelper.isNumeric(rowCount)) throw Error("");

        return " ".repeat(rowCount - row) + "*".repeat(row * 2 - 1) + "\n";
    },
    Right: function (rowCount, row) {
        if (!numberHelper.isNumeric(row)) throw Error("");
        if (!numberHelper.isNumeric(rowCount)) throw Error("");

        return " ".repeat(rowCount - row) + "*".repeat(row) + "\n";
    },
    Draw: function (rowCount, func) {
        if (!numberHelper.isInt(rowCount) || rowCount < 0) throw Error("rows 必須為正整數");
        if (!stringHelper.isFunction(func)) throw Error("func 必須為 Function");

        let result = "";
        for (var i = 1; i <= rowCount; i++) {
            result += func(rowCount, i);
        }
        return result;
    },
}

let AreaHelper = {
    squareArea: function (side) {//正方形面積
        if (!numberHelper.isNumeric(side)) throw Error("");
        return side * side;
    },
    circleArea: function (radius) {//圓面積
        if (!numberHelper.isNumeric(radius)) throw Error("");
        return Math.PI * radius * radius;
    }
};


let formHelper = {
    /**
     * 取得 radio button list 的值
     * @param {string} elemName
     * @returns {string|null}
     */
    getRadioButtonsSelectedValueByName: function (elemName) {
        let elems = document.getElementsByName(elemName); // 用 name 取得所有的 radio button
        if (elems.length == 0) throw new Error(`找不到 name=${genderElemName} 的 radio button`);

        for (let i = 0; i < elems.length; i++) {
            if (elems[i].checked) {
                return elems[i].value;
            }
        }
        return null;
    },

    /**
     * 設定 radio button list 的值
     * @param {string} elemName
     * @param {string} value
     */
    setRadioButtonsValueByName: function (genderElemName, value) {
        let elems = document.getElementsByName(genderElemName); // NodeList 用 name 取得所有的 radio button
        if (elems.length == 0) throw new Error(`找不到 name=${genderElemName} 的 radio button`);

        // 如果 value 是 null, 則全部取消勾選
        if (value === null) {
            Array.from(elems).forEach(elem => elem.checked = false);
            return;
        }

        for (let i = 0; i < elems.length; i++) {
            if (elems[i].value == value) {
                elems[i].checked = true;
                return;
            }
        }
    },

    /**
     * 繫結陣列資料到 select 元素, 不包含設定值
     * @param ddl
     * @param datasource
     * @param valueMember
     * @param textMember
     */
    bindDDL: function (ddl, datasource, valueMember, textMember) {
        // 判斷 ddl 是 select 元素
        if (ddl.tagName != "SELECT") throw new Error("ddl 必需是 select 元素");
        // 判斷 datasource 是陣列
        if (!Array.isArray(datasource)) throw new Error("datasource 必需是陣列");
        // valueMember, textMember 必需是字串,且不能是null
        if (typeof valueMember != "string" || valueMember == null || typeof valueMember === 'undefined') throw new Error("valueMember 必需是字串");
        if (typeof textMember != "string" || textMember == null || typeof valueMember === 'undefined') throw new Error("textMember 必需是字串");

        // 先清空 ddl 的內容
        ddl.innerHTML = "";

        datasource.forEach(function (item) {
            let option = document.createElement("option");
            option.value = item[valueMember];
            option.innerText = item[textMember];
            ddl.appendChild(option);
        });
    },

    /**
     * 取得 radio button list 的值
     * @param {string} elemName
     * @returns {string|null}
     */
    emptyDDL: function (ddl) {
        if (ddl.tagName != "SELECT") throw new Error("ddl 必須為 select 元素");
        ddl.innerHTML = "";
    },
    getErrorObject: function (result) {
        if (result.error != null) return JSON.parse(result.error);
        return { "error": result.ErrorMessage };
    },

    getFormData: function (formId) {
        let form = document.getElementById(formId);
        var formData = {};

        for (var i = 0; i < form.elements.length; i++) {
            var element = form.elements[i];
            if (element.name) {
                formData[element.name] = element.value;
            }
        }
        return formData;
    },

    setErrorMessage: function (formId, errorJSON) {
        let form = document.getElementById(formId);
        var elements = form.querySelectorAll('span[data-valmsg-for]');
        elements.forEach(element => {
            let key = element.getAttribute("data-valmsg-for");
            if (errorJSON[key] == null) return;

            element.textContent = errorJSON[key];
        });
    },
    buildElement: function createElement(obj, parent) {
        let props = obj.props;
        let children = obj.children;

        let element = document.createElement(obj.element);
        element.classList.add(...obj.class)
        if (props != null) {
            for (const key in props) {
                element.setAttribute(key, props[key]);
            }
        }

        if (obj.innerText != null) element.innerText = obj.innerText;
        if (children != null) children.forEach(item => createElement(item, element));
        if (parent != null) parent.append(element);

        return element;
    },
};



let fetchHelper = (function () {
    let This = this;

    let call = {
        post: function (url, callbackFunc, data) {
            fetch(url, {
                method: 'post',
                body: JSON.stringify(data),
                headers: { "Content-type": "application/json" }
            }).then(function (response) {
                return response.json();
            }).then(function (jsonData) {
                if (callbackFunc != null) callbackFunc(jsonData);
            }).catch(error => {
                console.error('There was a problem with the fetch operation:', error);
            });
        },
        get: function (url, callbackFunc) {
            fetch(url, {
                method: 'get',
                headers: { "Content-type": "application/json" }
            }).then(function (response) {
                return response.json();
            }).then(function (jsonData) {
                if (callbackFunc != null) callbackFunc(jsonData);
            }).catch(error => {
                console.error('There was a problem with the fetch operation:', error);
            });
        },
    }

    This.getData = function (url, type, data, func) {
        let callfuncName = type.toLowerCase();
        let callFunc = call[callfuncName];
        if (callFunc != null) callFunc(url, func, data);
    }

    This.post = (url, data, func) => call.post(url, func, data);


    This.ajax = function (url, callbackFunc) {
        $.ajax({
            url: url,
            type: 'GET',
            success: function (result) {
                callbackFunc(result);
            }
        });
    }



    return This;
})();

let spinnerHelper = function () {
    let spinner = null;
    let defaultDiv = {
        "element": 'div',
        "class": ["show", "position-fixed", "translate-middle", "w-100", "vh-100", "top-50", "start-50", "d-flex", "align-items-center", "justify-content-center"],
        "props": { "id": "spinner", },
        "innerText": "Loading...",
        "children": [
            {
                "element": 'div',
                "class": ["spinner-border", "text-primary"],
                "props": {
                    "style": "width: 3rem; height: 3rem;",
                    "role": "status",
                },
                "children": [
                    {
                        "element": 'span',
                        "class": ["sr-only"],
                        "innerText": "Loading...",
                    }
                ]
            }
        ]
    };

    this.show = function (elementId) {
        if (elementId == null) return;

        let $element = $(`#${elementId}`).closest('[container="spinner"]');
        let element = $element[0];
        spinner = formHelper.buildElement(defaultDiv);
        element.append(spinner);
    }

    this.hide = function () {
        if (spinner != null) spinner.remove();
    }


};