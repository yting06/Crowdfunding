namespace CrowdfundingWebsites.Models.EFModels
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class FAQ
    {
        public int Id { get; set; }

        [Column(TypeName = "text")]
        [Required]
        public string Question { get; set; }

        [Column(TypeName = "text")]
        [Required]
        public string Answer { get; set; }

        public int DisplayOrder { get; set; }

        public DateTime CreatedDate { get; set; }

        public DateTime UpdatedDate { get; set; }

        public int CategoryId { get; set; }

        public virtual Category Category { get; set; }
    }
}
