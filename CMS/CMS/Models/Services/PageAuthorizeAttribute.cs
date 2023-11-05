using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http.Results;

namespace CrowdfundingWebsites.Models.Services
{
    public class PageAuthorizeAttribute : System.Web.Mvc.AuthorizeAttribute
    {
        public bool Ignore { get; set; } = false;
        public string Functions { get; set; }
        public int? Pages { get; set; }

        //todo 實作權限控管驗證
        public override void OnAuthorization(System.Web.Mvc.AuthorizationContext filterContext)
        {
            var user = filterContext.HttpContext.User;
            if (user.Identity.IsAuthenticated)
            {
                //CustomPrincipal currentUser = filterContext.HttpContext.User as CustomPrincipal;

                //// 如果沒有指定權限，就不用檢查了,有登入就有權限
                //if (string.IsNullOrEmpty(Functions)) return;

                //// 必需有以下權限才能繼續
                //var allowFunctions = Functions.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);

                //// 比對是否有權限


                //if (allowFunctions.Any(x => currentUser.IsInRole(x)))
                //{
                //    return;
                //}
                //else
                //{
                //    // 用戶沒有權限，設置重定向到自訂的“Unauthorized”動作
                //    filterContext.Result = new RedirectToRouteResult(
                //        new System.Web.Routing.RouteValueDictionary(
                //            new
                //            {
                //                controller = "Users",
                //                action = "Unauthorized"
                //            })
                //    );
                //}
            }

            base.OnAuthorization(filterContext);
        }
    }

}