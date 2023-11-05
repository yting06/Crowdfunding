using CrowdfundingWebsites.Models.EFModels;
using CrowdfundingWebsites.Models.Repositories;
using CrowdfundingWebsites.Models.ViewModels;
using CrowdfundingWebsites.Models.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using CoraLibrary.Utilities;

namespace CrowdfundingWebsites.Models.Services
{
    public class WebContentService: IService<FAQVm>
    {
        private readonly WebContentRepository _repo;
        public WebContentService()
        {
            _repo = new WebContentRepository();
        }


        public FAQVm Get(int id)
        {
            try
            {
                var faq = _repo.GetFAQ(id);
                if (faq == null) throw new Exception("找不到對應的資料");
                return AutoMapperHelper.MapperObj.Map<FAQVm>(faq);

            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public (IEnumerable<FAQVm>, int) GetAll(ISearchVm searchVm)
        {
            var vm = (SearchFAQVm)searchVm;
            var result = _repo.GetFAQsByCondiction(vm);
            var data = result.data?.Select(x => AutoMapperHelper.MapperObj.Map<FAQVm>(x)).ToList();

            return (data, result.total);
        }

        public ValidationResult Insert(IDataVm dataVm)
        {
            try
            {
                var faqVm = (FAQVm)dataVm;
                var faq = AutoMapperHelper.MapperObj.Map<FAQ>(faqVm);
                faq.CreatedDate = DateTime.Now;
                faq.UpdatedDate = DateTime.Now;

                _repo.CreateFAQ(faq);
                return ValidationResult.Success();
            }
            catch (Exception ex)
            {
                return ValidationResult.Fail(ex.Message);
            }
        }

        public ValidationResult Update(IDataVm dataVm)
        {
            try
            {
                var faq = (FAQVm)dataVm;
                _repo.UpdateFAQ(faq);

                return ValidationResult.Success();
            }
            catch (Exception ex)
            {
                return ValidationResult.Fail(ex.Message);
            }
        }

        public ValidationResult Delete(int id)
        {
            try
            {
                _repo.Delete(id);
                return ValidationResult.Success();
            }
            catch (Exception ex)
            {
                return ValidationResult.Fail(ex.Message);
            }
        }


        public void InsertFAQs(List<FAQ> vms)
        {
            try
            {
                var faqs = vms.Select(item => {
                    item.UpdatedDate = DateTime.Now;
                    return item;
                }).ToList();
                _repo.InsertFAQs(faqs);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }


    }
}