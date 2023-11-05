using CrowdfundingWebsites.Models.EFModels;
using CrowdfundingWebsites.Models.Infra;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CrowdfundingWebsites.Models.ViewModels
{
	public static class MemberExts
	{
		public static EditProfileVm ToEditProfileVm(this Member member)
		{
			return new EditProfileVm
			{
				Id = member.Id,
				Name = member.Name,
				Birthday = member.Birthday,
				Introduce = member.Introduce,
				Image = member.Image,
			};
		}

        public static MemberVm ToMemberVm(this Member member)
        {
			return new MemberVm
			{
				Id = member.Id,
				Name = member.Name,
				Email = member.Email,
				Birthday = member.Birthday,
				Introduce = member.Introduce,
				CreatedTime = member.CreatTime,
                Image = UploadFileHelper.GetProjectFullPath(member.Image),
            };
        }
    }
}