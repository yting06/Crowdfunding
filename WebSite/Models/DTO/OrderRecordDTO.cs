using CrowdfundingWebsites.Models.EFModels;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Xml.Linq;

namespace CrowdfundingWebsites.Models.DTO
{
	public class OrderRecordDTO
	{
		public int Id { get; set; }
		public string No { get; set; }
        public Project Project  { get; set; }
 		public int Total { get; set; }
        public Category Payment { get; set; }
        public Category PaymentStatus { get; set; }

        [DisplayFormat(DataFormatString = "{0:yyyy/MM/dd HH:mm:ss}")]
		public DateTime OrderTime { get; set; }
		public List<OrderItemRecordDTO> Items { get; set; }
		public RecipientDTO Recipient { get; set; }
    }

	public class OrderItemRecordDTO
	{
		public int Id { get; set; }
		public int Qty { get; set; }
		public Product Product { get; set; }

	}

	public class RecipientDTO
	{
        public string Name { get; set; }
        public string PhoneNumber { get; set; }
        public string PostalCode { get; set; }
        public string Address { get; set; }
    }

}