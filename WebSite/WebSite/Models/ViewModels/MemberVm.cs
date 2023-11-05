using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace CrowdfundingWebsites.Models.ViewModels
{
    public class MemberVm
    {
        public int Id { get; set; }

        public string Name { get; set; }

        public string Email { get; set; }

        public DateTime? Birthday { get; set; }
        public DateTime CreatedTime { get; set; }

        public string Introduce { get; set; }

        public string Image { get; set; }
    }
}