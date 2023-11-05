using CrowdfundingWebsites.Models.EFModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using CrowdfundingWebsites.Models.Infra;

namespace CrowdfundingWebsites.Models.ViewModels
{
	public static class CompanyRegisterExts
	{

		public static Company ToEFModel(this CompanyRegisterVm vm)
		{
			var salt = HashUtility.GetSalt();
			var hashPassword = HashUtility.ToSHA256(vm.Password, salt);
			var confirmCode = Guid.NewGuid().ToString("N");

			return new Company
			{
				Id = vm.Id,
				Account = vm.Account,
				Password = hashPassword,
				Email = vm.Email,
				Name = vm.Name,
				Phone = vm.Phone,
				UnifiedBusinessNo=vm.UnifiedBusinessNo,
				ResponsiblePerson=vm.ResponsiblePerson,
				Introduce = vm.Introduce ?? "",
				Image = vm.Image ?? "",
				IsConfirmed = false,
				ConfirmCode = confirmCode,
				CreatedTime = DateTime.Now,
				UpdateTime = DateTime.Now,
			};

		}
	}
}