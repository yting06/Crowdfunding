using CoraLibrary.SqlDataLayer;
using CrowdfundingWebsites.Models.DTO;
using CrowdfundingWebsites.Models.EFModels;
using Dapper;
using Microsoft.Ajax.Utilities;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Migrations;
using System.Linq;
using System.Security.Principal;
using System.Web.UI.WebControls;
using Page = CrowdfundingWebsites.Models.EFModels.Page;

namespace CrowdfundingWebsites.Models.Repositories
{
    public class PermissionRepository
    {
        private readonly AppDBContext _db = new AppDBContext();
        private readonly string _cnnKey = "AppDBContext";
        /// <summary>
        /// 列出所有頁面權限
        /// </summary>
        /// <returns></returns>
        public IEnumerable<PageDTO> GetPageFunctions()
        {
            string sql = @"
SELECT P.* , F.*
FROM Pages P
INNER JOIN Functions F on F.ParentPageId = P.Id";

            Dictionary<int, PageDTO> dict = new Dictionary<int, PageDTO>();
            using (var cnn = new SqlDb().GetSqlConnection(_cnnKey))
            {
                cnn.Query<Page, Function, PageDTO>(sql, (p, f) =>
                {
                    int pageId = p.Id;
                    var funcDto = AutoMapperHelper.MapperObj.Map<FunctionDTO>(f);
                    var pageDto = dict.ContainsKey(pageId) ? dict[pageId] : AutoMapperHelper.MapperObj.Map<PageDTO>(p);
                    funcDto.Visible = false;
                    pageDto.Functions.Add(funcDto);

                    dict[pageId] = pageDto;
                    return pageDto;
                }).ToList();
            }

            return dict.Values.ToList();
        }
        /// <summary>
        /// 找出角色有的功能，(其角色需有頁面權限才能顯示此功能) 
        /// </summary>
        /// <param name="roleId"></param>
        /// <returns></returns>
        public List<FunctionDTO> GetFunctionsOfRole(int roleId, bool onlyPage = true)
        {
            string sql = @"
SELECT F.*
FROM Roles R
INNER JOIN RolePageRel RPR on RPR.RoleId = R.Id
INNER JOIN Pages P on P.Id = RPR.PageId
INNER JOIN RoleFunctionRel RFR on RFR.RoleId =  R.Id
INNER JOIN Functions F on F.Id = RFR.FunctionId AND (@OnlyPage = 0 OR P.Id = F.ParentPageId)
WHERE R.Id = @RoleId";

            using (var cnn = new SqlDb().GetSqlConnection(_cnnKey))
            {
                return cnn.Query<FunctionDTO>(sql, new { RoleId = roleId, OnlyPage = onlyPage })
                    .Select(dto => { dto.Visible = true; return dto; }).ToList();
            }
        }

        /// <summary>
        /// 找出有指定角色的使用者
        /// </summary>
        /// <param name="roleId"></param>
        /// <returns></returns>
        public List<ManagerDTO> GetUserWithRole(int roleId)
        {
            string sql = @"
SELECT M.* 
FROM Roles R 
INNER JOIN ManagerRoleRel MRR on MRR.RoleId = R.Id 
INNER JOIN Managers M on MRR.ManagerId = M.Id
WHERE R.Id = @RoleId;
";

            using (var cnn = new SqlDb().GetSqlConnection(_cnnKey))
            {
                return cnn.Query<ManagerDTO>(sql, new { RoleId = roleId }).ToList();
            }
        }

        public List<RoleDTO> GetUserRoles(int userId)
        {
            string sql = @"
SELECT R.* 
FROM Managers M
INNER JOIN ManagerRoleRel MRR on MRR.ManagerId = M.Id
INNER JOIN Roles R on R.Id = MRR.RoleId
WHERE M.Id = @UserId;
";
            using (var cnn = new SqlDb().GetSqlConnection(_cnnKey))
            {
                return cnn.Query<RoleDTO>(sql, new { UserId = userId }).ToList();
            }
        }

        /// <summary>
        /// 找出使用者所有的權限
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
        public List<FunctionDTO> GetUserFunctions(string userAccount)
        {
            string sql = @"
SELECT F.* 
FROM Managers M
INNER JOIN ManagerRoleRel MRR on MRR.ManagerId = M.Id
INNER JOIN Roles R on R.Id = MRR.RoleId
INNER JOIN RolePageRel RPR on RPR.RoleId = R.Id
INNER JOIN RoleFunctionRel RFR on RFR.RoleId = R.Id
INNER JOIN Functions F on RFR.FunctionId = F.Id AND F.ParentPageId = RPR.PageId
WHERE M.Account = @Account";

            using (var cnn = new SqlDb().GetSqlConnection(_cnnKey))
            {
                return cnn.Query<FunctionDTO>(sql, new { Account = userAccount })
                    .Select(dto => { dto.Visible = true; return dto; }).ToList();
            }
        }



        public List<FunctionDTO> GetPermissionsByAccount(string account)
        {
            string sql = @"
SELECT F.* 
FROM Managers M
INNER JOIN ManagerRoleRel MRR on MRR.ManagerId = M.Id
INNER JOIN Roles R on R.Id = MRR.RoleId
INNER JOIN RolePageRel RPR on RPR.RoleId = R.Id
INNER JOIN RoleFunctionRel RFR on RFR.RoleId = R.Id
INNER JOIN Functions F on RFR.FunctionId = F.Id AND F.ParentPageId = RPR.PageId
WHERE M.Account = @Account";

            using (var cnn = new SqlDb().GetSqlConnection(_cnnKey))
            {
                return cnn.Query<FunctionDTO>(sql, new { Account = account })
                    .Select(dto => { dto.Visible = true; return dto; }).ToList();
            }
        }

