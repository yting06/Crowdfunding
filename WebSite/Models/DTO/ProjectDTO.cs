namespace CrowdfundingWebsites.Models.DTO
{
    using CrowdfundingWebsites.Models.EFModels;
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class ProjectDTO
    {
        public int Id { get; set; }


        [Required]
        [StringLength(50)]
        public string Name { get; set; }

        [Required]
        [StringLength(1000)]
        public string Image { get; set; }

        [Required]
        [StringLength(1000)]
        public string Description { get; set; }

        public int Goal { get; set; }

        public int SupportCount { get; set; }
        public int SupportMoney { get; set; }
        public float SupportPercent { get; set; }


        public DateTime StartTime { get; set; }

        public DateTime EndTime { get; set; }

        public int ShippingDays { get; set; }

        public bool Enabled { get; set; }

        public DateTime UpdateTime { get; set; }

        public DateTime? ApplyTime { get; set; }

        public Category Category { get; set; }

        public virtual Category Status { get; set; }

        public virtual Company Company { get; set; }

        public ICollection<News> News { get; set; }

        public ICollection<ProductDTO> Products { get; set; }

    }
}
