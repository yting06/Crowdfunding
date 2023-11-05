using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.UI.WebControls;

namespace CrowdfundingWebsites.Models.Infra
{
    public class PaginationInfo
    {
        public int TotalRecords { get; private set; }
        public int PageItemCount { get; private set; }
        public int PageNumber { get; private set; }

        public int Pages => (int)Math.Ceiling((double)TotalRecords / PageItemCount);
        public int PageItemDisplayCount { get; private set; } = 5;

        public int PageItemPrevNumber => PageNumber > 1 ? PageNumber - 1 : -1;
        public int PageItemNextNumber => PageNumber == Pages ? -1 : PageNumber + 1;

        public bool IsMiddle { get; private set; }

        public PaginationInfo(int totalRecords, int pageNumber, int pageItemCount, string urlTemplate, bool isMiddle = false)
        {
            TotalRecords = totalRecords;
            PageItemCount = pageItemCount;
            PageNumber = pageNumber;
            this.urlTemplate = urlTemplate;
            this.IsMiddle = isMiddle;
        }

        private string urlTemplate;

        public void SetTotal(int total)
        {
            TotalRecords = total;
        }

        public string GetUrl(int pageNumber, bool setMiddle = false)
        {
            return string.Format(urlTemplate, IsMiddle ? pageNumber + 1 : pageNumber, setMiddle);
        }


    }


    public static class PaginationInfoExt
    {
        public static MvcHtmlString RenderPager(this PaginationInfo pagedInfo, Func<int, bool, string> urlGenerator)
        {
            string result = @"
            <nav class=""mt-2"" aria-label=""Page navigation"">
                <ul class=""pagination justify-content-center"">";

            string prevUrl = urlGenerator(pagedInfo.PageItemPrevNumber, false);
            result += string.Format(@"<li class=""page-item {0} ""><a class=""page-link"" href=""{1}"" aria-label=""Previous""><span aria-hidden=""true"">&laquo;</span></a></li>",
                                    (pagedInfo.PageNumber == 1 ? "disabled" : ""), prevUrl);

            int PageItemDisplayCount = pagedInfo.PageItemDisplayCount;
            bool morePages = pagedInfo.Pages > PageItemDisplayCount;
            int pageHalfCount = (PageItemDisplayCount / 2) + ((PageItemDisplayCount % 2 == 1) ? 1 : 0);
            int pageLastCount = pagedInfo.Pages - pageHalfCount;

            int loopCount = morePages ? PageItemDisplayCount : pagedInfo.Pages;


            for (int i = 1; i <= loopCount; i++)
            {
                bool isMiddle = i == pageHalfCount;
                int currentPageNumber = morePages && i > pageHalfCount ? pageLastCount++ : i;

                string url = urlGenerator(currentPageNumber, isMiddle);

                string className = "page-item " + (currentPageNumber == pagedInfo.PageNumber ? "active" : "");
                string displayContent = isMiddle ? "..." : currentPageNumber.ToString();

                result += $@"<li class=""{className}""><a class=""page-link"" href=""{url}"">{displayContent}</a></li>";
            }

            string nextUrl = urlGenerator(pagedInfo.PageItemNextNumber, false);
            result += string.Format(@"<li class=""page-item {0} ""><a class=""page-link"" href=""{1}"" aria-label=""Previous""><span aria-hidden=""true"">&raquo;</span></a></li>",
                                (pagedInfo.PageNumber == pagedInfo.Pages ? "disabled" : ""), nextUrl);



            result += @"</ul></nav>";

            return new MvcHtmlString(result);
        }
    }
  
}