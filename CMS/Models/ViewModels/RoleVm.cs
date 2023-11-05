using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace CrowdfundingWebsites.Models.ViewModels
{
    public class RoleVm
    {
        public int Id { get; set; }

        [Required]
        [Display(Name = "名稱")]
        [StringLength(100)]
        public string Name { get; set; }

        [Required]
        [StringLength(150)]
        public string Type { get; set; } = "WebOrg";

        public bool ReadOnly { get; set; }
    }
}