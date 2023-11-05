using CrowdfundingWebsites.Models.Infra;
using CrowdfundingWebsites.Models.Services;
using CrowdfundingWebsites.Models.ViewModels;
using System;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;

namespace CrowdfundingWebsites.Controllers
{

    public class HomeController : Controller
    {
        private readonly ManagerService _managerService = new ManagerService();


        [PageAuthorize()]
        public ActionResult Blank()
        {
            return View();
        }


        [AllowAnonymous]
        public ActionResult Login()
        {
            LoginVm vm = new LoginVm
            {
                Account = "Test",
                Password = "0",
            };
            return PartialView(vm);
        }

        [HttpPost]
        [AllowAnonymous]
        public ActionResult Login(LoginVm vm)
        {
            if (!ModelState.IsValid) return PartialView(vm);

            var service = new Login(new ManagerService());
            var result = service.IsValid(vm);

            if (!result.IsSuccess)
            {
                ModelState.AddModelError("loginError", result.ErrorMessage);
                return PartialView(vm);
            }

            try
            {
                string returnUrl = service.ProcessLogin(vm, out HttpCookie cookie);
                this.Response.Cookies.Add(cookie);
                return Redirect(returnUrl);
            }
            catch (Exception ex)
            {
                ViewBag.ErrorMessage = ex.Message;
            }

            return PartialView(vm);
        }


        public ActionResult Logout()
        {
            Session.Abandon();
            FormsAuthentication.SignOut();
            return RedirectToAction("Login");
        }


        public ActionResult ForgetPassword() => PartialView();

        [HttpPost]
        public ActionResult ForgetPassword(ForgetPasswordVm vm)
        {
            try
            {
                new ManagerService().ProcessForgetPassword(vm.Account, vm.Email, Request.Url);
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("", ex.Message);
                return PartialView();
            }
            return RedirectToAction("Confirm", new { message = "已送出重設密碼連結，請去信箱查收" });
        }

        public ActionResult Confirm(string message)
        {
            ViewBag.Message = message;
            return PartialView("_ConfirmRegisterPartial");
        }



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