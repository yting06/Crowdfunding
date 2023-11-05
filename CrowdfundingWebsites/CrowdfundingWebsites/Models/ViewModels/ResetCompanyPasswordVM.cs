using CrowdfundingWebsites.Models.Infra;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Xml.Linq;

namespace CrowdfundingWebsites.Models.ViewModels
{
	public class ResetCompanyPasswordVM
	{
		[Display(Name = "新密碼")]
		[Required(ErrorMessage = DAHelper_Company.Required)]
		[StringLength(50, ErrorMessage = DAHelper_Company.StringLength1)]
		[DataType(DataType.Password)]
		public string Password { get; set; }

		[Display(Name = "確認密碼")]
		[Required(ErrorMessage = DAHelper_Company.Required)]
		[StringLength(50, ErrorMessage = DAHelper_Company.StringLength1)]
		[Compare(nameof(Password), ErrorMessage = DAHelper_Company.Compare)]
		[DataType(DataType.Password)]
		public string ConfirmPassword { get; set; }

	}
}