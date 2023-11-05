﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Xml.Linq;

namespace CrowdfundingWebsites.Models.ViewModels
{
	public class CompanyLoginVm
	{
		[Display(Name = "帳號")]
		[Required(ErrorMessage ="請輸入帳號")]
		public string Account { get; set; }


		[Display(Name = "密碼")]
		[Required(ErrorMessage = "請輸入密碼")]
		[DataType(DataType.Password)]
		public string Password { get; set; }

	}
}