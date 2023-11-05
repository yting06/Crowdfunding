using CrowdfundingWebsites.Models.EFModels;
using CrowdfundingWebsites.Models.Infra;
using CrowdfundingWebsites.Models.Services;
using CrowdfundingWebsites.Models.ViewModels;
using Microsoft.Ajax.Utilities;
using OfficeOpenXml;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace CrowdfundingWebsites.Controllers.WebApi
{
    public class FileApiController : ApiController
    {
        private readonly Dictionary<string, Type> _dict = new Dictionary<string, Type>()
        {
            { "M_USER", typeof(Manager) },
            { "W_FAQs", typeof(FAQ) },
        };



        [HttpPost]
        public IHttpActionResult UploadFAQs()
        {
            try
            {
                // 检查请求中是否包含文件
                if (!Request.Content.IsMimeMultipartContent())
                {
                    throw new HttpResponseException(HttpStatusCode.UnsupportedMediaType);
                }
                var file = HttpContext.Current.Request.Files[0];
                if (file == null || file.ContentLength <= 0) return BadRequest("No file uploaded.");
                string fileName = file.FileName;

                if (fileName.IsExcelFileName())
                {
                    var helper = new ExcelHelper();
                    var data = helper.ProcessSingleSheetFile<FAQ>(file);
                    new WebContentService().InsertFAQs(data);
                    return Ok("資料更新成功");
                }
                return BadRequest("錯誤檔案格式，僅能上傳 .xlsx ");
            }
            catch (Exception ex)
            {
                return InternalServerError(ex);
            }
        }

        [HttpPost]
        public IHttpActionResult UploadManagers()
        {
            try
            {
                // 检查请求中是否包含文件
                if (!Request.Content.IsMimeMultipartContent())
                {
                    throw new HttpResponseException(HttpStatusCode.UnsupportedMediaType);
                }
                var theFile = HttpContext.Current.Request.Files[0];
                if (theFile == null || theFile.ContentLength <= 0) return BadRequest("No file uploaded.");
                string fileName = theFile.FileName;

                if (fileName.IsExcelFileName())
                {
                    var helper = new ExcelHelper();
                    var data = helper.ProcessSingleSheetFile<ManagerVm>(theFile);
                    new ManagerService().RegisterMembers(data, Request.RequestUri);
                    return Ok("資料更新成功");
                }
                return BadRequest("Invalid file format. Only .xlsx files are allowed.");
            }
            catch (Exception ex)
            {
                return InternalServerError(ex);
            }
        }

    }


}