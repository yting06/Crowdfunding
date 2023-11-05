
using System.Linq;
using System.Web.Http;
using CrowdfundingWebsites.Models.Services;
using CrowdfundingWebsites.Models.ViewModels;
using Newtonsoft.Json.Linq;
using CrowdfundingWebsites.Models.Interface;
using System.Web.Http.Results;
using System;

namespace CrowdfundingWebsites.Controllers.WebApi
{
    public class DataApiController : ApiController
    {

        [HttpPost]
        public IHttpActionResult GetTypes()
        {
            var categoryList = new CategoryService().GetTypeList();
            return Ok(categoryList);
        }

        private IHttpActionResult GetAll<T>(IService<T> service, ISearchVm vm)
        {
            var result = service.GetAll(vm);
            object o = new
            {
                data = result.Item1,
                recordsTotal = result.Item2,
                recordsFiltered = result.Item2
            };
            return Ok(o);
        }
        [HttpPost]
        public IHttpActionResult GetCategories(SearchCategoryVm vm) => GetAll(new CategoryService(), vm);
        [HttpPost]
        public IHttpActionResult GetManagers(SearchManagerVm vm) => GetAll(new ManagerService(), vm);
        [HttpPost]
        public IHttpActionResult GetFAQs(SearchFAQVm vm) => GetAll(new WebContentService(), vm);
        [HttpPost]
        public IHttpActionResult GetProjects(SearchProjectVm vm) => GetAll(new ProjectService(), vm);

        /// <summary>
        /// 顯示錯誤訊息
        /// </summary>
        /// <returns></returns>
        private IHttpActionResult GetErrorMessage()
        {
            var errorFields = ModelState.Keys;
            JObject jo = new JObject();

            foreach (var fieldName in errorFields)
            {
                var fieldErrors = ModelState[fieldName].Errors;
                if (fieldErrors.Count == 0) continue;
                var key = fieldName.Substring(fieldName.IndexOf('.') + 1);
                jo[key] = string.Join(";", fieldErrors.Select(error => error.ErrorMessage));
            }
            return Json(new { success = false, error = jo.ToString() });
        }


        private IHttpActionResult UpdateData<T>(IService<T> service, IDataVm dataVm)
        {
            if (!ModelState.IsValid) return GetErrorMessage(); 

            var result = service.Update(dataVm);
            return Ok(result);
        }
        [HttpPost]
        public IHttpActionResult UpdateCategory(CategoryVm vm) => UpdateData(new CategoryService(), vm);
        [HttpPost]
        public IHttpActionResult UpdateManager(ManagerProfileVm vm) => UpdateData(new ManagerService(), vm);
        [HttpPost]
        public IHttpActionResult UpdateFAQ(FAQVm vm) => UpdateData(new WebContentService(), vm);




        private IHttpActionResult CreateData<T>(IService<T> service, IDataVm dataVm)
        {
            if (!ModelState.IsValid) return GetErrorMessage();
            var result = service.Insert(dataVm);
            return Ok(result);
        }
        [HttpPost]
        public IHttpActionResult CreateCategory(CategoryVm vm) => CreateData(new CategoryService(), vm);
        [HttpPost]
        public IHttpActionResult CreateManager(ManagerVm vm) => CreateData(new ManagerService(), vm);
        [HttpPost]
        public IHttpActionResult CreateFAQ(FAQVm vm) => CreateData(new WebContentService(), vm);

        private IHttpActionResult DeleteData<T>(IService<T> service, IDataVm dataVm)
        {
            var result = service.Delete(dataVm.Id);
            return Ok(result);
        }
        [HttpPost]
        public IHttpActionResult DeleteCategory(CategoryVm vm) => DeleteData(new CategoryService(), vm);
        [HttpPost]
        public IHttpActionResult DeleteManager(ManagerVm vm) => DeleteData(new ManagerService(), vm);
        [HttpPost]
        public IHttpActionResult DeleteFAQ(FAQVm vm) => DeleteData(new WebContentService(), vm);


        public IHttpActionResult RefundProject(int id)
        {
            try
            {
                new ProjectService().ProcessProjectStatus(id, 23);
                return GetActionResult();
            }
            catch(Exception ex)
            {
                return GetActionResult(ex.Message);
            }
        }
        public IHttpActionResult SubmitProject(int id)
        {
            try
            {
                new ProjectService().ProcessProjectStatus(id, 14);
                return GetActionResult();

            }
            catch (Exception ex)
            {
                return GetActionResult(ex.Message);
            }
        }


        private IHttpActionResult GetActionResult(string msg = "")
        {
            return Ok(new
            {
                success = string.IsNullOrEmpty(msg),
                ErrorMessage = msg
            });
        }
    }


}