        public void SaveUserPermission(string account, string permissions)
        {
            var auth = new ManagersAuth { Account = account, Json = permissions };
            var db = new AppDBContext();
            //todo --儲存
            //db.ManagersAuths.Add(auth);
            //db.SaveChanges();
        }

        public Role GetRole(string roleName) => _db.Roles.FirstOrDefault(r => string.Compare(r.Name, roleName) == 0);

        public void AddNewRole(Role role)
        {
            _db.Roles.Add(role);
            _db.SaveChanges();
        }

        public void UpdateRoleName(int id, string roleName)
        {
            var item = _db.Roles.FirstOrDefault(c => c.Id == id);
            item.Name = roleName;
            _db.SaveChanges();
        }

        public void DeleteRoles(List<int> roleIds)
        {
            string paramStr = string.Join(",", roleIds) + ",";

            using (var cnn = new SqlDb().GetSqlConnection(_cnnKey))
            {
                string storedProcedureName = "DeleteRolesData";
                var parameters = new { IdsToDelete = paramStr };
                cnn.Execute(storedProcedureName, parameters, commandType: CommandType.StoredProcedure);
            }
        }

        /// <summary>
        /// 找出所有角色
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
        public List<Role> GetRoles(string searchValue = "")
        {
            if (string.IsNullOrEmpty(searchValue)) return _db.Roles.ToList();

            var list = _db.Roles
                          .Where(r => r.Name.IndexOf(searchValue) > -1)
                          .ToList();

            return list;
        }
        /// <summary>
        /// 找出角色的頁面權限
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
        public List<CheckItemDTO> GetPagesOfRoles(int roleId)
        {
            string sql = @"
SELECT P.Id, 
       P.Name,  
       CASE WHEN RPR.PageId IS NOT NULL THEN 1 ELSE 0 END AS Enabled
FROM Pages P 
LEFT JOIN RolePageRel RPR ON RPR.PageId = P.Id AND RPR.RoleId = @RoleId;
";

            using (var cnn = new SqlDb().GetSqlConnection(_cnnKey))
            {
                return cnn.Query<CheckItemDTO>(sql, new { RoleId = roleId }).ToList();
            }
        }

        public List<CheckItemDTO> GetFunctionsOfRole(int roleId, int pageId)
        {
            string sql = @"
SELECT 
F.Id,
F.Name,
CASE WHEN RFR.FunctionId IS NOT NULL THEN 1 ELSE 0 END AS Enabled
FROM Functions F
LEFT JOIN RoleFunctionRel RFR ON RFR.FunctionId = F.Id AND RFR.RoleId = @RoleId
WHERE F.ParentPageId = @PageId
";

            using (var cnn = new SqlDb().GetSqlConnection(_cnnKey))
            {
                return cnn.Query<CheckItemDTO>(sql, new { RoleId = roleId, PageId = pageId }).ToList();
            }
        }

        public List<CheckItemDTO> GetRolesOfUser(int userId)
        {
            string sql = @"
SELECT 
R.Id, 
R.Name,  
CASE WHEN MRR.RoleId IS NOT NULL THEN 1 ELSE 0 END AS Enabled
FROM Roles R 
LEFT JOIN  ManagerRoleRel MRR ON MRR.RoleId = R.Id AND MRR.ManagerId = @UserId;
";

            using (var cnn = new SqlDb().GetSqlConnection(_cnnKey))
            {
                return cnn.Query<CheckItemDTO>(sql, new { UserId = userId }).ToList();
            }

        }


        public void UpdateUserRoleRel(int userId, List<int> addFuncs, List<int> deleteFuncs)
        {
            string add = string.Join(",", addFuncs) + ",", delete = string.Join(",", deleteFuncs) + ",";
            var oParameter = new { UserId = userId, IdsToDelete = delete };
            RunStoreProcedure("UpdateUserRoleRel", oParameter);

            if (addFuncs.Count == 0) return;

            var rels = addFuncs.Select(i => new ManagerRoleRel { RoleId = i, ManagerId = userId }).ToList();
            _db.ManagerRoleRels.AddRange(rels);
            _db.SaveChanges();
        }


        public void UpdateRolePageRel(int roleId, List<int> addFuncs, List<int> deleteFuncs)
        {
            string add = string.Join(",", addFuncs) + ",", delete = string.Join(",", deleteFuncs) + ",";
            var oParameter = new { RoleId = roleId, IdsToDelete = delete};
            RunStoreProcedure("UpdateRolePageRel", oParameter);

            if (addFuncs.Count == 0) return;
            var rels = addFuncs.Select(i => new RolePageRel { PageId = i, RoleId = roleId }).ToList();
            _db.RolePageRels.AddRange(rels);
            _db.SaveChanges();
        }

        public void UpdateRoleFuncsRel(int roleId, List<int> addFuncs, List<int> deleteFuncs)
        {
            string add = string.Join(",", addFuncs) + ",", delete = string.Join(",", deleteFuncs) + ",";
            var oParameter = new { RoleId = roleId, IdsToDelete = delete };
            RunStoreProcedure("UpdateRoleFuncsRel", oParameter);

            if (addFuncs.Count == 0) return;

            var rels = addFuncs.Select(i => new RoleFunctionRel { FunctionId = i, RoleId = roleId }).ToList();
            _db.RoleFunctionRels.AddRange(rels);
            _db.SaveChanges();
        }

        private void RunStoreProcedure(string storedProcedureName, object parameters)
        {
            using (var cnn = new SqlDb().GetSqlConnection(_cnnKey))
            {
                cnn.Execute(storedProcedureName, parameters, commandType: CommandType.StoredProcedure);
            }

        }



    }
}