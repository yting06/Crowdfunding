using CrowdfundingWebsites.Models.DTO;
using CrowdfundingWebsites.Models.Services;
using Dapper;
using Microsoft.Ajax.Utilities;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data.Entity.SqlServer;
using System.Linq;
using System.Security.Cryptography;
using System.Web;
using System.Web.Helpers;

namespace CrowdfundingWebsites.Models.Infra
{
    public class ViewHelper
    {
        private string Layout = "V_Layout.json";

        public IEnumerable<NavListItem> GetLayoutAuthorizeList(string key, Dictionary<string, List<int>> userFunctions)
        {
            var pageDict = GetPageAuthInfo();
            var ValidFunc = GetValidFunction(pageDict, userFunctions);

            List<NavListItem> result = new List<NavListItem>();
            var list = GetAll(key);

            foreach (var item in list)
            {
                if (item.Children != null)
                {
                    var valid = item.Children.FirstOrDefault(o => ValidFunc(o));
                    if (valid != null) result.Add(item);
                    continue;
                }
                else if (ValidFunc(item)) result.Add(item);
            }
            return result;
        }


        private Func<NavListItem, bool> GetValidFunction(Dictionary<string, PageDTO> dict, Dictionary<string, List<int>> userDict)
        {
            var pages = userDict["Pages"];
            var functions = userDict["Functions"];

            return (item) =>
            {
                if (dict.TryGetValue(item.Key, out var dto) && pages.IndexOf(dto.Id) > -1)
                {
                    return dto.Functions.Any(f => functions.IndexOf(f.Id) > -1);
                }
                return false;
            };
        }

        private Dictionary<string, PageDTO> GetPageAuthInfo()
        {
            var pageInfos = new PermissionService().GetPagePermission();

            return pageInfos.ToDictionary(p => p.KeyValue, p => p);
        }

        private IEnumerable<NavListItem> GetAll(string key)
        {
            string strLayout = GetJSONFileData(Layout);
            JObject jsonObject = JObject.Parse(strLayout);
            JObject joLayout = jsonObject["Layout"].ToObject<JObject>();

            return joLayout[key].ToObject<List<NavListItem>>();
        }

        private string GetJSONFileData(string fileName)
        {
            var fHelper = new FileHelper();
            return fHelper.GetFileData(fileName);
        }



    }


    public class NavListItem
    {
        public string Key { get; set; }
        public string Title { get; set; }
        public string Url { get; set; }
        public string CssIcon { get; set; }
        public IEnumerable<NavListItem> Children { get; set; }
    }
}