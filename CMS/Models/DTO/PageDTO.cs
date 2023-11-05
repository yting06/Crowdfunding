using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace CrowdfundingWebsites.Models.DTO
{
    public class PageDTO
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public bool Visible { get; set; }
        public string KeyValue { get; set; }
        public int? ParentId { get; set; }
        public List<FunctionDTO> Functions { get; set; }
    }

}