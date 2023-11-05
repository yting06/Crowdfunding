using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace CrowdfundingWebsites.Models.Infra
{
    public class Password : ValidationAttribute
    {

        public Password()
        {
            ErrorMessage = "The length of the string must be an even number.";
        }

        public override bool IsValid(object value)
        {
            if (value is string str)
            {
                return str.Length % 2 == 0;
            }
            return false;
        }
    }

}