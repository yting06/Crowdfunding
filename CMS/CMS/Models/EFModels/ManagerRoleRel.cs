namespace CrowdfundingWebsites.Models.EFModels
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("ManagerRoleRel")]
    public partial class ManagerRoleRel
    {
        public int Id { get; set; }

        public int ManagerId { get; set; }

        public int RoleId { get; set; }

        public virtual Manager Manager { get; set; }

        public virtual Role Role { get; set; }
    }
}
