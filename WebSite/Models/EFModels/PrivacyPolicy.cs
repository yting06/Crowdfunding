namespace CrowdfundingWebsites.Models.EFModels
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class PrivacyPolicy
    {
        public int Id { get; set; }

        [Column(TypeName = "text")]
        [Required]
        public string Title { get; set; }

        [Column(TypeName = "text")]
        [Required]
        public string Contents { get; set; }

        public int TypeId { get; set; }

        public DateTime EffectiveDate { get; set; }

        public DateTime CreatedDate { get; set; }

        public DateTime UpdatedDate { get; set; }

        public virtual Category Category { get; set; }
    }
}
