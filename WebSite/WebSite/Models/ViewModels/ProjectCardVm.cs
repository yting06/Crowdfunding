using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CrowdfundingWebsites.Models.ViewModels
{
    public class ProjectCardVm
    {
        public int Id { get; set; }
        public string Title { get; set; }

        public string Image { get; set; }
        public int SupportMoney { get; set; }
        public int SupportCount { get; set; }

        public float SupportPercent { get; set; }

        public int Days { get; set; }

        public DateTime FinishDates { get; set; }

    }
}