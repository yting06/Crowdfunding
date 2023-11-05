using CrowdfundingWebsites.Models.EFModels;
using CrowdfundingWebsites.Models.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CrowdfundingWebsites.Models.Repositories
{
    public class AboutUsRepository
    {
        private readonly AppDBContext _db;

        public AboutUsRepository()
        {
            _db = new AppDBContext();
        }

        public AboutU Get()
        {
            return _db.AboutUs.FirstOrDefault();
        }


        public void Update(AboutUsVm vm)
        {

            var data = _db.AboutUs
                .Where(m => m.Id == vm.Id)
                .FirstOrDefault();

            if (data == null) throw new Exception("找不到對應資料");

            data.Title = vm.Title;
            data.Contents = vm.Contents;
            data.Image  = vm.Image;
            data.UpdatedDate = DateTime.Now;

            _db.SaveChanges();
        }
    }
}