using CrowdfundingWebsites.Models.Services;
using CrowdfundingWebsites.Models.ViewModels;
using Newtonsoft.Json.Linq;
using System.Diagnostics;
using System.Linq;
using System.Web.Http;
using System.Web.Mvc;
using System.Web.Services.Description;
using System.Web.UI.WebControls;

namespace CrowdfundingWebsites.Controllers
{

    [PageAuthorize]
    public class WebContentsController : Controller
    {
        public ActionResult Category()
        {
            var service = new CategoryService();
            var types = service.GetTypeList()
                .Select(x=> new { Text = x, Value = x })
                .ToList();
            types.Insert(0, new { Text = "全部", Value = "all" });
            ViewBag.Types = new SelectList(types, "Value", "Text");

            return PartialView("_CategoryIndexPartial"); 
        }

        public ActionResult CategoryEdit(int id)
        {
            CategoryVm vm = new CategoryService().Get(id);
            ViewBag.Types = GetCategoryTypeList();

            return PartialView("_CategoryEditPartial", vm);
        }

        public ActionResult CategoryCreate()
        {
            ViewBag.Types = GetCategoryTypeList();

            return PartialView("_CategoryCreatePartial");
        }


        public ActionResult FAQs()
        {
            ViewBag.Types = GetCategoryList("FAQs");

            return PartialView("_FAQsPartial");
        }

        public ActionResult FAQsCreate()
        {
            ViewBag.Types = GetCategoryList("FAQs");

            return PartialView("_FAQsCreatePartial");
        }

        public ActionResult FAQEdit(int id)
        {
            var service = new WebContentService();
            var vm = service.Get(id);
            ViewBag.Types = GetCategoryList("FAQs");

            return PartialView("_FAQEditPartial", vm);
        }


        private SelectList GetCategoryList(string type)
        {
            var service = new CategoryService();
            var list = service.GetCategoryByType(type);
            return new SelectList(list, "Id", "Name");
        }
        private SelectList GetCategoryTypeList()
        {
            var service = new CategoryService();
            var types = service.GetTypeList();

            return new SelectList(types);
        }



        public ActionResult AboutUs()
        {
            var service = new AboutUsService();
            var data = service.GetData();

            return View("_AboutUsPartial", data);
        }


        public ActionResult PrivacyPolicies()
        {
            return View("_PrivacyPoliciesPartial");
        }



        /// <summary>
        /// 檔案上傳畫面
        /// </summary>
        /// <param name="title"></param>
        /// <param name="path"></param>
        /// <param name="act"></param>
        /// <returns></returns>
        public ActionResult UploadFile(string title, string path, string act)
        {
            ViewBag.title = title;
            ViewBag.examplePath = path;
            ViewBag.ApiAction = act;

            return PartialView("~/Views/Shared/_UploadFiles.cshtml");
        }

    }
}