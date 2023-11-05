using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Xml.Linq;

namespace CrowdfundingWebsites.Models.ViewModels
{
	public class CompanyRegisterVm
	{

		public int Id { get; set; }

		[Display(Name = "帳號")]
		[Required(ErrorMessage ="請輸入帳號")]
		[StringLength(30)]
		public string Account { get; set; }

		/// <summary>
		/// 明碼
		/// </summary>
		[Display(Name = "密碼")]
		[Required(ErrorMessage = "請輸入密碼")]
		[StringLength(50)]
		[DataType(DataType.Password)]
		public string Password { get; set; }

		[Display(Name = "確認密碼")]
		[Required(ErrorMessage = "請確認密碼")]
		[StringLength(50)]
		[Compare(nameof(Password))]
		[DataType(DataType.Password)]
		public string ConfirmPassword { get; set; }

		[Display(Name = "Email")]
		[Required(ErrorMessage = "請輸入Email")]
		[StringLength(256)]
		[EmailAddress]
		public string Email { get; set; }

		[Display(Name = "團隊名稱")]
		[Required(ErrorMessage = "請輸入團隊名稱")]
		[StringLength(30)]
		public string Name { get; set; }

		[Display(Name = "聯絡電話")]
		[StringLength(10)]
		public string Phone { get; set; }

		[Display(Name = "統一編號")]
		[Required(ErrorMessage = "請輸入統一編號")]
		[StringLength(10)]
		public string UnifiedBusinessNo { get; set; }

		[Display(Name = "團隊負責人")]
		[Required(ErrorMessage = "請輸入團隊負責人")]
		[StringLength(100)]
		public string ResponsiblePerson { get; set; }

		[Display(Name = "是否啟用")]
		public bool Status { get; set; }

		[DataType(DataType.MultilineText)]
		[Display(Name = "團隊介紹")]
		//[Required]
		[StringLength(1000)]
		public string Introduce { get; set; }

		[Display(Name = "圖片上傳")]
		//[Required]
		[StringLength(350)]
		public string Image { get; set; }

		[Display(Name = "建立時間")]
		public DateTime CreatedTime { get; set; }

		//[Display(Name = "申請時間")]
		//public DateTime? ApplyTime { get; set; }

		[Display(Name = "更新時間")]
		public DateTime UpdateTime { get; set; }

	}
}