namespace CrowdfundingWebsites.Models.EFModels
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("RoleFunctionRel")]
    public partial class RoleFunctionRel
    {
        public int Id { get; set; }

        public int RoleId { get; set; }

        public int FunctionId { get; set; }

        public virtual Function Function { get; set; }

        public virtual Role Role { get; set; }
    }
}
