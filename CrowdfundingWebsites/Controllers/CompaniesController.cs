using CrowdfundingWebsites.Models.EFModels;
using CrowdfundingWebsites.Models.Infra;
using CrowdfundingWebsites.Models.ViewModels;
using System;
using System.Collections.Generic;
using System.ComponentModel.Design;
using System.IO;
using System.Linq;
using System.Security.Principal;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
using System.Web.UI.WebControls;
using WebApplication1.Models.Infra.FileValidators;
using WebApplication1.Models.Infra;
using static System.Net.WebRequestMethods;
using static Dapper.SqlMapper;

namespace CrowdfundingWebsites.Controllers
{

    public class CompaniesController : Controller
    {
        // GET: Companies
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult CompanyRegister()
        {
            return PartialView();
        }

        [HttpPost]
        public ActionResult CompanyRegister(CompanyRegisterVm vm)
        {


            if (!ModelState.IsValid)//沒有通過驗證
            {

                return PartialView(vm);
            }
            try
            {
                CompanyRegisterConfirm(vm);
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("", ex.Message);
                return PartialView(vm);
            }

            return PartialView("CompanyRegisterConfirm");
        }

        private void CompanyRegisterConfirm(CompanyRegisterVm vm)
        {
            var db = new AppDBContext();

            //判斷帳號是否已經存在
            var companyInDb = db.Companies.FirstOrDefault(p => p.Account == vm.Account);
            if (companyInDb != null)
            {
                throw new Exception("帳號已經存在");
            }

            //將vm company
            var company = vm.ToEFModel();
            //叫用 EF寫入資料庫
            db.Companies.Add(company);
            db.SaveChanges();

            //todo 發出確認信
        }


        //會員啟用的url: /Companies/CompanyActiveRegister?companyId=99&confirmCode=tttttttttttttttttt
        public ActionResult CompanyActiveRegister(int companyId, string confirmCode)
        {
            if (companyId <= 0 || string.IsNullOrEmpty(confirmCode))
            {
                return PartialView("CompanyActiveRegister");
            }


            var db = new AppDBContext();

            //根據companyId,confirmCode取得Company
            var company = db.Companies.FirstOrDefault(p => p.Id == companyId && p.ConfirmCode == confirmCode && p.IsConfirmed == false);
            if (company == null)
            {
                return PartialView();
            }

            //將他更新為已確認
            company.IsConfirmed = true;
            company.ConfirmCode = null;
            db.SaveChanges();

            return PartialView();
        }

        public ActionResult CompanyLogin()
        {
            return PartialView();
        }

        [HttpPost]
        public ActionResult CompanyLogin(CompanyLoginVm vm)
        {
            if (!ModelState.IsValid)
            {
                ModelState.AddModelError("loginError", "帳號或密碼錯誤");
                return PartialView(vm);
            }
            try
            {
                ValidLogin(vm);
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("loginError", ex.Message);//(1)
                return PartialView(vm);
            }

            var processResult = ProcessLogin(vm);//(2)

            Response.Cookies.Add(processResult.Cookie);

            return Redirect(processResult.ReturnUrl);

        }


        public ActionResult CompanyLogout()
        {
            Session.Abandon();
            FormsAuthentication.SignOut();
            return Redirect("/Companies/CompanyLogin");
        }

        [Authorize]
        public ActionResult EditCompanyProfile()
        {
            var currentUserAccount = User.Identity.Name;
            var vm = GetCompanyProfile(currentUserAccount);
            return View(vm);

        }



        [Authorize]
        [HttpPost]

