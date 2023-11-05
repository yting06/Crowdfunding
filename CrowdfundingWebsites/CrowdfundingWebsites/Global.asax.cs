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
	public static class AutoMapperHelper
	{
		public static Mapper MapperObj { get; set; }
	}
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
			AreaRegistration.RegisterAllAreas();
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
        }

	}
}
