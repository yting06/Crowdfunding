using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace CrowdfundingWebsites.Models.DTO
{
    public class FunctionDTO
    {

        public int Id { get; set; }

        public string KeyValue { get; set; }

        public string Name { get; set; }

        public string Description { get; set; }

        public bool Visible { get; set; }

        public int ParentPageId { get; set; }

    }
}