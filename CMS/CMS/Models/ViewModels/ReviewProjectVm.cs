using CrowdfundingWebsites.Models.EFModels;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace CrowdfundingWebsites.Models.ViewModels
{
    public class ReviewProjectVm
    {

        public int Id { get; set; }

        public string Name { get; set; }

        public string Description { get; set; }

        public bool Enabled { get; set; }

        public int Goal { get; set; }

        public string StatusName { get; set; }  //Category
        public string CategoryName { get; set; }
        public string CompanyName { get; set; }

        public DateTime UpdateTime { get; set; }
        
        public DateTime? ApplyTime { get; set; }



    }
}