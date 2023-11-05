using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Xml.Linq;

namespace CrowdfundingWebsites.Models.ViewModels
{
	public class EditCompanyProfileVm
	{
		public int Id { get; set; }

		[Required(ErrorMessage ="請輸入Email")]
		[StringLength(256)]
		[EmailAddress]
		public string Email { get; set; }


		[Display(Name = "公司名稱")]
		[Required(ErrorMessage ="請輸入公司名稱")]
		[StringLength(30)]
		public string Name { get; set; }

		[Display(Name = "聯絡電話")]
		[StringLength(10)]
		public string Phone { get; set; }

		[Display(Name = "團隊負責人")]
		[StringLength(30)]
		public string ResponsiblePerson { get; set; }

		[Display(Name = "團隊簡介")]
		[StringLength(30)]
		public string Introduce { get; set; }

		[Display(Name = "圖片上傳")]
		//[Required]
		[StringLength(350)]
		public string Image { get; set; }

		[Display(Name = "建立時間")]
		[DisplayFormat(DataFormatString = "{0:yyyy/MM/dd}", ApplyFormatInEditMode = true)]
		public DateTime CreatedTime { get; set; }

		[Display(Name = "更新時間")]
		[DisplayFormat(DataFormatString = "{0:yyyy/MM/dd}", ApplyFormatInEditMode = true)]
		public DateTime UpdateTime { get; set; }

	}
}