using CrowdfundingWebsites.Models.EFModels;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace CrowdfundingWebsites.Models.ViewModels
{
    public class ProductVm
    {
        public int Id { get; set; }

		[Display(Name = "專案名稱")]
		public int ProjectId { get; set; }

		[Display(Name = "專案名稱")]
		public string ProjectName { get; set; }

		[Display(Name = "商品名稱")]
        [Required(ErrorMessage ="請輸入商品名稱")]
        [StringLength(1000)]
        public string Detail { get; set; }

        [Display(Name = "數量")]
        [Required(ErrorMessage = "請輸入數量")]
        //[StringLength(1000)]
        public int Qty { get; set; }

        [Display(Name = "價格")]
        [Required(ErrorMessage = "請輸入價格")]
        //[StringLength(1000)]
        public int Price { get; set; }

        [Display(Name = "圖片")]
		[Required(ErrorMessage = "請上傳圖片")]
		[StringLength(550)]
        public string Image { get; set; }

        [Display(Name = "最近異動日")]
        [DisplayFormat(DataFormatString = "{0:yyyy/MM/dd HH:mm:ss}", ApplyFormatInEditMode = true)]
        public DateTime UpdateTime { get; set; }

        public Project Project { get; set; }
    }
}