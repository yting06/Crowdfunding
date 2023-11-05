using CrowdfundingWebsites.Models.EFModels;
using CrowdfundingWebsites.Models.Services;
using CrowdfundingWebsites.Models.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.UI.WebControls;
using System.Xml.Linq;

namespace CrowdfundingWebsites.Controllers
{
    public class ManagerController : Controller
    {
        private readonly ManagerService _service = new ManagerService();

        /// <summary>
        /// 用戶管理頁面
        /// </summary>
        /// <returns></returns>
        public ActionResult Index()
        {
            return PartialView("_IndexPartial");
        }
        public ActionResult Create()
        {
            return PartialView("_CreatePartial");
        }
        public ActionResult Edit(int id)
        {
            var vm = _service.Get(id);

            return PartialView("_EditPartial", vm);
        }

        public ActionResult Profile(int id)
        {
            var data = _service.Get(id);

            var vm = new ManagerProfileVm
            {
                Id = data.Id,
                FirstName = data.FirstName,
                LastName = data.LastName,
                Birthday = data.Birthday,
                Email = data.Email
            };
            return PartialView("_ProfilePartial", vm);
        }

        public ActionResult PWEdit(int id)
        {

            return View();
        }

        /// <summary>
        /// 認證網頁
        /// </summary>
        /// <param name="key"></param>
        /// <param name="confirmCode"></param>
        /// <returns></returns>
        public ActionResult ConfirmRegister(int key, string confirmCode)
        {
            if (!_service.IsValid(key, confirmCode))
                return PartialView("_ErrorPartial");

            _service.ProcessConfirm(key, confirmCode);



            return RedirectToAction("Confirm", "Home", new { message = "認證成功" });
        }


        public ActionResult ResetPassword(int key, string confirmCode)
        {
            if (!_service.IsValid(key, confirmCode))
                return PartialView("_ErrorPartial");
            ViewBag.user = key;
            return PartialView("_ResetPasswordPartial");
        }

        [HttpPost]
        public ActionResult ResetPassword(ResetPasswordVm vm)
        {
            if (!ModelState.IsValid)
            {
                ViewBag.user = vm.Id;
                return PartialView();
            }

            try
            {
                _service.ResetPassword(vm);
            }
            catch(Exception ex)
            {
                ViewBag.user = vm.Id;
                return PartialView();
            }

            return RedirectToAction("Confirm", "Home", new { message = "重設密碼成功" });
        }

    }
}