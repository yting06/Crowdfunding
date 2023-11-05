using AutoMapper;
using CrowdfundingWebsites.Models.DTO;
using CrowdfundingWebsites.Models.EFModels;
using CrowdfundingWebsites.Models.ViewModels;
using System;

namespace CrowdfundingWebsites.App_Start
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
            CreateMap<Page, PageDTO>()
                .ForMember(dest => dest.Visible, opt => opt.MapFrom(src => src.DefaultVisible));
            CreateMap<Function, FunctionDTO>()
                .ForMember(dest => dest.Visible, opt => opt.MapFrom(src => true));

            CreateMap<RoleVm, Role>().ReverseMap();
            CreateMap<AboutU, AboutUsVm>().ReverseMap();
            CreateMap<Project, ProjectDTO>().ReverseMap();
            CreateMap<ReviewProjectVm, ProjectDTO>().ReverseMap();

            CreateMap<Category, CategoryVm>().ReverseMap();
            CreateMap<FAQ, FAQDTO>().ReverseMap();
            CreateMap<FAQVm, FAQ>().ReverseMap();

            CreateMap<Manager, ManagerVm>();
            CreateMap<ManagerVm, Manager>()
                .ForMember(dest => dest.CreatedTime, opt => opt.MapFrom(src => src.CreatedTime ?? DateTime.Now))
                .ForMember(dest => dest.UpdateTime, opt => opt.MapFrom(src => src.UpdateTime ?? DateTime.Now));

            CreateMap<FAQVm, FAQDTO>().ReverseMap()
                .ForMember(dest => dest.CategoryName, opt => opt.MapFrom(src => src.Category.Name))
                .ForMember(dest => dest.CategoryId, opt => opt.MapFrom(src => src.Category.Id));
        }


    }
}