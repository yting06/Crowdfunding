using CrowdfundingWebsites.Models.EFModels;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Xml.Linq;

namespace CrowdfundingWebsites.Models.ViewModels
{
	public class ProjectVm
	{
		public int Id { get; set; }

		[Display(Name = "類別")]
		public int CategoryId { get; set; }

		[Display(Name = "類別")]
		public string CategoryName { get; set; }

		[Display(Name = "團隊名稱")]
		public int CompanyId { get; set; }

		[Display(Name = "專案名稱")]
		[Required(ErrorMessage ="請輸入專案名稱")]
		[StringLength(50)]
		public string Name { get; set; }

		[Display(Name = "圖片")]
		//[Required]
		[StringLength(1000)]
		public string Image { get; set; }

		[DataType(DataType.MultilineText)]
		[Display(Name = "商品描述")]
		[Required(ErrorMessage ="請輸入商品描述")]
		[StringLength(1000)]
		public string Description { get; set; }

		[Display(Name = "目標金額")]
		[Required(ErrorMessage ="請輸入目標金額")]
		public int Goal { get; set; }

		[Display(Name = "開始募資時間")]
		[DisplayFormat(DataFormatString = "{0:yyyy-MM-dd}", ApplyFormatInEditMode =true)]
		[Required(ErrorMessage ="請輸入開始募資時間")]
		public DateTime StartTime { get; set; }

		[Display(Name = "結束募資時間")]
		[DisplayFormat(DataFormatString = "{0:yyyy-MM-dd}", ApplyFormatInEditMode = true)]
		[Required(ErrorMessage ="請輸入結束募資時間")]
		public DateTime EndTime { get; set; }

		[Display(Name = "出貨天數")]
		[Required(ErrorMessage ="請輸入出貨天數")]
		public int ShippingDays { get; set; }

		[Display(Name = "是否啟用")]
		[Required]
		public bool Enabled { get; set; }

		[Display(Name = "狀態")]		
		public int? StatusId { get; set; }

		[Display(Name = "最近異動日")]
		[DisplayFormat(DataFormatString = "{0:yyyy/MM/dd}", ApplyFormatInEditMode = true)]
		public DateTime UpdateTime { get; set; }

		public DateTime? ApplyTime { get; set; }

		public virtual Category Category { get; set; }

		public virtual Category Category1 { get; set; }

		
	}
}