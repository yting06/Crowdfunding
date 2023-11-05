using AutoMapper;
using CrowdfundingWebsites.Models.DTO;
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
            CreateMap<CategoryVm, Category>().ReverseMap();
			CreateMap<RegisterVm, Member>().ReverseMap();

            CreateMap<ProductDTO, Product>().ReverseMap();

            CreateMap<OrderRecordDTO, Order>().ReverseMap();

            CreateMap<Project, ProjectDTO> ()
                .ForMember(dest => dest.Status, opt => opt.MapFrom(src => src.Category1 ))
                .ReverseMap();
        }
    }
}