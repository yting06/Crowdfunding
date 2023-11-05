using CoraLibrary.SqlDataLayer;
using CrowdfundingWebsites.Models.DTO;
using CrowdfundingWebsites.Models.EFModels;
using CrowdfundingWebsites.Models.ViewModels;
using Dapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CrowdfundingWebsites.Models.Repositories
{
    public class WebContentRepository
    {
        private readonly AppDBContext _db;
        private const string _cnnKey = "AppDBContext";
        public WebContentRepository()
        {
            _db = new AppDBContext();
        }

        public (IEnumerable<FAQDTO> data, int total) GetFAQsByCondiction(SearchFAQVm vm)
        {
            string value = vm.SearchValue;

            string sql = @"
SELECT F.*, C.* 
FROM Categories C
INNER JOIN FAQs F ON F.CategoryId = C.Id
WHERE C.Type ='FAQs' AND (@Type is NULL OR C.Id = @Type)
ORDER BY F.Id;";

            using (var cnn = new SqlDb().GetSqlConnection(_cnnKey))
            {
                var list = cnn.Query<FAQ, Category, FAQDTO>(sql, (f, c) =>
                 {
                     var dto = AutoMapperHelper.MapperObj.Map<FAQDTO>(f);
                     dto.Category = c;
                     return dto;
                 }, vm);

                var total = list.Count();
                if (!string.IsNullOrEmpty(value))
                {
                    list = list.Where(d =>
                    d.Question.IndexOf(value) > -1 ||
                    d.Answer.IndexOf(value) > -1);
                }
                var result = list.Skip(vm.PageStart).Take(vm.PageSize).ToList();


                return (result, total);
            }

        }


        public void InsertFAQs(IEnumerable<FAQ> faqs)
        {
            _db.FAQs.AddRange(faqs);
            _db.SaveChanges();

        }

        public FAQDTO GetFAQ(int id)
        {
            var faq = _db.FAQs
                .Include("Category")
                .Where(item => item.Id == id)
                .FirstOrDefault();

            return faq == null ? null : AutoMapperHelper.MapperObj.Map<FAQDTO>(faq);
        }

        public void UpdateFAQ(FAQVm vm)
        {
            var faq = _db.FAQs.FirstOrDefault(item => item.Id == vm.Id);

            faq.Answer = vm.Answer;
            faq.Question = vm.Question;
            faq.UpdatedDate = DateTime.Now;
            faq.CategoryId = vm.CategoryId;

            _db.SaveChanges();
        }

        public void CreateFAQ(FAQ faq)
        {
            _db.FAQs.Add(faq);
            _db.SaveChanges();
        }

        public void Delete(int id)
        {
            var item = _db.FAQs.FirstOrDefault(m => m.Id == id);
            _db.FAQs.Remove(item);
            _db.SaveChanges();
        }



    }
}