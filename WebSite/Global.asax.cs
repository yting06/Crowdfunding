using AutoMapper;
using CrowdfundingWebsites.App_Start;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;

namespace CrowdfundingWebsites
{
    public class MvcApplication : System.Web.HttpApplication
    {
        protected void Application_Start()
        {

            var config = new MapperConfiguration(cfg => {
                // cfg.CreateMap<Category, CategoryDto>(); //如果需要一個個對應, 就這樣寫
                cfg.AddProfile<MappingProfile>();
            });
            AutoMapperHelper.MapperObj = new Mapper(config);


            AreaRegistration.RegisterAllAreas();
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
        }
    }


    public static class AutoMapperHelper
    {
        public static Mapper MapperObj { get; set; }
    }
}
