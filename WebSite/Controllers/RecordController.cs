using CrowdfundingWebsites.Models.EFModels;
using CrowdfundingWebsites.Models.Repositories;
using CrowdfundingWebsites.Models.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CrowdfundingWebsites.Controllers
{
    public class RecordController : Controller
    {

		[Authorize]
		public ActionResult OrderRecord()
		{
            string account = HttpContext.User.Identity.Name;
            var member = GetMemberInfo(account);

            var orders = new OrderRepository().GetAll(member.Id);
			return View(orders);
		}


        private Member GetMemberInfo(string account)
        {
            var db = new AppDBContext();
            var member = db.Members.FirstOrDefault(m => m.Account == account);
            if (member == null) throw new Exception("用戶不存在");
            return member;
        }
    }
}