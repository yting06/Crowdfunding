using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CrowdfundingWebsites.Models.ViewModels
{
    public class SearchProjectVm
    {

        public int? ProjectType { get; set; }

        public string SearchValue { get; set; }
    }
}