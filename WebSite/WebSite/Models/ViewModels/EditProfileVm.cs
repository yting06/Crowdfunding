using CrowdfundingWebsites.Models.Infra;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;
using System.Xml.Linq;

namespace CrowdfundingWebsites.Models.ViewModels
{
	public class EditProfileVm
	{
		public int Id { get; set; }

		[Display(Name = "姓名")]
		[Required(ErrorMessage = DAHelper.Required)]
		[StringLength(50)]
		public string Name { get; set; }

		[Display(Name = "生日")]
		[Column(TypeName = "date")]
		public DateTime? Birthday { get; set; }

		[Display(Name = "自我介紹")]
		[StringLength(1000)]
		public string Introduce { get; set; }

		[Display(Name = "照片")]
		[StringLength(450)]
		public string Image { get; set; }

	}
}