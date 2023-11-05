using CrowdfundingWebsites.Models.Infra;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CrowdfundingWebsites.Controllers
{
    public class HomeController : Controller
    {
        [AllowAnonymous]
        public ActionResult DisplayConfirmTxtList()
        {
            var path = HttpContext.Server.MapPath("~/Files/");
            var fileHelper = new FileHelper(path);
            ViewBag.FolderFiles = fileHelper.GetFolderFiles();

            return PartialView();
        }

        [AllowAnonymous]
        public ActionResult DisplayDetailTxt(string fileName)
        {
            var path = HttpContext.Server.MapPath("~/Files/");
            var fileHelper = new FileHelper(path);

            var data = fileHelper.GetFileData(fileName);
            ViewBag.Content = new EmailContext(data);

            return PartialView();
        }
    }
}