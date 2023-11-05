using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace CrowdfundingWebsites.Models.ViewModels
{
    public class AboutUsVm
    {
        public int Id { get; set; }

        [Required]
        [StringLength(10)]
        public string Title { get; set; }

        [Column(TypeName = "text")]
        [Required]
        public string Contents { get; set; }

        [Required]
        public string Image { get; set; }

    }
}