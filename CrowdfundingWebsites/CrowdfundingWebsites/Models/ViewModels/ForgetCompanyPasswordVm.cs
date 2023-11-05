using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Xml.Linq;

namespace CrowdfundingWebsites.Models.ViewModels
{
	public class ForgetCompanyPasswordVm
	{
		[Display(Name = "帳號")]
		[Required(ErrorMessage = "{0}必須")]
		[StringLength(30)]
		public string Account { get; set; }

		[Display(Name = "Email")]
		[Required(ErrorMessage = "{0}必填")]
		[StringLength(256)]
		[EmailAddress]
		public string Email { get; set; }
	}
}