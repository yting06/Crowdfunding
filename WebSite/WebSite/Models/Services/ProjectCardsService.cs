using CrowdfundingWebsites.Models.DTO;
using CrowdfundingWebsites.Models.EFModels;
using CrowdfundingWebsites.Models.Infra;
using CrowdfundingWebsites.Models.ViewModels;
using Microsoft.Ajax.Utilities;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;
using WebGrease.Css.Extensions;

namespace CrowdfundingWebsites.Models.Services
{
    public class ProjectCardsService
    {
        private readonly AppDBContext _db = new AppDBContext();


        //todo X贊助人數；
        public IEnumerable<ProjectCardVm> GetFinishedProjects(int? category = null, int? count = null)
        {
            var query = _db.Projects
                        .AsNoTracking()
                        .Where(p => p.EndTime < DateTime.Now)
                        .OrderByDescending(p => p.EndTime);

            int total = (count ?? int.MinValue);
            if (total > 0) query = (IOrderedQueryable<Project>)query.Take(total);

            var items = query.AsEnumerable().ToList();
            List<ProjectCardVm> result = ConvertToProjectCards(items);

            return result;
        }

        //todo  X計算當前贊助人數、完成度
        public (IEnumerable<ProjectCardVm>, int total) GetActiveProjects(int pageSize, int pageStart = 0, SearchProjectVm vm = null)
        {
            bool isAllType = vm.ProjectType == null, isEmptySearch = string.IsNullOrEmpty(vm.SearchValue);
            var query = _db.Projects
                        .AsNoTracking()
                        .Where(p =>
                            p.StatusId == 14 &&
                            (isAllType || p.CategoryId == vm.ProjectType) &&
                            (isEmptySearch || p.Name.IndexOf(vm.SearchValue) > -1))
                        .OrderByDescending(p => p.EndTime)
                        .AsEnumerable();

            int total = query.Count();
            var items = query.Skip(pageStart * pageSize).Take(pageSize).ToList();

            List<ProjectCardVm> result = ConvertToProjectCards(items);
            return (result, total);
        }

        private List<ProjectCardVm> ConvertToProjectCards(List<Project> projects)
        {
            List<ProjectCardVm> result = new List<ProjectCardVm>();
            foreach (var item in projects)
            {
                var sum = GetSupports(item.Id);

                var p = new ProjectCardVm
                {
                    Id = item.Id,
                    Title = item.Name,
                    Image = UploadFileHelper.GetProjectFullPath(item.Image),
                    SupportCount = sum.Count,
                    FinishDates = item.EndTime,
                    SupportMoney = sum.Money,
                    SupportPercent = GetSupportPercent((float)sum.Money, (float)item.Goal),
                    Days = (int)(item.EndTime - DateTime.Now).TotalDays,
                };

                result.Add(p);
            }

            return result;
        }

        private float GetSupportPercent(float money, float goal)
        {
            string resultStr = string.Format("{0:P1}", (money / goal));
            float.TryParse(resultStr.Replace("%", ""), out float result);
            return result;
        }

        private (int Count, int Money) GetSupports(int projectId)
        {
            var items = _db.OrderItems
                 .AsNoTracking()
                 .Include("Order")
                 .Include("Product")
                 .Where(o => o.Product.ProjectId == projectId && o.Order.PaymentIStatusId == 12).ToList();  //找出 "付款成功的"

            //var sumDict = items.GroupBy(o=> o.ProductId)
            //                 .ToDictionary(group=> group.Key, group => group.Sum(v=> v.Qty));

            int countMoney = items.Sum(o => o.Qty * o.Product.Price);

            return (items.Count, countMoney);
        }



        public ProjectDTO GetDetial(int projectId)
        {
            var project = _db.Projects
                        .AsNoTracking()
                        .Include("Category")
                        .Include("Category1")
                        .Include("Company")
                        .Include("News")
                        .Include("Products")
                        .FirstOrDefault(p => p.Id == projectId && (p.StatusId > 13 & p.StatusId < 18)); //狀態條件先寫死

            if (project == null) throw new Exception("找不到該活動");


            var support = GetSupports(projectId);

            var dto = AutoMapperHelper.MapperObj.Map<ProjectDTO>(project);
            dto.Image = UploadFileHelper.GetProjectFullPath(dto.Image);
            dto.SupportCount = support.Count;
            dto.SupportMoney = support.Money;
            dto.SupportPercent = GetSupportPercent((float)support.Money, (float)dto.Goal);

            var pDict = GetOrderProductCount(projectId);

            dto.Products = dto.Products.Select(p =>
            {
                p.RemainingCount = p.Qty - (pDict.TryGetValue(p.Id, out int v) ? v : 0);
                p.Image = UploadFileHelper.GetProjectFullPath(p.Image);
                return p;
            }).ToList();

            return dto;
        }

        public Dictionary<int, int> GetOrderProductCount(int projectId)
        {
            var items = _db.OrderItems
                           .AsNoTracking()
                           .Include("Order")
                           .Include("Product")
                           .Where(o => o.Product.ProjectId == projectId);


            return items.GroupBy(o => o.ProductId)
                        .ToDictionary(group => group.Key, group => group.Sum(o=> o.Qty));
        }

        public ProductDTO GetProduct(int projectId)
        {
            var product = _db.Products
                             .AsNoTracking()
                             .Include("Project")
                             .FirstOrDefault(p => p.Id == projectId);

            if (product == null) throw new Exception("找不到該商品");


            var dto = AutoMapperHelper.MapperObj.Map<ProductDTO>(product);
            dto.Image = UploadFileHelper.GetProjectFullPath(dto.Image);

            return dto;
        }












    }
}