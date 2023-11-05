using CrowdfundingWebsites.Models.EFModels;
using CrowdfundingWebsites.Models.Services;
using CrowdfundingWebsites.Models.ViewModels;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Xml.Linq;
using WebApplication1.Models.Infra.FileValidators;
using WebApplication1.Models.Infra;
using System.Web.Services.Description;
using static CrowdfundingWebsites.AutoMapperHelper;//因為有直接using Global.asax 中class AutoMapperHelper，45行可以直接寫method，不用寫class
using System.Net;
using System.Data.Entity;
using System.Web.Security;
using System.ComponentModel.Design;

namespace CrowdfundingWebsites.Controllers
{
    [Authorize]
    public class ProjectsController : Controller
    {
        private AppDBContext db = new AppDBContext();

        // GET: Projects
        public ActionResult Index(int categoryId = 0)
        {
            var service = new CategoryService();
            var company = GetLoginCompanyInfo();

            var items = service.GetCategoryByType("ProjectTypes")
                        .Select(c => new SelectListItem() { Value = c.Id.ToString(), Text = c.Name })
                        .Prepend(new SelectListItem() { Value = "0", Text = "全部" });

            ViewBag.CategoryId = items;

            List<ProjectVm> vms = GetProjectsByCategoryId(company.Id, categoryId);
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
        private List<ProjectVm> GetProjectsByCategoryId(int companyId, int categoryId)
        {
            var db = new AppDBContext();
            var projects = db.Projects.AsNoTracking()
                .Where(p => p.CompanyId == companyId && (categoryId == 0 || p.CategoryId == categoryId))
                .Include("Category")
                .Include(p => p.StatusId)
                .Select(p => new ProjectVm
                {
                    Id = p.Id,
                    CategoryId = p.CategoryId,
                    Name = p.Name,
                    Category = p.Category,
                    Description = p.Description,
                    Goal = p.Goal,
                    StartTime = p.StartTime,
                    EndTime = p.EndTime,
                    ShippingDays = p.ShippingDays,
                    Enabled = p.Enabled,
                    StatusId = p.StatusId,
                    UpdateTime = p.UpdateTime,
                    Category1 = p.Category1,
                })
                .ToList();

            return projects;
        }

        public ActionResult Create()
        {
            var service = new CategoryService();

            var items = service.GetCategoryByType("ProjectTypes")
                        .Select(c => new SelectListItem() { Value = c.Id.ToString(), Text = c.Name }).ToList();
            //.Prepend(new SelectListItem() { Value = "0", Text = "" });

            ViewBag.CategoryId = items;

            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(ProjectVm vm, HttpPostedFileBase myfile)
        {
            var db = new AppDBContext();
            if (!ModelState.IsValid)
            {
                ViewBag.CategoryId = new SelectList(db.Categories, "Id", "Name", vm.CategoryId);
                return View(vm);
            }
            else if (myfile == null)
            {
                ModelState.AddModelError("myfile", "專案圖片不得為空");
                ViewBag.CategoryId = new SelectList(db.Categories, "Id", "Name", vm.CategoryId);
                return View(vm);
            }


            #region 將檔案上傳到 /File資料夾下
            try
            {
                string fileName = "";
                ProcessImage(myfile, out fileName);
                vm.Image = fileName;
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("myfile", ex.Message);
                return View(vm);
            }

            #endregion



            // 檢查 StartTime 是否小於 EndTime
            if (vm.StartTime >= vm.EndTime)
            {
                ModelState.AddModelError("EndTime", "結束時間必須大於開始時間。");
                ViewBag.CategoryId = new SelectList(db.Categories, "Id", "Name", vm.CategoryId);
                return View(vm);
            }
            var company = GetLoginCompanyInfo();

            // 創建 Project 實例，並將 ProjectVm 的屬性值複製到 Project
            var project = new Project
            {
                //Id = vm.Id,
                CategoryId = vm.CategoryId,
                //todo要抓companyId
                //CompanyId =vm.CompanyId,
                CompanyId = company.Id,
                Name = vm.Name,
                Image = vm.Image,
                Category = vm.Category,
                Description = vm.Description,
                Goal = vm.Goal,
                StartTime = vm.StartTime,
                EndTime = vm.EndTime,
                ShippingDays = vm.ShippingDays,
                Enabled = vm.Enabled,
                StatusId = vm.StatusId,
                UpdateTime = DateTime.Now,
                Category1 = vm.Category1,
            };

            db.Projects.Add(project);
            db.SaveChanges();
            return RedirectToAction("Index");
        }



        private void ProcessImage(HttpPostedFileBase file, out string fileName)
        {
            string path = Server.MapPath("~/Files");
            IFileValidator[] validators =
                new IFileValidator[]
                {
                    new FileReqired(),//必填
                    new ImageValidator(),//必須是圖檔
                    new FileSizeValidator(10240)//10MB

				};

            fileName = UploadFileHelper.Save(file, path, validators);

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


        public ActionResult Edit(int? id)
        {

            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Project project = db.Projects.Find(id);
            if (project == null)
            {
                return HttpNotFound();
            }

            var vm = new ProjectVm
            {
                Id = project.Id,
                CategoryId = project.CategoryId,
                CategoryName = project.Category.Name,
                //todo要抓companyId
                //CompanyId =vm.CompanyId,
                CompanyId = 1,
                Name = project.Name,
                Image = project.Image,
                Category = project.Category,
                Description = project.Description,
                Goal = project.Goal,
                StartTime = project.StartTime,
                EndTime = project.EndTime,
                ShippingDays = project.ShippingDays,
                Enabled = project.Enabled,
                StatusId = project.StatusId,
                UpdateTime = DateTime.Now,
                Category1 = project.Category1,
            };

            var service = new CategoryService();
            ViewBag.categories = service.GetCategoryByType("ProjectTypes");

            return View(vm);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(ProjectVm vm)
        {
            if (ModelState.IsValid)
            {
                var db = new AppDBContext();

                // 檢查 StartTime 是否小於 EndTime
                if (vm.StartTime >= vm.EndTime)
                {
                    ModelState.AddModelError("EndTime", "結束時間必須大於開始時間。");
                    ViewBag.CategoryId = new SelectList(db.Categories, "Id", "Name", vm.CategoryId);
                    return View(vm);
                }

                Project project = new Project
                {
                    Id = vm.Id,
                    CategoryId = vm.CategoryId,
                    //todo要抓companyId
                    //CompanyId =vm.CompanyId,
                    CompanyId = 1,
                    Name = vm.Name,
                    Image = vm.Image,
                    Category = vm.Category,
                    Description = vm.Description,
                    Goal = vm.Goal,
                    StartTime = vm.StartTime,
                    EndTime = vm.EndTime,
                    ShippingDays = vm.ShippingDays,
                    Enabled = vm.Enabled,
                    StatusId = vm.StatusId,
                    UpdateTime = DateTime.Now,
                    Category1 = vm.Category1,
                };

                db.Entry(project).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.CategoryId = new SelectList(db.Categories, "Id", "Name", vm.CategoryId);

            return View(vm);
        }

        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Project project = db.Projects.Find(id);
            if (project == null)
            {
                return HttpNotFound();
            }
            return View(project);
        }

        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            var db = new AppDBContext();

            Project project = db.Projects.Include("Products").FirstOrDefault(p => p.Id == id);

            db.Products.RemoveRange(project.Products);
            db.Projects.Remove(project);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            var db = new AppDBContext();
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        public ActionResult Submit(int projectId)
        {
            var db = new AppDBContext();

            Project project = db.Projects.Find(projectId);
            project.StatusId = 21;
            project.ApplyTime = DateTime.Now;
            db.SaveChanges();
            return RedirectToAction("Index");
        }




    }
}
