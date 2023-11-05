using CrowdfundingWebsites.Models.EFModels;
using CrowdfundingWebsites.Models.Repositories;
using CrowdfundingWebsites.Models.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Remoting.Messaging;
using System.Web;
using System.Web.Mvc;

namespace CrowdfundingWebsites.Models.Services
{
    public class AboutUsService
    {
        private readonly AboutUsRepository _repository;
        public AboutUsService()
        {
            _repository = new AboutUsRepository();
        }

        public AboutUsVm GetData() 
        {
            var data = _repository.Get();
            var vm = AutoMapperHelper.MapperObj.Map<AboutUsVm>(data);

            return vm;
        } 



        
    }
}