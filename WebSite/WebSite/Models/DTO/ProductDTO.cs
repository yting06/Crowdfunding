namespace CrowdfundingWebsites.Models.DTO
{
    using CrowdfundingWebsites.Models.EFModels;
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class ProductDTO
    {
        public int Id { get; set; }

        [Required]
        [StringLength(1000)]
        public string Detail { get; set; }

        public int Qty { get; set; }

        public int Price { get; set; }

        public int RemainingCount { get; set; }


        [Required]
        [StringLength(1000)]
        public string Image { get; set; }

        public DateTime StartTime { get; set; }

        public DateTime EndTime { get; set; }

        public int ShippingDays { get; set; }

        public bool Enabled { get; set; }

        public DateTime UpdateTime { get; set; }

        public DateTime? ApplyTime { get; set; }

        public virtual Project Project { get; set; }


    }
}
