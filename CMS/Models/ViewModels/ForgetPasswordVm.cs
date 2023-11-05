using CrowdfundingWebsites.Models.Infra;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace CrowdfundingWebsites.Models.ViewModels
{
    public class ForgetPasswordVm
    {
        [Display(Name = "帳號")]
        [Required(ErrorMessage = DAHelper.Require)]
        public string Account { get; set; }

        [Display(Name = "信箱")]
        [Required(ErrorMessage = DAHelper.Require)]
        [EmailAddress]
        [DataType(DataType.Password)]
        public string Email { get; set; }
    }
}