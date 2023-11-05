using CrowdfundingWebsites.Models.Interface;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Xml.Linq;

namespace CrowdfundingWebsites.Models.ViewModels
{
    public class ManagerProfileVm : IDataVm
    {
        public int Id { get ; set; }

        [Required]
        [Display(Name = "名")]
        [StringLength(550)]
        public string FirstName { get; set; }

        [Required]
        [Display(Name = "姓")]
        [StringLength(550)]
        public string LastName { get; set; }

        [Required]
        [Display(Name = "Email")]
        [EmailAddress]
        [StringLength(550)]
        public string Email { get; set; }

        [Display(Name = "生日")]
        [DataType(DataType.Date)]
        [DisplayFormat(DataFormatString = "{0:yyyy-MM-dd}", ApplyFormatInEditMode = true)]
        public DateTime? Birthday { get; set; }

    }
}