        public ActionResult EditCompanyProfile(EditCompanyProfileVm vm, HttpPostedFileBase myfile)
        {
            if (!ModelState.IsValid)
            {
                return View(vm);
            }

            #region 將檔案上傳到 /File資料夾下
            if (myfile != null)
            {
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
            }
            #endregion

            var currentUserAccount = User.Identity.Name;
            try
            {
                UpdateCompanyProfile(vm, currentUserAccount);
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("", ex.Message);
                return View(vm);
            }
            return RedirectToAction("Index");//回到中心頁

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


        [Authorize]
        public ActionResult EditCompanyPassword()
        {
            return View();
        }

        [Authorize]
        [HttpPost]
        public ActionResult EditCompanyPassword(EditCompanyPasswordVm vm)
        {
            if (!ModelState.IsValid)
            {
                return View(vm);
            }
            try
            {
                var currentAccount = User.Identity.Name;
                ChangePassword(vm, currentAccount);

            }
            catch (Exception ex)
            {
                ModelState.AddModelError("", ex.Message);
                return View(vm);
            }
            return RedirectToAction("Index");
        }

        public ActionResult ForgetCompanyPassword()
        {
            return PartialView();
        }

        [HttpPost]
        public ActionResult ForgetCompanyPassword(ForgetCompanyPasswordVm vm)
        {
            if (!ModelState.IsValid) return PartialView(vm);

            var urlTemplate = Request.Url.Scheme + "://" + //生成 http:// 或https://
            Request.Url.Authority + "/" + //生成網域名稱或ip
            "Companies/ResetCompanyPassword?companyid={0}&confirmCode={1}"; //生成網頁url

            try
            {
                ProcessResetPassword(vm.Account, vm.Email, urlTemplate);

            }
            catch (Exception ex)
            {
                ModelState.AddModelError("", ex.Message);
                return PartialView(vm);
            }
            return PartialView("ForgetCompanyPasswordConfirm");
        }

        public ActionResult ResetCompanyPassword(int companyId, string confirmCode)
        {
            ViewBag.confirmCode = confirmCode;
            return PartialView();
        }

        [HttpPost]
        public ActionResult ResetCompanyPassword(int companyId, string confirmCode, ResetCompanyPasswordVM vm)
        {

            //檢查vm是否通過驗證
            if (!ModelState.IsValid) return PartialView(vm);
            try
            {
                ProcessResetPassword2(companyId, confirmCode, vm);
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("", ex.Message);
                return PartialView(vm);

            }


            //顯示重設密碼成功畫面
            return PartialView("ConfirmCompanyResetPassword");
        }

        private void ProcessResetPassword2(int companyId, string confirmCode, ResetCompanyPasswordVM vm)
        {
            var db = new AppDBContext();

            //companyIndb,confirmCode正確性
            var companyIndb = db.Companies.FirstOrDefault(c => c.Id == companyId &&
            c.IsConfirmed == true &&
            c.ConfirmCode == confirmCode);//因會轉成sql語法，所以大小寫不一樣找得到

            if (companyIndb == null) return;//不動聲色地離開

            //重設密碼
            var salt = HashUtility.GetSalt();
            var hashedPassword = HashUtility.ToSHA256(vm.Password, salt);
            companyIndb.Password = hashedPassword;
            companyIndb.ConfirmCode = null;
            db.SaveChanges();
        }

        private void ProcessResetPassword(string account, string email, string urlTemplate)
        {
            var db = new AppDBContext();
            //檢查account,email正確性
            var companyIndb = db.Companies.FirstOrDefault(c => c.Account == account);

            if (companyIndb == null)
            {
                throw new Exception("帳號不存在");
            }

            if (string.Compare(email, companyIndb.Email, StringComparison.CurrentCultureIgnoreCase) != 0)
            {
                throw new Exception("帳號或Email錯誤");
            }

            //檢查IsConfirmed必須是true，因為只有已啟用帳號才能重設密碼
            if (companyIndb.IsConfirmed == false)
            {
                throw new Exception("您來沒有啟用本帳號，請先完成才能重設密碼");
            }

            //更新紀錄，填入confirmCode
            var confirmCode = Guid.NewGuid().ToString("N");
            companyIndb.ConfirmCode = confirmCode;
            db.SaveChanges();

            //發送重設密碼信
            var url = string.Format(urlTemplate, companyIndb.Id, confirmCode);
            new CompanyEmailHelper().SendForgetPasswordEmail(url, companyIndb.Name, email);



        }

        private void ChangePassword(EditCompanyPasswordVm vm, string account)
        {
            var db = new AppDBContext();
            var companyInDb = db.Companies.FirstOrDefault(p => p.Account == account);
            if (companyInDb == null)
            {
                throw new Exception("帳號不存在");
            }
            var salt = HashUtility.GetSalt();


            //判斷輸入的原始密碼是否正確
            var hashedOrigPassword = HashUtility.ToSHA256(vm.OriginalPassword, salt);
            if (string.Compare(companyInDb.Password, hashedOrigPassword, true) != 0)
            {
                throw new Exception("原始密碼不正確");
            }

            //將新密碼雜湊
            var hashedPassword = HashUtility.ToSHA256(vm.Password, salt);

            //更新紀錄
            companyInDb.Password = hashedPassword;
            db.SaveChanges();
        }

        private object GetCompanyProfile(string account)
        {
            var db = new AppDBContext();

            var company = db.Companies.FirstOrDefault(p => p.Account == account);
            if (company == null)
            {
                throw new Exception("帳號不存在");
            }
            var vm = company.ToEditCompanyProfileVm();
            return vm;
        }
        private void UpdateCompanyProfile(EditCompanyProfileVm vm, string account)
        {
            //利用vm.Id去資料庫取得Company
            var db = new AppDBContext();
            var companyInDb = db.Companies.FirstOrDefault(p => p.Id == vm.Id);

            //如果這筆紀錄與目前使用者不符，就拒絕
            if (string.Compare(companyInDb.Account, account, true) != 0)
            {
                throw new NotImplementedException();
            }
            companyInDb.Name = vm.Name;
            companyInDb.Email = vm.Email;
            companyInDb.Phone = vm.Phone;
            companyInDb.ResponsiblePerson = vm.ResponsiblePerson;
            companyInDb.Introduce = vm.Introduce;
            companyInDb.CreatedTime = DateTime.Now;
            companyInDb.UpdateTime = DateTime.Now;

            db.SaveChanges();
        }
        private void ValidLogin(CompanyLoginVm vm)//(1)
        {
            var db = new AppDBContext();

            //根據帳號取得Company
            var company = db.Companies.FirstOrDefault(p => string.Compare(p.Account, vm.Account, true) == 0);
            if (company == null)
            {
                throw new Exception("帳號或密碼有錯誤");//原則上不要告知細節

            }

            //檢查是否已經確認
            if (company.IsConfirmed == false)
            {
                throw new Exception("您尚未開通會員資格，請先收確認信，並點選信件裡的連結，完成認證，才能登入本網站");
            }

            //將vm裡的密碼先雜湊後，在與db裡的密碼比對
            var salt = HashUtility.GetSalt();
            var hashedPassword = HashUtility.ToSHA256(vm.Password, salt);

            if (string.Compare(company.Password, hashedPassword, true) != 0)
            {
                throw new Exception("帳號或密碼有誤");
            }

        }

        private (string ReturnUrl, HttpCookie Cookie) ProcessLogin(CompanyLoginVm vm)//(2)
        {
            var rememberMe = false;//如果LoginVm有RememberMe屬性，記得要設定
            var account = vm.Account;
            var roles = string.Empty;//在本範例，沒有用到角色設定，所以存入空白

            //建立一張認證票
            var ticket = new FormsAuthenticationTicket(
                1,                  //版本別，沒特別用處
                account,
                DateTime.Now,       //發行日
                DateTime.Now.AddDays(2),//到期日
                rememberMe,             //是否續存
                roles,                  //userdata
                "/"                     //cookie的位置
                );

            //將它加密3次
            var value = FormsAuthentication.Encrypt(ticket);

            //存入cookie
            var cookie = new HttpCookie(FormsAuthentication.FormsCookieName, value);

            //取得return url
            var url = FormsAuthentication.GetRedirectUrl(account, true);//第二個引數沒有用處

            return (url, cookie);

        }
    }
}