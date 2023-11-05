using CrowdfundingWebsites.Models.EFModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CrowdfundingWebsites.Models.ViewModels
{
	public static class CompanyExts
	{
		public static EditCompanyProfileVm ToEditCompanyProfileVm(this Company company)
		{
			return new EditCompanyProfileVm
			{
				Id = company.Id,
				Email = company.Email,
				Name = company.Name,
				Phone = company.Phone,
				ResponsiblePerson= company.ResponsiblePerson,
				Introduce= company.Introduce,
				CreatedTime =DateTime.Now,
				UpdateTime = DateTime.Now,
			};
		}
	}
}