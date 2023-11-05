using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CrowdfundingWebsites.Models.Interface
{
    public interface ISearchVm
    {
        int PageStart { get; set; }
        int PageSize { get; set; }
        string SearchValue { get; set; }
    }
}