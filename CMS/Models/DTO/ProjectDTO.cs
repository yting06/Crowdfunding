using CrowdfundingWebsites.Models.EFModels;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace CrowdfundingWebsites.Models.DTO
{
    public class ProjectDTO
    {
        public int Id { get; set; }

        public string Name { get; set; }

        public string Image { get; set; }

        public string Description { get; set; }

        public int Goal { get; set; }

        public DateTime StartTime { get; set; }

        public DateTime EndTime { get; set; }

        public int ShippingDays { get; set; }

        public bool Enabled { get; set; }

        public DateTime UpdateTime { get; set; }

        public DateTime? ApplyTime { get; set; }

        public Category Status { get; set; }
        public Category Category { get; set; }
        public Company Company { get; set; }



    }
}