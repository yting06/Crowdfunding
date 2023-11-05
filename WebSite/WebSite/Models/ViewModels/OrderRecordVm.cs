using CrowdfundingWebsites.Models.EFModels;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Xml.Linq;

namespace CrowdfundingWebsites.Models.ViewModels
{
	public class OrderRecordVm
	{
		public int Id { get; set; }
		public string No { get; set; }
		public string ProjectName { get; set; }
		public int Total { get; set; }
		public string Payment { get; set; }
		public string PaymentIStatus { get; set; }

		[DisplayFormat(DataFormatString = "{0:yyyy/MM/dd HH:mm:ss}")]
		public DateTime OrderTime { get; set; }
		public List<OrderItemRecordVm> Items { get; set; }

	}
	public class OrderItemRecordVm
	{
		public int Id { get; set; }
		public string ProductDetail { get; set; }
		public int Price { get; set; }
		public int Qty { get; set; }

		public string RecipientName { get; set; }
		public string RecipientPhoneNumber { get; set;}
		public string RecipientPostalCode { get; set; }
		public string RecipientAddress { get; set; }
	}
}