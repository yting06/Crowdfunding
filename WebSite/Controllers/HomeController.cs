using CrowdfundingWebsites.Models.DTO;
using CrowdfundingWebsites.Models.EFModels;
using CrowdfundingWebsites.Models.Infra;
using CrowdfundingWebsites.Models.Services;
using CrowdfundingWebsites.Models.ViewModels;
using System;
using System.Collections.Generic;
using System.Dynamic;
using System.Linq;
using System.Linq.Expressions;
using System.Net;
using System.Runtime.Remoting;
using System.Web;
using System.Web.Mvc;
using System.Xml.Linq;

namespace CrowdfundingWebsites.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index(SearchProjectVm vm, int pageStart = 1, bool middle = false)
        {
            ViewBag.Categories = GetCategories("ProjectTypes");

            int pageSize = 9, endPageSize = 3;

            var service = new ProjectCardsService();
            var dataInfo = service.GetActiveProjects(pageSize, pageStart - 1, vm);
            string urlTemp = @"\Home\Index?pageStart={0}&middle={1}";
            ViewBag.ActiveProjects = dataInfo.Item1;
            ViewBag.Pagination = new PaginationInfo(dataInfo.total, pageStart, pageSize, urlTemp, middle);
            ViewBag.EndProjects = service.GetFinishedProjects(null, endPageSize);


            return View(vm);
        }

        private IEnumerable<CategoryVm> GetCategories(string type)
        {
            var cService = new CategoryService();
            var cData = cService.GetCategoryByType(type);
            return cData.OrderBy(c => c.DisplayOrder);
        }


        /// <summary>
        /// 顯示贊助計畫細節
        /// </summary>
        /// <returns></returns>
        public ActionResult ProjectDetial(int projectId)
        {
            var dto = new ProjectCardsService().GetDetial(projectId);
            return View("ProjectView", dto);
        }

        [Authorize]
        public ActionResult Order(int productId)
        {
            var proDto = new ProjectCardsService().GetProduct(productId);
            ViewBag.ProductInfo = proDto;
            var payments =  GetCategories("Payments");
            ViewBag.Payments = new SelectList(payments, "Id", "Name");


            return View("OrderView");
        }


        [Authorize]
        [HttpPost]
        public ActionResult Order(OrderDTO dto)
        {
            if (!ModelState.IsValid)
            {
                return OrderErrorView(dto);
            }
            try
            {
                ProcessOrder(dto);
                return View("OrderSuccess");
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("", ex.Message);
                return OrderErrorView(dto);
            }
        }
        private ActionResult OrderErrorView(OrderDTO dto)
        {
            var proDto = new ProjectCardsService().GetProduct(dto.ProductId);
            ViewBag.ProductInfo = proDto;
            ViewBag.Payments = GetCategories("Payments");

            return View("OrderView", dto);
        }

        private void ProcessOrder(OrderDTO dto)
        {
            string account = HttpContext.User.Identity.Name;
            var member = GetMemberInfo(account);

            CreateRecipients(member.Id, dto, out int recipentsId);
            var order = CreateNewOrder(member.Id, recipentsId, dto.PaymentId);
            CreateOrderItem(order.Id, dto);
            UpdateOrderTotal(order.Id);


        }

        private void UpdateOrderTotal(int id)
        {
            var db = new AppDBContext();
            var item = db.Orders.FirstOrDefault(o => o.Id == id);
            if (item == null) return;

            var list = db.OrderItems
                 .AsNoTracking()
                 .Include("Order")
                 .Include("Product")
                 .Where(o => o.OrderId == id).ToList();  

            item.Total = list.Sum(o => o.Qty * o.Product.Price);

            db.SaveChanges();

        }

        private Order CreateNewOrder(int memberId, int recipentsId, int paymentId)
        {
            string no = GetRandomNumber();
            var order = new Order
            {
                No = no,
                MemberId = memberId,
                OrderTime = DateTime.Now,
                PaymentIStatusId = 12,
                PaymentId = paymentId,
                RecipientId = recipentsId
            };

            var db = new AppDBContext();
            db.Orders.Add(order);
            db.SaveChanges();

            return order;
        }
        private void CreateOrderItem(int orderId, OrderDTO dto)
        {
            var orderItem = new OrderItem
            {
                OrderId = orderId,
                ProductId = dto.ProductId,
                Qty = dto.Count
            };

            var db = new AppDBContext();
            db.OrderItems.Add(orderItem);
            db.SaveChanges();
        }
        private void CreateRecipients(int userId, OrderDTO dto, out int recipentsId)
        {
            var item = new Recipient
            {
                Name = dto.Name,
                PhoneNumber = dto.PhoneNumber,
                PostalCode = dto.PostalCode,
                Address =  dto.Address,
                MemberId = userId
            };

            var db = new AppDBContext();
            db.Recipients.Add(item);
            db.SaveChanges();

            recipentsId = item.Id;
        }


        private string GetRandomNumber()
        {
            byte[] byteArray = Guid.NewGuid().ToByteArray();
            int seed = BitConverter.ToInt32(byteArray, 0);

            string no = DateTime.Now.ToString("yyyyMMdd");
            Random random = new Random(seed);
            int randomNumber = random.Next(1, 1000);
            string formattedNumber = randomNumber.ToString("D3");

            return no + formattedNumber;
        }

        private Member GetMemberInfo(string account)
        {
            var db = new AppDBContext();
            var member = db.Members.FirstOrDefault(m => m.Account == account);
            if (member == null) throw new Exception("用戶不存在");
            return member;
        }

        public ActionResult Login()
        {
            return PartialView();
        }

        public ActionResult Register()
        {
            return PartialView();
        }


        [AllowAnonymous]
        public ActionResult DisplayConfirmTxtList()
        {
            var path = HttpContext.Server.MapPath("~/Files/");
            var fileHelper = new FileHelper(path);
            ViewBag.FolderFiles = fileHelper.GetFolderFiles();

            return PartialView();
        }

        [AllowAnonymous]
        public ActionResult DisplayDetailTxt(string fileName)
        {
            var path = HttpContext.Server.MapPath("~/Files/");
            var fileHelper = new FileHelper(path);

            var data = fileHelper.GetFileData(fileName);
            ViewBag.Content = new EmailContext(data);

            return PartialView();
        }
    }
}