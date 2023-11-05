using CrowdfundingWebsites.Models.EFModels;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace CrowdfundingWebsites.Models.ViewModels
{
	public class ProjectVm
	{
		public int Id { get; set; }

		public int CategoryId { get; set; }

		public int CompanyId { get; set; }

		[Display(Name = "專案名稱")]
		[Required]
		[StringLength(50)]
		public string Name { get; set; }

		[Display(Name = "專案圖片")]
		[Required]
		[StringLength(1000)]
		public string Image { get; set; }

		[Display(Name = "專案說明")]
		[Required]
		[StringLength(1000)]
		public string Description { get; set; }

		[Display(Name = "專案目標金額")]
		public int Goal { get; set; }

		[Display(Name = "募資開始時間")]
		public DateTime StartTime { get; set; }

		[Display(Name = "募資結束時間")]
		public DateTime EndTime { get; set; }

		[Display(Name = "出貨時間")]
		public int ShippingDays { get; set; }

		public bool Enabled { get; set; }

		public int? StatusId { get; set; }

		[Display(Name = "專案更新時間")]
		public DateTime? UpdateTime { get; set; }

		[Display(Name = "專案審核通過時間")]
		public DateTime? ApplyTime { get; set; }

		public virtual Category Category { get; set; }

		public virtual Category Category1 { get; set; }

		public virtual Company Company { get; set; }


	}
}