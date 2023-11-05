using CrowdfundingWebsites.Models.Infra;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Xml.Linq;

namespace CrowdfundingWebsites.Models.ViewModels
{
    public class PasswordVm
    {

        public string OldPassword { get; set; } = string.Empty;

        public string NewPassword { get; set; }

        public string ConfirmPassword { get; set;} = string.Empty;
    }

    public class ResetPasswordVm
    {
        public int Id { get; set; }

        [Display(Name = "密碼")]
        [Required(ErrorMessage = DAHelper.Require)]
        public string Password { get; set; }

        [Display(Name = "確認密碼")]
        [Required(ErrorMessage = DAHelper.Require)]
        [Compare("Password", ErrorMessage= DAHelper.Compare)]
        public string ConfirmPassword { get; set; } = string.Empty;
    }
}