using CrowdfundingWebsites.Models.EFModels;
using CrowdfundingWebsites.Models.Interface;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace CrowdfundingWebsites.Models.ViewModels
{
    public class ManagerVm : IDataVm
    {
        public int Id { get; set; }

        [Required]
        [Display(Name = "帳號")]
        [StringLength(250)]
        public string Account { get; set; }

        [Required]
        [Display(Name = "Email")]
        [EmailAddress]
        [StringLength(550)]
        public string Email { get; set; }

        [Required]
        [Display(Name = "名")]
        [StringLength(550)]
        public string FirstName { get; set; }


        [Required]
        [Display(Name = "姓")]
        [StringLength(550)]
        public string LastName { get; set; }


        [Required]
        [Display(Name = "密碼")]
        public string Password { get; set; }

        [Display(Name = "生日")]
        [DataType(DataType.Date)]
        [DisplayFormat(DataFormatString = "{0:yyyy-MM-dd}", ApplyFormatInEditMode = true)]
        public DateTime? Birthday { get; set; }

        [Display(Name = "啟用")]
        public bool Enabled { get; set; }

        [Display(Name = "驗證")]
        public bool IsConfirmed { get; set; }
        public string ConfirmCode { get; set; }

        public DateTime? CreatedTime { get; set; }

        public DateTime? UpdateTime { get; set; }


    }
}