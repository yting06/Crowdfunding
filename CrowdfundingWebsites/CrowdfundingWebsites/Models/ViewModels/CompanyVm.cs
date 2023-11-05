using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace CrowdfundingWebsites.Models.ViewModels
{
    public class CompanyVm
    {
        public int Id { get; set; }

        [Required]
        [StringLength(100)]
        public string Account { get; set; }

        [Required]
        [StringLength(256)]
        public string Email { get; set; }

        [Required]
        [StringLength(100)]
        public string Name { get; set; }

        [Required]
        [StringLength(10)]
        public string Phone { get; set; }

        [Required]
        [StringLength(10)]
        public string UnifiedBusinessNo { get; set; }

        [Required]
        [StringLength(100)]
        public string ResponsiblePerson { get; set; }

        [Required]
        [StringLength(50)]
        public string Password { get; set; }

        public bool Status { get; set; }

		[DataType(DataType.MultilineText)]
		[Required]
        [StringLength(1000)]
        public string Introduce { get; set; }

        [Required]
        [StringLength(350)]
        public string Image { get; set; }

        public DateTime CreatedTime { get; set; }

        public DateTime? ApplyTime { get; set; }

        public DateTime? UpdateTime { get; set; }
    }
}