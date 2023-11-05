using CrowdfundingWebsites.Models.EFModels;
using CrowdfundingWebsites.Models.Services;
using CrowdfundingWebsites.Models.ViewModels;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using System.Xml.Linq;
using WebApplication1.Models.Infra.FileValidators;
using WebApplication1.Models.Infra;
using System.Data.Entity;
using System.Runtime.InteropServices;
using static System.Net.WebRequestMethods;
using System.Web.Security;
using System.ComponentModel.Design;

namespace CrowdfundingWebsites.Controllers
{
    [Authorize]
    public class ProductsController : Controller
    {
        private AppDBContext db = new AppDBContext();
        // GET: Products
        public ActionResult Index(int projectId = 0, string name = "")
        {
            var company = GetLoginCompanyInfo();

            var items = GetEditingProjects(company.Id, true);
            var selectList = new SelectList(items, "Id", "Name").Prepend(new SelectListItem() { Value = "0", Text = "全部" });
            ViewBag.ProjectId = selectList;

            List<ProductVm> vms = GetProductsByProjectId(company.Id, projectId);
            vms = vms.OrderByDescending(p => p.UpdateTime).ToList();

            return View(vms);
        }
        private Company GetLoginCompanyInfo()
        {
            var user = HttpContext.User;
            var ticket = (user.Identity as FormsIdentity).Ticket;
            var company = new AppDBContext().Companies.FirstOrDefault(c => string.Compare(c.Account, ticket.Name) == 0);

            return company;

        }
        private List<ProductVm> GetProductsByProjectId(int companyId, int projectId)
        {
            var db = new AppDBContext();
            var products = db.Products.AsNoTracking()
                .Include("Project")
                .Where(p => p.Project.CompanyId == companyId && ( projectId == 0 || p.ProjectId == projectId))
                .Include("Category")
                .Select(p => new ProductVm
                {
                    Id = p.Id,
                    ProjectName = p.Project.Name,
                    Detail = p.Detail,
                    Qty = p.Qty,
                    Price = p.Price,
                    UpdateTime = p.UpdateTime,
                    Project = p.Project,
                })
                .ToList();

            return products;
        }

        private List<Project> GetEditingProjects(int companyId, bool isAll = false)
        {
            return db.Projects
                .Where(p => p.CompanyId == companyId  && ( isAll || p.StatusId == null || p.StatusId == 23 )).ToList();
        }

        public ActionResult Create(int? projectId)
        {
            var company = GetLoginCompanyInfo();
            var items = GetEditingProjects(company.Id);
            ViewBag.SelectProjectId = projectId;
            if (projectId != null)
            {
                int.TryParse(projectId.ToString(), out int result);
                ViewBag.DisplayProjectName = items.FirstOrDefault(i => i.Id == projectId).Name;
            }
            ViewBag.ProjectId = new SelectList(items, "Id", "Name");
            return View();
        }

        // POST: Products/Create
        // 若要免於大量指派 (overposting) 攻擊，請啟用您要繫結的特定屬性，
        // 如需詳細資料，請參閱 https://go.microsoft.com/fwlink/?LinkId=317598。
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(ProductVm vm, HttpPostedFileBase myfile)
        {
            #region 將檔案上傳到 /File資料夾下
            string fileName;
            string path = Server.MapPath("~/Files");
            IFileValidator[] validators =
                new IFileValidator[]
                {
                    new FileReqired(),//必填
                    new ImageValidator(),//必須是圖檔
                    new FileSizeValidator(10240)//10MB

				};
            try
            {
                fileName = UploadFileHelper
                    .Save(myfile, path, validators);

                //copy 一份到前台網站的資料夾下
                string sourceFullPath = Path.Combine(path, fileName);

                //string dest = @"c:\MyFiles\";
                //Web.config
                string dest = System.Configuration
                    .ConfigurationManager
                    .AppSettings["frontSiteRootPath"];

                dest = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, dest);
                string destFullPath = Path.Combine(dest, fileName);
                destFullPath = Path.GetFullPath(destFullPath);

                System.IO.File.Copy(sourceFullPath, destFullPath, true);

            }
            catch (Exception ex)
            {
                ModelState.AddModelError("myfile", ex.Message);
				ViewBag.ProjectId = new SelectList(db.Projects, "Id", "Name", vm.ProjectId);
				return View(vm);
            }

            #endregion

            //將檔名存入vm
            vm.Image = fileName;

            if (!ModelState.IsValid)
            {
                var company = GetLoginCompanyInfo();

                var product = new Product
                {

                    ProjectId = vm.ProjectId,
                    Detail = vm.Detail,
                    Qty = vm.Qty,
                    Price = vm.Price,
                    Image = vm.Image,
                    UpdateTime = DateTime.Now,

                };

                db.Products.Add(product);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.ProjectId = new SelectList(db.Projects, "Id", "Name", vm.ProjectId);
            return View(vm);
        }

        public ActionResult Edit(int? id)
        {

            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Product product = db.Products.Find(id);
            if (product == null)
            {
                return HttpNotFound();
            }

            var vm = new ProductVm
            {
                Id = product.Id,
                ProjectId = product.ProjectId,
                Detail = product.Detail,
                ProjectName = product.Project.Name,
                Qty = product.Qty,
                Price = product.Price,
                Image = product.Image,
                UpdateTime = DateTime.Now,
            };

            var items = db.Projects
               .Select(p => new SelectListItem() { Value = p.Id.ToString(), Text = p.Name, Selected = (p.Id == vm.ProjectId) })
               .Prepend(new SelectListItem() { Value = "0", Text = "" });

            ViewBag.ProjectId = items;
            //ViewBag.ProjectId = new SelectList(db.Projects, "Id", "Name");

            return View(vm);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(ProductVm vm)
        {
            if (ModelState.IsValid)
            {
                Product product = new Product
                {
                    Id = vm.Id,
                    ProjectId = vm.ProjectId,
                    Detail = vm.Detail,
                    Qty = vm.Qty,
                    Price = vm.Price,
                    Image = vm.Image,
                    UpdateTime = DateTime.Now,
                };

                db.Entry(product).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.ProjectId = new SelectList(db.Projects, "Id", "Name", vm.ProjectId);
            return View(vm);
        }


        // GET: Products/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Product product = db.Products.Find(id);
            if (product == null)
            {
                return HttpNotFound();
            }

            return View(product);
        }

        // POST: Products/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {

            Product product = db.Products.Find(id);
            db.Products.Remove(product);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}