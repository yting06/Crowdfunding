using CoraLibrary.Utilities;
using CrowdfundingWebsites.Models.Interface;
using CrowdfundingWebsites.Models.Repositories;
using CrowdfundingWebsites.Models.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CrowdfundingWebsites.Models.Services
{
    public class ProjectService: IService<ReviewProjectVm>
    {
        private readonly CompanyRepository _repo = new CompanyRepository();

        public ValidationResult Delete(int id)
        {
            throw new NotImplementedException();
        }

        public ReviewProjectVm Get(int id)
        {
            throw new NotImplementedException();
        }

        public (IEnumerable<ReviewProjectVm>, int) GetAll(ISearchVm searchVm)
        {
            var vm = (SearchProjectVm)searchVm;
            var dtos = _repo.GetProjects(vm);

            var data = dtos.Select(dto =>
            {
                var value = AutoMapperHelper.MapperObj.Map<ReviewProjectVm>(dto);

                value.StatusName = dto.Status.Name;
                value.CategoryName = dto.Category.Name;
                value.CompanyName = dto.Company.Name;
                return value;
            }).ToList();

            return (data, data.Count());
        }

        public void ProcessProjectStatus(int id, int status)
        {
            try
            {
                _repo.SetProjectStatus(id, status);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public ValidationResult Insert(IDataVm dataVm)
        {
            throw new NotImplementedException();
        }

        public ValidationResult Update(IDataVm dataVm)
        {
            throw new NotImplementedException();
        }
    }
}