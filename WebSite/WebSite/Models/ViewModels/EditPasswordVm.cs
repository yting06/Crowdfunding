﻿using CrowdfundingWebsites.Models.Infra;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Xml.Linq;

namespace CrowdfundingWebsites.Models.ViewModels
{
	public class EditPasswordVm
	{
		[Display(Name = "原始密碼")]
		[Required(ErrorMessage = DAHelper.Required)]
		[StringLength(50, ErrorMessage = DAHelper.StringLength)]
		[DataType(DataType.Password)]
		public string OriginalPassword { get; set; }

		[Display(Name = "新密碼")]
		[Required(ErrorMessage = DAHelper.Required)]
		[StringLength(50, ErrorMessage = DAHelper.StringLength)]
		[DataType(DataType.Password)]
		public string Password { get; set; }

		[Display(Name = "確認密碼")]
		[Required(ErrorMessage = DAHelper.Required)]
		[StringLength(50, ErrorMessage = DAHelper.StringLength)]
		[Compare(nameof(Password), ErrorMessage = DAHelper.Compare)]
		[DataType(DataType.Password)]
		public string ConfirmPassword { get; set; }
	}
}