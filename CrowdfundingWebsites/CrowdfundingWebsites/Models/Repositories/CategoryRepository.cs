using CrowdfundingWebsites.Models.EFModels;
using CoraLibrary.SqlDataLayer;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CrowdfundingWebsites.Models.Repositories
{
    public class CategoryRepository
    {
        private string _connectionKey = "AppDBContext";

        public List<string> GetTypeList()
        {
            string sql = @"SELECT DISTINCT c.Type FROM Categories c";
            return new SqlDb().GetAll<string>(_connectionKey, sql);
        }
        
    }
}