using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Xml.Linq;

namespace CrowdfundingWebsites.Models.ViewModels
{
	public class EditCompanyPasswordVm
	{
		[Display(Name = "原始密碼")]
		[Required(ErrorMessage = "請輸入原始密碼")]
		[StringLength(50)]
		[DataType(DataType.Password)]
		public string OriginalPassword { get; set; }


		[Display(Name = "新密碼")]
		[Required(ErrorMessage = "請輸入新密碼")]
		[StringLength(50)]
		[DataType(DataType.Password)]
		public string Password { get; set; }




		[Display(Name = "確認密碼")]
		[Required(ErrorMessage ="請確認密碼")]
		[StringLength(50)]
		[Compare(nameof(Password))]
		[DataType(DataType.Password)]
		public string ConfirmPassword { get; set; }
	}
}