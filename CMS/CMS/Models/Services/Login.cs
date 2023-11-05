using CoraLibrary.Utilities;
using CrowdfundingWebsites.Models.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;

namespace CrowdfundingWebsites.Models.Services
{
    public class Login
    {
        private readonly ILoginService _loginService;

        public Login(ILoginService service)
        {
            _loginService = service;
        }

        public string ProcessLogin(LoginVm vm, out HttpCookie cookie)
        {
            string account = vm.Account;
            var functions = _loginService.GetUserPermission(account);

            FormsAuthenticationTicket ticket =
                new FormsAuthenticationTicket(
                    1,          //版本別, 沒特別用處
                    account,
                    DateTime.Now,
                    DateTime.Now.AddDays(2), //到期日
                    vm.RememberMe,     //是否續存
                    functions,          //userdata
                    FormsAuthentication.FormsCookiePath             //cookie位置
                );

            string value = FormsAuthentication.Encrypt(ticket);
            cookie = new HttpCookie(FormsAuthentication.FormsCookieName, value);

            string url = FormsAuthentication.GetRedirectUrl(account, true);
            return url;
        }

        /// <summary>
        /// 檢查，1.帳號密碼是否正確   2.是否通過驗證
        /// </summary>
        /// <returns></returns>
        public ValidationResult IsValid(LoginVm vm) => _loginService.IsValid(vm);

    }



    public interface ILoginService
    {
        ValidationResult IsValid(LoginVm vm);
        string GetUserPermission(string account);
    }
}