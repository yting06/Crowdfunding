using CrowdfundingWebsites.Models.EFModels;
using CrowdfundingWebsites.Models.Infra;
using CrowdfundingWebsites.Models.Repositories;
using CrowdfundingWebsites.Models.ViewModels;
using CrowdfundingWebsites.Models.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI.WebControls;
using CoraLibrary.Utilities;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json;
using WebGrease.Css.Extensions;
using System.Security.Policy;
using System.Security.Principal;

namespace CrowdfundingWebsites.Models.Services
{
    public class ManagerService : ILoginService, IService<ManagerVm>
    {
        private readonly ManagerRepository _repo;


        public ManagerService()
        {
            _repo = new ManagerRepository();
        }

        public ValidationResult IsValid(LoginVm vm)
        {
            var user = _repo.GetUserByEmailOrAccount(vm.Account);
            if (user == null) 
                return ValidationResult.Fail(DAHelper.Login_ValidError);

            var encryptPW = GetEncryptionPassword(vm.Password);
            if (String.Compare(user.Password, encryptPW, StringComparison.OrdinalIgnoreCase) != 0)
                return ValidationResult.Fail(DAHelper.Login_ValidError);

            if (user.IsConfirmed != true)
                return ValidationResult.Fail(DAHelper.Login_ConfirmError);

            return  ValidationResult.Success();
        }

        /// <summary>
        /// Login，取得使用者授權
        /// </summary>
        /// <param name="account"></param>
        /// <returns></returns>
        public string GetUserPermission(string account)
        {
            string functions = _repo.GetPermission(account);
            if (functions != null) return functions;

            var pService = new PermissionService();
            return pService.RebuildUserFunctions(account);
        }

        public ManagerVm Get(int id)
        {
            var user = _repo.GetUser(id);

            return AutoMapperHelper.MapperObj.Map<ManagerVm>(user);
        }
        public (IEnumerable<ManagerVm>, int) GetAll(ISearchVm searchVm)
        {
            var vm = (SearchManagerVm)searchVm;
            var result = _repo.GetAllByCondiction(vm);
            var data = result.Item1?.Select(x => AutoMapperHelper.MapperObj.Map<ManagerVm>(x)).ToList();

            return (data, result.total);
        }
        public ValidationResult Insert(IDataVm dataVm)
        {
            try
            {
                var vm = dataVm as ManagerVm;
                var user = _repo.GetUserByEmailOrAccount(vm.Account);
                if (user != null) throw new Exception("帳號重複");

                var manager = GetNewManager(vm);
                _repo.Register(manager);
                return ValidationResult.Success();
            }
            catch (Exception ex)
            {
                return ValidationResult.Fail(ex.Message);
            }
        }
        public ValidationResult Update(IDataVm dataVm)
        {
            try
            {
                var vm = dataVm as ManagerProfileVm;
                _repo.Update(vm);
                return ValidationResult.Success();
            }
            catch (Exception ex)
            {
                return ValidationResult.Fail(ex.Message);
            }
        }
        //todo delete Manager
        public ValidationResult Delete(int id)
        {
            try
            {
                _repo.Delete(id);
                return ValidationResult.Success();
            }
            catch (Exception ex)
            {
                return ValidationResult.Fail(ex.Message);
            }
        }

        public void ProcessForgetPassword(string account, string email, Uri uri)
        {
            var user = _repo.GetUserByEmailOrAccount(account);
            if (user == null || email != user.Email) throw new Exception("帳號或信箱錯誤，請重新輸入");

            user.ConfirmCode = Guid.NewGuid().ToString("N");
            _repo.Update(user);

            ProcessForgetEmail(user, uri);
        }

        public void ResetPassword(ResetPasswordVm vm)
        {
            var user = _repo.GetUser(vm.Id);
            if (user == null) throw new Exception("密碼更新異常");
            
            user.ConfirmCode = null;
            user.Password = GetEncryptionPassword(vm.Password);
            _repo.Update(user);
        }


        public void ProcessConfirm(int id, string confirmCode) => _repo.ConfirmUser(id, confirmCode);

        public bool IsValid(int id, string confirmCode)
        {
            var user = _repo.GetUser(id);
            if (user == null) return false;
            return String.Compare(user.ConfirmCode, confirmCode, StringComparison.OrdinalIgnoreCase) == 0;
        }


        public void RegisterMember(ManagerVm vm, Uri uri)
        {
            var manager = GetNewManager(vm);
            _repo.Register(manager);
            ProcessConfirmEmail(manager, uri);
        }

        private Manager GetNewManager(ManagerVm vm)
        {
            var manager = AutoMapperHelper.MapperObj.Map<Manager>(vm);
            manager.Password = GetEncryptionPassword(vm.Password);
            manager.ConfirmCode = Guid.NewGuid().ToString("N");
            return manager;
        }

        private string GetEncryptionPassword(string password)
        {
            var salt = HashUtility.GetSalt();
            return HashUtility.ToSHA256(password, salt);
        }

        public void RegisterMembers(IEnumerable<ManagerVm> vms, Uri uri)
        {
            try
            {
                var managers = vms.Select(item => GetNewManager(item)).ToList();
                _repo.RegisterManagers(managers);
                managers.ForEach(manager => ProcessConfirmEmail(manager, uri));
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public void ProcessConfirmEmail(Manager manager, Uri uri)
        {
            var urlTemplate = $@"{uri.Scheme}://{uri.Authority}/Manager/ConfirmRegister?
key={manager.Id}&confirmCode={manager.ConfirmCode}";
            new MailHelper().SendConfirmRegisterEMail(urlTemplate, manager.FirstName, manager.Email);
        }

        public void ProcessForgetEmail(Manager manager, Uri uri)
        {
            var urlTemplate = $@"{uri.Scheme}://{uri.Authority}/Manager/ResetPassword?
key={manager.Id}&confirmCode={manager.ConfirmCode}";
            new MailHelper().SendForgetPasswordEMail(urlTemplate, manager.FirstName, manager.Email);
        }
    }
}