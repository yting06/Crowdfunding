using AutoMapper;
using CrowdfundingWebsites.Models.EFModels;
using CrowdfundingWebsites.Models.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CrowdfundingWebsites.App_Start
{
	public class MappingProfile : Profile
	{
		public MappingProfile()
		{
			// 可以二個方向都寫, 但也可以直接用 ReverseMap() 來反轉,表示二個方向都要做

			//CreateMap<News, NewsIndexVm>().ReverseMap();//表示兩個方向都要做mapping
			//CreateMap<News, NewsVm>();//表示只有單方向可以做mapping

			CreateMap<ProjectVm, Project>()
				.ForMember(dest => dest.UpdateTime,
				option => option.MapFrom(src => DateTime.Now));
				

		}
	}
}