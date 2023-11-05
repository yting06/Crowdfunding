namespace CrowdfundingWebsites.Models.EFModels
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("RolePageRel")]
    public partial class RolePageRel
    {
        public int Id { get; set; }

        public int RoleId { get; set; }

        public int PageId { get; set; }

        public virtual Page Page { get; set; }

        public virtual Role Role { get; set; }
    }
}
