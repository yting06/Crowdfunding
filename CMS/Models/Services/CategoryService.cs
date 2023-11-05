using System.Collections.Generic;
using System.Linq;
using System;
using CrowdfundingWebsites.Models.ViewModels;
using CrowdfundingWebsites.Models.Interface;
using CrowdfundingWebsites.Models.EFModels;
using CrowdfundingWebsites.Models.Repositories;
using CoraLibrary.Utilities;

namespace CrowdfundingWebsites.Models.Services
{
    public class CategoryService : IService<CategoryVm>
    {
        private readonly CategoryRepository _repo;

        public CategoryService()
        {
            _repo = new CategoryRepository();
        }

        public CategoryVm Get(int id)
        {
            var category = _repo.Get(id);
            if (category == null) throw new Exception("找不到對應的資料");

            return AutoMapperHelper.MapperObj.Map<CategoryVm>(category);
        }
        public (IEnumerable<CategoryVm>, int) GetAll(ISearchVm searchVm)
        {
            var vm = (SearchCategoryVm)searchVm;
            var result = _repo.GetAllByCondiction(vm);
            var data = result.data?.Select(x => AutoMapperHelper.MapperObj.Map<CategoryVm>(x)).ToList();

            return (data, result.total);
        }

        public ValidationResult Insert(IDataVm dataVm)
        {
            try
            {
                var vm = dataVm as CategoryVm;
                var item = AutoMapperHelper.MapperObj.Map<Category>(vm);
                _repo.Add(item);

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
                var vm = (CategoryVm)dataVm;
                var item = AutoMapperHelper.MapperObj.Map<Category>(vm);
                _repo.Update(item);

                return ValidationResult.Success();
            }
            catch (Exception ex)
            {
                return ValidationResult.Fail(ex.Message);
            }
        }
        //todo Category DELETE
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



        public IEnumerable<CategoryVm> GetCategoryByType(string type)
        {
            var list = _repo.GetCategoriesByType(type)
                            .Select(c => AutoMapperHelper.MapperObj.Map<CategoryVm>(c))
                            .ToList();
            return list;
        }

        public IEnumerable<string> GetTypeList()
        {
            return _repo.GetTypeList();
        }



    }
}