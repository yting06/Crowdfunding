using CoraLibrary;
using CrowdfundingWebsites.Models.DTO;
using CrowdfundingWebsites.Models.EFModels;
using CrowdfundingWebsites.Models.Infra;
using CrowdfundingWebsites.Models.Repositories;
using CrowdfundingWebsites.Models.ViewModels;
using Microsoft.Ajax.Utilities;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Helpers;
using System.Web.Security;
using System.Web.UI;

namespace CrowdfundingWebsites.Models.Services
{
    public class PermissionService
    {
        private const string _file = "Auth_Page.json";

        private readonly PermissionRepository _repo;

        public PermissionService()
        {
            _repo = new PermissionRepository();
        }


        public void AddRole(string roleName)
        {
            var existRole = _repo.GetRole(roleName);
            if (existRole != null) throw new Exception("角色名稱重複");

            var role = new Role
            {
                Name = roleName,
                Type = "WebOrg",
                ReadOnly = false,
            };
            _repo.AddNewRole(role);
        }

        public void UpdateRoleName(int id, string roleName)
        {
            try
            {
                var existRole = _repo.GetRole(roleName);
                if (existRole != null && existRole.Id != id) throw new Exception("角色名稱重複，請重新命名");
                _repo.UpdateRoleName(id, roleName);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public void DeleteRole(List<int> ids)
        {
            try
            {
                _repo.DeleteRoles(ids);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public bool IsValidRoleName(string roleName)
        {
            try
            {
                var role = _repo.GetRoles(roleName);
                return role == null;

            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }


        public IEnumerable<PageDTO> GetPagePermission()
        {
            var file = new FileHelper();
            if (file.Exists(_file))
            {
                string result = file.GetFileData(_file);
                return JsonConvert.DeserializeObject<IEnumerable<PageDTO>>(result);
            }
            return RebuildPagePermission();
        }

        //todo 重建後，需要刪除所有的Page Permission
        private IEnumerable<PageDTO> RebuildPagePermission()
        {
            var pageDtos = _repo.GetPageFunctions();
            string content = JsonConvert.SerializeObject(pageDtos);
            new FileHelper().SaveFile(_file, content);
            return pageDtos;
        }


        //todo 重建後，需要刪除所有的UserPermission
        public string RebuildUserFunctions(string account)
        {
            var functionDtos = _repo.GetPermissionsByAccount(account);

            List<int> pages = new List<int>();
            List<int> functins = new List<int>();

            functionDtos.ForEach(item =>
            {
                if (pages.IndexOf(item.ParentPageId) < 0) pages.Add(item.ParentPageId);
                if (functins.IndexOf(item.Id) < 0) functins.Add(item.Id);
            });

            var objResult = new
            {
                Pages = pages,
                Functions = functins
            };

            string result = JsonConvert.SerializeObject(objResult);
            _repo.SaveUserPermission(account, result);
            return result;
        }

        public List<RoleVm> GetRoles(string searchValue = "")
        {
            try
            {
                var list = _repo.GetRoles(searchValue);
                return list.Select(p => AutoMapperHelper.MapperObj.Map<RoleVm>(p)).ToList();
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public List<CheckItemDTO> GetPagesOfRole(int roleId)
        {
            try
            {
                var list = _repo.GetPagesOfRoles(roleId);
                return list;
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public List<CheckItemDTO> GetFunctionsOfRole(int roleId, int pageId)
        {
            try
            {
                var list = _repo.GetFunctionsOfRole(roleId, pageId);
                return list;
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public List<CheckItemDTO> GetRolesForUser(int userId)
        {
            try
            {
                var list = _repo.GetRolesOfUser(userId);
                return list;
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public void UpdateUserRoleRel(int userId, string data)
        {
            try
            {
                var roles = GetRolesForUser(userId);
                var oriList = roles.Where(o => o.Enabled).Select(p => p.Id).OrderBy(s => s).ToList();
                var result = getLists(oriList, data);
                if (result.isSame) return;
                _repo.UpdateUserRoleRel(userId, result.add, result.delete);

            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public void UpdateRolePageRel(int roleId, string data)
        {
            try
            {
                var pages = GetPagesOfRole(roleId);
                var oriList = pages.Where(o => o.Enabled).Select(p => p.Id).OrderBy(s => s).ToList();
                var result = getLists(oriList, data);
                if (result.isSame) return;
                _repo.UpdateRolePageRel(roleId, result.add, result.delete);

            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public void UpdateRoleFuncsRel(int roleId, string data, int pageId)
        {
            try
            {
                var funcs = GetFunctionsOfRole(roleId, pageId);
                var oriList = funcs.Where(o => o.Enabled).Select(p => p.Id).OrderBy(s => s).ToList();
                var result = getLists(oriList, data);
                if (result.isSame) return;
                _repo.UpdateRoleFuncsRel(roleId, result.add, result.delete);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        private (List<int> add, List<int> delete, bool isSame) getLists(List<int> oriList, string data)
        {
            List<int> add = new List<int>();
            var list = string.IsNullOrEmpty(data) ? new List<int>() : ParseData(data);
            bool isSame = true;

            list.ForEach(i =>
            {
                if (oriList.IndexOf(i) == -1)
                {
                    add.Add(i);
                    isSame = false;
                }
                else
                {
                    oriList.Remove(i);
                }
            });

            if(isSame) isSame = oriList.Count == 0;

            return (add, oriList, isSame);
        }

        private List<int> ParseData(string data) => data.Split(new char[] { ',' })
                                                        .Select(s => int.TryParse(s, out int r) ? r : -1)
                                                        .OrderBy(s => s)
                                                        .ToList();


    }


}