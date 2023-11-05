using CrowdfundingWebsites.Models.EFModels;
using CoraLibrary.SqlDataLayer;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using CrowdfundingWebsites.Models.ViewModels;
using System.Dynamic;

namespace CrowdfundingWebsites.Models.Repositories
{
    public class CategoryRepository
    {
        private string _connectionKey = "AppDBContext";

        private readonly AppDBContext _db;

        public CategoryRepository()
        {
            _db = new AppDBContext();
        }


        public void Update(Category category)
        {
            var item = _db.Categories
                .FirstOrDefault(c => c.Id == category.Id);

            item.Name = category.Name;
            item.Description = category.Description;
            item.Type = category.Type;
            item.DisplayOrder = category.DisplayOrder;

            _db.SaveChanges();
        }


        public void Add(Category category)
        {
            _db.Categories.Add(category);
            _db.SaveChanges();
        }

        public void Delete(int id)
        {
            var item = _db.Categories.FirstOrDefault(c => c.Id == id);
            if (item == null) return;
            _db.Categories.Remove(item);
            _db.SaveChanges();
        }

        public Category Get(int id)
        {
            return _db.Categories
                .AsNoTracking()
                .Where(item => item.Id == id).FirstOrDefault();
        }

        public List<string> GetTypeList()
        {
            string sql = @"SELECT DISTINCT c.Type FROM Categories c";
            return new SqlDb().GetAll<string>(_connectionKey, sql);
        }

        public List<Category> GetCategoriesByType(string type)
        {
            string specialtype = "all";
            return _db.Categories.Where(c => type == specialtype || c.Type == type).ToList();
        }

        public (IEnumerable<Category> data, int total) GetAllByCondiction(SearchCategoryVm vm)
        {
            string value = vm.SearchValue;
            string sType = vm.Type;
            bool isTypeEmpty = string.IsNullOrEmpty(sType) || sType == "all";

            var allData = _db.Categories.Where(x => (isTypeEmpty || sType == x.Type));
            if (!string.IsNullOrEmpty(value))
            {
                allData = allData.Where(x =>
                                    x.Type.IndexOf(value) > -1 ||
                                    x.Name.IndexOf(value) > -1 ||
                                    x.Description.IndexOf(value) > -1 ||
                                    x.DisplayOrder.ToString().IndexOf(value) > -1);
            }

            var total = allData.Count();
            var data = allData.OrderBy(e => e.Id)
                              .Skip(vm.PageStart)
                              .Take(vm.PageSize).ToList();

            return (data, total);
        }

    }
}