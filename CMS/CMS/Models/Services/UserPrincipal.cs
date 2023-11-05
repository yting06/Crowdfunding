using Newtonsoft.Json.Linq;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;
using System.Security.Principal;

namespace CrowdfundingWebsites.Models.Services
{
    public class UserPrincipal : IPrincipal
    {

        public readonly Dictionary<string, List<int>> FuncsDict;
        public readonly string Account;

        public IIdentity Identity { get; private set; }

        public UserPrincipal(IIdentity identity, string account, string functions)
        {
            this.Account = account;
            this.Identity = identity;
            FuncsDict = ParseUserFunctions(functions);
        }

        private Dictionary<string, List<int>> ParseUserFunctions(string functions)
        {
            string[] keys = new string[] { "Pages", "Functions" };
            JObject jo = JsonConvert.DeserializeObject<JObject>(functions);
            Dictionary<string, List<int>> dict = new Dictionary<string, List<int>>();

            foreach (string key in keys)
            {
                dict.Add(key, jo[key].ToObject<List<int>>());
            }
            return dict;
        }

        public bool IsInRole(string functionKey)
        {
            return true; // _functions.Contains(functionKey);
        }




    }
}