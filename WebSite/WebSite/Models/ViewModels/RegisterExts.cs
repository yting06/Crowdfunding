using CrowdfundingWebsites.Models.EFModels;
using CrowdfundingWebsites.Models.Infra;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CrowdfundingWebsites.Models.ViewModels
{
	public static class RegisterExts
	{
		public static Member ToEFModel(this RegisterVm vm)
		{
			var salt = HashUtility.GetSalt();
			var hashPassword = HashUtility.ToSHA256(vm.Password, salt);
			var comfirmCode = Guid.NewGuid().ToString("N");

			return new Member
			{
				Id = vm.Id,
				Account = vm.Account,
				Password = hashPassword,
				Name = vm.Name,
				Email = vm.Email,
				IsConfirmed = false,
				ConfirmCode = comfirmCode,
			};
		}
	}
}