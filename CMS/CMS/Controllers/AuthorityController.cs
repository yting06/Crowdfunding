using CrowdfundingWebsites.Models.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CrowdfundingWebsites.Controllers
{
    public class AuthorityController : Controller
    {
        // GET: Authority
        public ActionResult Index()
        {
            ViewBag.Roles = new PermissionService().GetRoles();

            return PartialView("_IndexPartial");
        }



    }
}