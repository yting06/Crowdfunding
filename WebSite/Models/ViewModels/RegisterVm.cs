using CrowdfundingWebsites.Models.Infra;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Web;
using System.Xml.Linq;

namespace CrowdfundingWebsites.Models.ViewModels
{
	public class RegisterVm
	{
		public int Id { get; set; }

		[Display(Name = "帳號")]
		[Required(ErrorMessage = DAHelper.Required)]
		[StringLength(50, ErrorMessage = DAHelper.StringLength)]
		public string Account { get; set; }

		[Display(Name = "密碼")]
		[Required(ErrorMessage = DAHelper.Required)]
		[StringLength(50, ErrorMessage = DAHelper.StringLength)]
		[DataType(DataType.Password)]
		public string Password { get; set; }

		[Display(Name = "確認密碼")]
		[Required(ErrorMessage = DAHelper.Required)]
		[StringLength(250, ErrorMessage = DAHelper.StringLength)]
		[Compare(nameof(Password))]
		[DataType(DataType.Password)]
		public string ConfirmPassword { get; set; }

		[Display(Name = "姓名")]
		[Required(ErrorMessage = DAHelper.Required)]
		[StringLength(50, ErrorMessage = DAHelper.StringLength)]

		public string Name { get; set; }

		[Required]
		[StringLength(250)]
		[EmailAddress]
		public string Email { get; set; }

	}
}