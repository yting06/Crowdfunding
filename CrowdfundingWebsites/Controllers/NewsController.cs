using CrowdfundingWebsites.Models.EFModels;
using CrowdfundingWebsites.Models.ViewModels;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;

namespace CrowdfundingWebsites.Controllers
{
	[Authorize]
	public class NewsController : Controller
    {
		private AppDBContext db = new AppDBContext();
		// GET: News
		public ActionResult Index(int? projectId, string name = "")
        {
			var items = db.Projects
			   .Select(p => new SelectListItem() { Value = p.Id.ToString(), Text = p.Name });

			string sProjectId = projectId?.ToString() ?? string.Empty;

            ViewBag.ProjectId = items;
			ViewBag.SelectProjectId = sProjectId;
			ViewBag.DisplayProjectName = projectId == null ? "" : items.FirstOrDefault(i => i.Value == sProjectId).Text;


            List<NewsVm> vms = GetNews();

			if (projectId == null)
			{
				vms = GetNews(); // 如果 projectId 為 0，獲取所有產品
			}
			else
			{
				int.TryParse(projectId.ToString(), out int result);
				vms = GetNewsByProjectId(result); // 否則根據 projectId 進行篩選
			}

			return View(vms);
			
        }
		private List<NewsVm> GetNewsByProjectId(int projectId)
		{
			var db = new AppDBContext();
			var news = db.News.AsNoTracking()
				.Include("Category")
				.Where(n => n.ProjectId == projectId)
				.Select(n => new NewsVm
				{
					Id = n.Id,
					ProjectName =n.Project.Name,
					Name = n.Name,
					Description = n.Description,
					CreatTime = n.CreatTime,
					UpdateTime =n.UpdateTime,
				})
				.ToList();

			return news;
		}
		private List<NewsVm> GetNews()
		{
			var db = new AppDBContext();
			var news = db.News.AsNoTracking()//AsNoTracking()純粹找出來，不異動(較有效率)
				.Include("Category")//.Include 產生出來的sql語法可以直接inner join(較有效率)
				.Select(n => new NewsVm
				{
					Id = n.Id,
					ProjectName =n.Project.Name,
					Name = n.Name,
					Description = n.Description,
					CreatTime = n.CreatTime,
					UpdateTime = n.UpdateTime,
				})
				.ToList();

			return news;
		}
		public ActionResult Create(int projectId)
		{
			var db = new AppDBContext();
			var project = db.Projects.FirstOrDefault(p => p.Id == projectId);
			ViewBag.Project = project;
			return View();
		}

		[HttpPost]
		[ValidateAntiForgeryToken]
		public ActionResult Create(NewsVm vm)
		{
			var db = new AppDBContext();

			if (ModelState.IsValid)
			{
				News news = new News
				{
					//Id = vm.Id,
					ProjectId = vm.ProjectId,
					Name = vm.Name,
					Description = vm.Description,
					CreatTime = DateTime.Now,
					UpdateTime = DateTime.Now,

				};
				

				db.News.Add(news);
				db.SaveChanges();
				return RedirectToAction("Index", "Projects");
			}

			ViewBag.ProjectId = new SelectList(db.Projects, "Id", "Name", vm.ProjectId);
			return View(vm);

		}


		//public ActionResult Edit(int? id)
		//{

		//	if (id == null)
		//	{
		//		return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
		//	}
		//	News news = db.News.Find(id);
		//	if (news == null)
		//	{
		//		return HttpNotFound();
		//	}

		//	var vm = new NewsVm
		//	{
		//		//Id = vm.Id,
		//		ProjectId = news.ProjectId,
		//		ProjectName = news.Project.Name,
		//		Name = news.Name,
		//		Decription = news.Decription,
		//		CreatTime = DateTime.Now,
		//		UpdateTime = DateTime.Now,

		//	};
		//	var items = db.Projects
		//	   .Select(p => new SelectListItem() { Value = p.Id.ToString(), Text = p.Name, Selected = (p.Id == vm.ProjectId) })
		//	   .Prepend(new SelectListItem() { Value = "0", Text = "" });

		//	ViewBag.ProjectId = items;

		//	return View(vm);
		//}

		//[HttpPost]
		//[ValidateAntiForgeryToken]
		//public ActionResult Edit(NewsVm vm)
		//{
		//	var db = new AppDBContext();

		//	ViewBag.ProjectId = new SelectList(db.Projects, "Id", "Name", vm.ProjectId);

			
		//	if (ModelState.IsValid)
		//	{
		//		ViewBag.ProjectId = new SelectList(db.Projects, "Id", "Name", vm.ProjectId);

		//		News news = new News
		//		{
		//			Id = vm.Id,
		//			ProjectId = vm.ProjectId,
		//			Name = vm.Name,
		//			Decription = vm.Decription,
		//			CreatTime = DateTime.Now,
		//			UpdateTime = DateTime.Now,
		//		};
		//		db.Entry(news).State = EntityState.Modified;
		//		db.SaveChanges();
		//		return RedirectToAction("Index");
		//	}
		//	ViewBag.ProjectId = new SelectList(db.Projects, "Id", "Name", vm.ProjectId);

		//	return View(vm);

		//}
	}
}