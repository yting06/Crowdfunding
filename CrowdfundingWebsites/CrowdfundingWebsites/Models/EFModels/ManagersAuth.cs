namespace CrowdfundingWebsites.Models.EFModels
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class ManagersAuth
    {
        public int Id { get; set; }

        [Required]
        [StringLength(250)]
        public string Account { get; set; }

        [Required]
        public string Json { get; set; }
    }
}
