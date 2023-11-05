using CrowdfundingWebsites.Models.Repositories;
using CrowdfundingWebsites.Models.EFModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using CrowdfundingWebsites.Models.ViewModels;

namespace CrowdfundingWebsites.Models.Services
{
    public class CategoryService
    {
        public IEnumerable<CategoryVm> GetCategoryByType(string tpye = "all")
        {
            string specialtype = "all";
            var db = new AppDBContext();
            return db.Categories
                .Where(c => tpye == specialtype || c.Type == tpye)
                .Select(x=> new CategoryVm {
                    Id = x.Id,
                    Name = x.Name,
                    Description = x.Description,
                    DisplayOrder = x.DisplayOrder,
                    Type = x.Type
                }).ToList();
        }


        public IEnumerable<Category> GetAll()
        {
            var db = new AppDBContext();
            return db.Categories.ToList();
        }

        public IEnumerable<string> GetTypeList()
        {
            return new CategoryRepository().GetTypeList();
        }






    }
}