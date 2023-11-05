using CrowdfundingWebsites.Models.Interface;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace CrowdfundingWebsites.Models.ViewModels
{
    public class CategoryVm : IDataVm
    {
        public int Id { get; set; }

        [Display(Name = "名稱", Order = 0)]
        [Required(ErrorMessage = "{0} 必填")]
        public string Name { get; set; }

        [Display(Name ="描述", Order = 1)]
        public string Description { get; set; }

        [Display(Name = "類型", Order = 2)]
        [Required(ErrorMessage = "{0} 必填")]
        public string Type { get; set; }

        [Display(Name = "排序", Order = 3)]
        [Required(ErrorMessage = "{0} 必填")]
        public int DisplayOrder { get; set; }
    }
}