let UploadFileHelper = function (clickId, uploadId, callbackReaderOnload, option) {
    let This = this;
    This.uploadId = uploadId;
    This.ctrlUpload = document.getElementById(uploadId);
    This.ctrlClick = document.getElementById(clickId);

    let allFiles = null;
    let file = null;

    let settings = Object.assign({}, option); 


    this.ctrlUpload.addEventListener('change', uploadFile_onchange.bind(this));
    if (this.ctrlClick != null) {
        this.ctrlClick.addEventListener("click", function () {

            upload_onchange()

        });
    } else this.ctrlUpload.addEventListener('change', upload_onchange.bind(this));

    function uploadFile_onchange(event) {
        console.log("SingleUploadFileHelper upload_onchange() raised.");
        allFiles = event.target.files;
        file = allFiles[0];

    }
    function getUrl(action) {
        return settings.url.replace("$action", action);
    }
    function isValidFiles(file) {
        if (file == null) return false;

        const fileExtension = file.name.slice(file.name.lastIndexOf(".") + 1).toLowerCase();
        let validFiles = settings.validFiles || [];
        return validFiles.includes(fileExtension);
    }


    function upload_onchange() {
        let spinner = new spinnerHelper();
        if (isValidFiles(file)) {
            var action = This.ctrlUpload.getAttribute("d-source");
            let url = getUrl(action);

            var formData = new FormData();
            formData.append('file', file); // 将文件添加到 FormData 对象
            formData.append("key", JSON.stringify({ "key": action }));

            spinner.show(This.uploadId);
            
            fetch(url, {
                method: 'POST',
                body: formData
            }).then(response => {
                if (response.ok) {
                    return response.text();
                } else {
                    throw new Error('File upload failed.');
                }
            }).then(data => {
                callbackReaderOnload("上傳成功"); 
            }).catch(error => {
                console.error(error);
            }).finally(() => {
                spinner.hide();
            });

        } else callbackReaderOnload("檔案格式錯誤"); 
    }

};