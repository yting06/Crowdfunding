using CrowdfundingWebsites.Models.EFModels;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace CrowdfundingWebsites.Models.ViewModels
{
	public class NewsVm
	{
		public int Id { get; set; }

		[Display(Name = "標題")]
		[Required(ErrorMessage ="請輸入標題")]
		[StringLength(100)]
		public string Name { get; set; }

		[DataType(DataType.MultilineText)]
		[Display(Name = "內容")]
		[Required(ErrorMessage ="請輸入內容")]
		[StringLength(1000)]
		public string Description { get; set; }

		[Display(Name = "建立時間")]
		public DateTime CreatTime { get; set; }

		[Display(Name = "更新時間")]
		public DateTime UpdateTime { get; set; }

		[Display(Name = "專案名稱")]
		public int ProjectId { get; set; }

		[Display(Name = "專案名稱")]
		public string ProjectName { get; set; }

		public Project Project { get; set; }
	}
}