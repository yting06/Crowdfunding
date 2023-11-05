using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Xml.Linq;

namespace CrowdfundingWebsites.Models.ViewModels
{
    public class ColumnVm
    {
        public string Field { get; set; }

        public string Label { get; set; }

    }
}