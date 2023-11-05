namespace CrowdfundingWebsites.Models.EFModels
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class AboutU
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

        public DateTime CreatedDate { get; set; }

        public DateTime UpdatedDate { get; set; }
    }
}
