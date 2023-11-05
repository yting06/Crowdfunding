using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace CrowdfundingWebsites.Models.DTO
{
    public class ManagerDTO
    {

        public int Id { get; set; }

        public string Account { get; set; }

        public string Password { get; set; }

        public string Email { get; set; }

        public string FirstName { get; set; }

        public string LastName { get; set; }

        public DateTime? Birthday { get; set; }

        public bool Enabled { get; set; }

        public DateTime UpdateTime { get; set; }

        public string ConfirmCode { get; set; }

        public bool? IsConfirmed { get; set; }

    }
}