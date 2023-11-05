using CrowdfundingWebsites.Models.EFModels;
using CrowdfundingWebsites.Models.Interface;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace CrowdfundingWebsites.Models.ViewModels
{
    public class FAQVm: IDataVm
    {
        public int Id { get; set; }

        [Required]
        [DisplayName("問題")]
        [StringLength(500)]
        public string Question { get; set; }

        [Required]
        [DisplayName("回答")]
        [StringLength(500)]
        public string Answer { get; set; }

        [DisplayName("排序")]
        public int DisplayOrder { get; set; }

        public int CategoryId { get; set; }

        [DisplayName("類別")]
        public string CategoryName { get; set; }

        public DateTime UpdatedDate { get; set;}

    }
}