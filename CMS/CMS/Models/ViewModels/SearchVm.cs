using CrowdfundingWebsites.Models.Interface;


namespace CrowdfundingWebsites.Models.ViewModels
{
    
    public class SearchCategoryVm : ISearchVm
    {
        public string Type { get; set; }
        public int PageStart { get; set; }
        public int PageSize { get; set; }
        public string SearchValue { get; set; }
    }

    public class SearchManagerVm : ISearchVm
    {

        public int PageStart { get; set; }
        public int PageSize { get; set; }
        public string SearchValue { get; set; }
    }

    public class SearchFAQVm : ISearchVm
    {
        public int? Type { get; set; }
        public int PageStart { get; set; }
        public int PageSize { get; set; }
        public string SearchValue { get; set; }

    }


    public class SearchProjectVm : ISearchVm
    {
        public int? Type { get; set; }
        public int PageStart { get; set; }
        public int PageSize { get; set; }
        public string SearchValue { get; set; }
        public int OrderByTime { get; set; }

    }





}