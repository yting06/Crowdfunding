using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace CrowdfundingWebsites.Models.ViewModels
{
	public class OrderVm
	{
		public int Id { get; set; }

		[Display(Name = "訂單編號")]
		[Required]
		[StringLength(100)]
		public string No { get; set; }

		public int MemberId { get; set; }

		[Display(Name = "訂單時間")]
		public DateTime OrderTime { get; set; }

		[Display(Name = "訂單金額")]
		public int Total { get; set; }

		public int PaymentIStatusId { get; set; }

		[StringLength(10)]
		public string PaymentId { get; set; }
	}
}