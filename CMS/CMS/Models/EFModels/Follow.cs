namespace CrowdfundingWebsites.Models.EFModels
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class Follow
    {
        public int Id { get; set; }

        public int MemberId { get; set; }

        public int ProjectId { get; set; }

        public virtual Member Member { get; set; }

        public virtual Project Project { get; set; }
    }
}
