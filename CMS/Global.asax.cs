using AutoMapper;
using CrowdfundingWebsites.App_Start;
using OfficeOpenXml;
using System.Security.Principal;
using System;
using System.Web.Http;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;
using System.Web.Security;
using CrowdfundingWebsites.Models.Services;
using System.Web;

namespace CrowdfundingWebsites
{
    public class MvcApplication : System.Web.HttpApplication
    {
        protected void Application_Start()
        {
            // 這裡要加上這行, 才會讓 AutoMapper 能夠找到 MappingProfile 類別
            var config = new MapperConfiguration(cfg => {
                // cfg.CreateMap<Category, CategoryDto>(); //如果需要一個個對應, 就這樣寫
                cfg.AddProfile<MappingProfile>();
            });
            AutoMapperHelper.MapperObj = new Mapper(config);
            ExcelPackage.LicenseContext = LicenseContext.NonCommercial;


            AreaRegistration.RegisterAllAreas();
            GlobalConfiguration.Configure(WebApiConfig.Register);
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
        }

        protected void Application_AuthenticateRequest()
        {
            if (!Request.IsAuthenticated) return;

            var id = (FormsIdentity)User.Identity;
            FormsAuthenticationTicket ticket = id.Ticket;
            string functions = ticket.UserData;

            IPrincipal currentUser = new UserPrincipal(User.Identity, ticket.Name, functions);
            Context.User = currentUser;
        }


        //protected void Application_Error(object sender, EventArgs e)
        //{
        //    Exception exception = Server.GetLastError();
        //    if (exception is HttpException && ((HttpException)exception).GetHttpCode() == 404)
        //    {
        //        Server.ClearError();
        //        Response.Redirect("~/Shared/_ErrorPartial");
        //    }
        //}
    }


    public static class AutoMapperHelper
    {
        public static Mapper MapperObj { get; set; }
    }


}
