using CoraLibrary.SqlDataLayer;
using CrowdfundingWebsites.Models.DTO;
using CrowdfundingWebsites.Models.EFModels;
using CrowdfundingWebsites.Models.ViewModels;
using Dapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Web;

namespace CrowdfundingWebsites.Models.Repositories
{
    public class CompanyRepository
    {
        private readonly string _cnnKey = "AppDBContext";

        public IEnumerable<ProjectDTO> GetProjects(SearchProjectVm searchCategoryVm)
        {
            string sql = @"
SELECT P.*, CO.*, C.*, S.*
FROM Projects P
INNER JOIN Companies CO ON CO.Id = P.CompanyId
INNER JOIN Categories C ON C.Id = P.CategoryId
INNER JOIN Categories S ON S.Id = P.StatusId
WHERE (@Type is NULL OR P.StatusId = @Type) AND
(@SearchValue is NULL OR P.Name LIKE '%@SearchValue%')
;";

            using (var cnn = new SqlDb().GetSqlConnection(_cnnKey))
            {
               return cnn.Query<Project, Company, Category, Category, ProjectDTO>(sql, (p, company, c, status) =>
                {
                    var dto = AutoMapperHelper.MapperObj.Map<ProjectDTO>(p);

                    dto.Company = company;
                    dto.Category = c;
                    dto.Status = status;
                    return dto;
                }, searchCategoryVm).ToList();
            }
        }

        public void SetProjectStatus(int id, int status)
        {
            var db = new AppDBContext();
            var project = db.Projects.FirstOrDefault(p => p.Id == id);
            if (project == null) throw new Exception("該專案不存在");

            project.StatusId = status;
            project.Enabled = status != 23;
            db.SaveChanges();
        }



    }
}