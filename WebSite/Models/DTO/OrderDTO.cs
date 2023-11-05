using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace CrowdfundingWebsites.Models.DTO
{
    public class OrderDTO
    {


        [Required]
        [Display(Name = "收件人")]
        [StringLength(50)]
        public string Name { get; set; }

        [Required]
        [Display(Name = "手機")]
        [StringLength(50)]
        public string PhoneNumber { get; set; }

        [Required]
        [Display(Name = "郵遞區號")]
        public string PostalCode { get; set; }

        [Required]
        [Display(Name = "地址")]
        public string Address { get; set; }

        [Required]
        [Display(Name = "購買數量")]
        public int Count { get; set; }


        [Required]
        [Display(Name = "商品")]
        public int ProductId { get; set; }


        [Required]
        [Display(Name = "付款方式")]
        public int PaymentId { get; set; }
    }
}