using CrowdfundingWebsites.Models.EFModels;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel;
using System.Linq;
using System.Web;

namespace CrowdfundingWebsites.Models.DTO
{
    public class FAQDTO
    {
        public int Id { get; set; }

        public string Question { get; set; }

        public string Answer { get; set; }

        public int DisplayOrder { get; set; }

        public Category Category { get; set; }

        public DateTime CreatedDate { get; set; }

        public DateTime UpdatedDate { get; set; }
    }
}