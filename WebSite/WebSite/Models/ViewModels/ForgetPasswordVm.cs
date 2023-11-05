using CrowdfundingWebsites.Models.Infra;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Xml.Linq;

namespace CrowdfundingWebsites.Models.ViewModels
{
	public class ForgetPasswordVm
	{
		[Display(Name = "帳號")]
		[Required(ErrorMessage = DAHelper.Required)]
		[StringLength(50, ErrorMessage = DAHelper.StringLength)]
		public string Account { get; set; }

		[Display(Name = "Email")]
		[Required(ErrorMessage = DAHelper.Required)]
		[StringLength(250, ErrorMessage = DAHelper.StringLength)]
		public string Email { get; set; }
	}
}