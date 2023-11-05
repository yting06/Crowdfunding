using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace CrowdfundingWebsites.Models.ViewModels
{
    public class CategoryVm
    {
        public int Id { get; set; }

        [Display(Name = "名稱", Order = 0)]
        public string Name { get; set; }

        [Display(Name ="描述", Order = 1)]
        public string Description { get; set; }

        [Display(Name = "排序", Order = 2)]
        public int DisplayOrder { get; set; }

        [Display(Name = "類型", Order = 2)]
        public string Type { get; set; }
    }
}