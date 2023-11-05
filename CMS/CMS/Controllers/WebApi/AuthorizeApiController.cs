using CrowdfundingWebsites.Models.DTO;
using CrowdfundingWebsites.Models.Services;
using CrowdfundingWebsites.Models.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using System.Web.Security;

namespace CrowdfundingWebsites.Controllers.WebApi
{
    //[RoutePrefix("api/Auth")]
    public class AuthorizeApiController : ApiController
    {
        private readonly PermissionService _service = new PermissionService();

        public IHttpActionResult Get()
        {
            var service = new PermissionService();

            // service.RebuildUserPermission("test");

            service.GetPagePermission();
            return Ok();
        }

        public IHttpActionResult GetRoles(string searchValue)
        {
            var list = _service.GetRoles(searchValue);
            return Ok(list);
        }

        public IHttpActionResult GetPageOfRole(int roleId)
        {
            var list = _service.GetPagesOfRole(roleId);
            return Ok(list);
        }
        public IHttpActionResult GetFunctionOfRole(int roleId, int pageId)
        {
            var list = _service.GetFunctionsOfRole(roleId, pageId);
            return Ok(list);
        }


        public IHttpActionResult GetUsers(string searchValue)
        {
            SearchManagerVm vm = new SearchManagerVm { SearchValue = searchValue };
            var result = new ManagerService().GetAll(vm);

            var data = result.Item1.Select(o => new CheckItemDTO { 

                Id = o.Id,
                Name = o.LastName + o.FirstName,
                //Enabled = o.Enabled,
            }).ToList();

            return Ok(data);
        }

        public IHttpActionResult GetUserRoles(int userId)
        {
            var list = _service.GetRolesForUser(userId);

            return Ok(list);
        }


        public IHttpActionResult AddNewRole(string roleName)
        {
            try
            {
                _service.AddRole(roleName);
                return GetActionResult();
            }
            catch(Exception ex)
            {
                return GetActionResult(ex.Message);
            }
        }

        public IHttpActionResult UpdateRole(int id, string roleName)
        {
            try
            {
                _service.UpdateRoleName(id, roleName);
                return GetActionResult();
            }
            catch (Exception ex)
            {
                return GetActionResult(ex.Message);
            }
        }

        public IHttpActionResult DeletRole(string ids)
        {
            try
            {
                List<int> roleIds = ids.Split(',')
                                   .Select(s => int.TryParse(s, out int result) ? result : -1 )
                                   .ToList();
                                   
                _service.DeleteRole(roleIds);
                return GetActionResult();
            }
            catch (Exception ex)
            {
                return GetActionResult(ex.Message);
            }
        }


        public IHttpActionResult SaveUserRoleRel(int id, string data)
        {
            try
            {
                _service.UpdateUserRoleRel(id, data);
                return GetActionResult();
            }
            catch (Exception ex)
            {
                return GetActionResult(ex.Message);
            }
        }
        public IHttpActionResult SaveRolePageRel(int id, string data)
        {
            try
            {
                _service.UpdateRolePageRel(id, data);
                return GetActionResult();
            }
            catch (Exception ex)
            {
                return GetActionResult(ex.Message);
            }
        }
        public IHttpActionResult SaveRoleFuncsRel(int id, string data, int pageId)
        {
            try
            {
                _service.UpdateRoleFuncsRel(id, data, pageId);
                return GetActionResult();
            }
            catch (Exception ex)
            {
                return GetActionResult(ex.Message);
            }
        }

        private IHttpActionResult GetActionResult(string msg = "")
        {
            return Ok(new {
                success = string.IsNullOrEmpty(msg),
                ErrorMessage = msg
            });
        }

    }
}
