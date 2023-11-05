namespace CrowdfundingWebsites.Models.EFModels
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class Record
    {
        public int Id { get; set; }

        public int TotelOrders { get; set; }

        public int TotelProjects { get; set; }

        public int TotelCompleteProjects { get; set; }

        public DateTime UpdateTime { get; set; }
    }
}
