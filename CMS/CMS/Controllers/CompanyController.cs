using CrowdfundingWebsites.Models.Services;
using CrowdfundingWebsites.Models.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CrowdfundingWebsites.Controllers
{
    public class CompanyController : Controller
    {

        public ActionResult ProjectIndex()
        {
            ViewBag.Types = GetCategoryList("ProjectStatus");
            var vm = new SearchProjectVm
            {
                Type = 21
            };

            return PartialView("_ProjectIndexPartial", vm);
        }


        private SelectList GetCategoryList(string type)
        {
            var service = new CategoryService();
            var list = service.GetCategoryByType(type);
            return new SelectList(list, "Id", "Name");
        }
    }
}