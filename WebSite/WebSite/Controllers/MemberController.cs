using CrowdfundingWebsites.Models.EFModels;
using CrowdfundingWebsites.Models.Infra;
using CrowdfundingWebsites.Models.Infra.FileValidators;
using CrowdfundingWebsites.Models.ViewModels;
using System;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;

namespace CrowdfundingWebsites.Controllers
{
	public class MemberController : Controller
	{
		// GET: Member
		[Authorize]
		public ActionResult Index()
        {
            var currentUserAccount = User.Identity.Name;
            var db = new AppDBContext();
            var existUser = db.Members.FirstOrDefault(m => string.Compare(m.Account, currentUserAccount) == 0);
			if(existUser == null)
			{
				return RedirectToAction("Index", "Home");
			}

			var vm = existUser.ToMemberVm();
            vm.Image = UploadFileHelper.GetProjectFullPath(vm.Image);

            return View(vm);
		}
		public ActionResult Register()
		{
			return PartialView();
		}

		[HttpPost]
		public ActionResult Register(RegisterVm vm)
		{
			if (!ModelState.IsValid) return PartialView(vm);

			try
			{
				ProcessRegister(vm);
			}
			catch (Exception ex)
			{
				ModelState.AddModelError("", ex.Message);
				return PartialView(vm);
			}
			return PartialView("RegisterConfirm");
		}

		private void ProcessRegister(RegisterVm vm)
		{
			try
            {
                var db = new AppDBContext();
				var existUser = db.Members.FirstOrDefault(m=> string.Compare(m.Account,vm.Account) == 0);
				if (existUser != null) throw new Exception("該帳號已註冊");

				var member = AutoMapperHelper.MapperObj.Map<Member>(vm);
				member.Password = GetEncryptionPassword(member.Password);
				member.ConfirmCode = Guid.NewGuid().ToString("N");
                member.CreatTime = DateTime.Now;
				member.UpdateTime = DateTime.Now;

				db.Members.Add(member);
				db.SaveChanges();

				var memberInDb = db.Members.FirstOrDefault(m => m.Account == member.Account);

				var urlTemplate = Request.Url.Scheme + "://" +
							  Request.Url.Authority + "/" +
							  "Member/ActiveRegister?memberId={0}&confirmCode={1}";

				var url = string.Format(urlTemplate, memberInDb.Id, memberInDb.ConfirmCode);
				new EmailHelper().SendConfirmRegisterEmail(url, memberInDb.Name, member.Email);
			}
			catch (Exception ex)
			{
				throw new Exception(ex.Message, ex);
			}
		}

		private string GetEncryptionPassword(string password)
		{
			var salt = HashUtility.GetSalt();
			return HashUtility.ToSHA256(password, salt);
		}

		public ActionResult ActiveRegister(int memberId, string confirmCode)
		{
			if (memberId <= 0 || string.IsNullOrEmpty(confirmCode))
			{
				return PartialView();
			}
			var db = new AppDBContext();

			var member = db.Members.FirstOrDefault(p => p.Id == memberId && p.ConfirmCode == confirmCode );
			if (member == null)
			{
				return PartialView();
			}

			member.IsConfirmed = true;
			member.ConfirmCode = null;
			db.SaveChanges();

			return PartialView();
		}

		public ActionResult Login()
		{
			return PartialView();
		}

		[HttpPost]
		public ActionResult Login(LoginVm vm)
		{
			if (!ModelState.IsValid)
			{
				return PartialView(vm);
			}

			try
			{
				ValidLogin(vm);
			}
			catch (Exception ex)
			{
				ModelState.AddModelError("", ex.Message);
				return PartialView(vm);
			}

			var processResult = ProcessLogin(vm);

			Response.Cookies.Add(processResult.Cookie);

			return Redirect(processResult.ReturnUrl);
		}

		public ActionResult Logout()
		{
			Session.Abandon();
			FormsAuthentication.SignOut();
			return Redirect("/Member/Login");
		}

		[Authorize]
		public ActionResult EditProfile()
		{
			var currentUserAccount = User.Identity.Name;
			var vm = GetMemberProfile(currentUserAccount);

			return View(vm);
		}

		[Authorize]
		[HttpPost]
		public ActionResult EditProfile(EditProfileVm vm, HttpPostedFileBase Image)
		{
			var currentUserAccount = User.Identity.Name;
			if (!ModelState.IsValid)
			{
				return View(vm);
			}
			try
			{
				UpdateProfile(vm, currentUserAccount, Image);
			}
			catch (Exception ex)
			{
				ModelState.AddModelError("", ex.Message);
				return View(vm);
			}

			return RedirectToAction("Index");
		}

		[Authorize]
		public ActionResult EditPassword()
		{
			return View();
		}

		[Authorize]
		[HttpPost]
		public ActionResult EditPassword(EditPasswordVm vm)
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


		public ActionResult ForgetPassword()
		{
			return PartialView();
		}

		[HttpPost]
		public ActionResult ForgetPassword(ForgetPasswordVm vm)
		{
			if (!ModelState.IsValid) return PartialView(vm);

			var urlTemplate = Request.Url.Scheme + "://" +
							  Request.Url.Authority + "/" +
							  "Member/ResetPassword?memberId={0}&confirmCode={1}";

			try
			{
				ProcessResetPassword(vm.Account, vm.Email, urlTemplate);
			}
			catch (Exception ex)
			{
				ModelState.AddModelError("", ex.Message);
				return PartialView(vm);
			}

			return View("ForgetPasswordConfirm");

		}



		public ActionResult ResetPassword(int memberId, string confirmCode)
		{
			return PartialView();
		}

		[HttpPost]
		public ActionResult ResetPassword(int memberId, string confirmCode, ResetPasswordVM vm)
		{
			if (!ModelState.IsValid) return PartialView(vm);

			try
			{
				ProcessResetPassword(memberId, confirmCode, vm);
			}
			catch (Exception ex)
			{
				ModelState.AddModelError("", ex.Message);
				return PartialView(vm);

			}

			return PartialView("ConfirmResetPassword");
		}


		private void ProcessResetPassword(int memberId, string confirmCode, ResetPasswordVM vm)
		{
			var db = new AppDBContext();

			var memberInDb = db.Members.FirstOrDefault(m => m.Id == memberId &&
														m.IsConfirmed == true &&
														m.ConfirmCode == confirmCode);
			if (memberInDb == null) return;


			var salt = HashUtility.GetSalt();
			var hashedPassword = HashUtility.ToSHA256(vm.Password, salt);
			memberInDb.Password = hashedPassword;
			memberInDb.ConfirmCode = null;
			db.SaveChanges();
		}

		private void ProcessResetPassword(string account, string email, string urlTemplate)
		{
			var db = new AppDBContext();

			var memberInDb = db.Members.FirstOrDefault(m => m.Account == account);
			if (memberInDb == null)
			{
				throw new Exception("帳號不存在");
			}

			if (string.Compare(email, memberInDb.Email, StringComparison.CurrentCultureIgnoreCase) != 0)
			{
				throw new Exception("帳號或 Email 錯誤");
			}

			if (memberInDb.IsConfirmed == false)
			{
				throw new Exception("您還沒有啟用本帳號, 請先完成才能重設密碼");
			}

			var confirmCode = Guid.NewGuid().ToString("N");
			memberInDb.ConfirmCode = confirmCode;
			db.SaveChanges();

			var url = string.Format(urlTemplate, memberInDb.Id, confirmCode);

			new EmailHelper().SendForgetPosswordEmail(url, memberInDb.Name, email);

		}

		private void ChangePassword(EditPasswordVm vm, string account)
		{
			var db = new AppDBContext();
			var memberInDb = db.Members.FirstOrDefault(p => p.Account == account);
			if (memberInDb == null)
			{
				throw new Exception("帳號不存在");
			}

			var salt = HashUtility.GetSalt();

			var hashedOrigPassword = HashUtility.ToSHA256(vm.OriginalPassword, salt);
			if (string.Compare(memberInDb.Password, hashedOrigPassword, true) != 0)
			{
				throw new Exception("原始密碼不正確");
			}

			var hashedPassword = HashUtility.ToSHA256(vm.Password, salt);

			memberInDb.Password = hashedPassword;
			db.SaveChanges();
		}

		private void UpdateProfile(EditProfileVm vm, string account, HttpPostedFileBase image)
		{
			var db = new AppDBContext();
			var memberInDb = db.Members.FirstOrDefault(p => p.Id == vm.Id);

			if (memberInDb.Account != account)
			{
				throw new Exception("您沒有權限修改別人的資料");
			}

			if(image != null)
			{
                try
                {
                    string fileName = "";
                    ProcessImage(image, out fileName);
                    memberInDb.Image = fileName;
                }
                catch (Exception ex)
                {
                    ModelState.AddModelError("imagefile", ex.Message);
                }
            }

			memberInDb.Id = vm.Id;
			memberInDb.Name = vm.Name;
			memberInDb.Birthday = vm.Birthday;
			memberInDb.Introduce = vm.Introduce;

			db.SaveChanges();
		}

		private EditProfileVm GetMemberProfile(string account)
		{
			var db = new AppDBContext();

			var member = db.Members.FirstOrDefault(p => p.Account == account);
			if (member == null)
			{
				throw new Exception("帳號不存在");
			}

			var vm = member.ToEditProfileVm();

			return vm;
		}

		private void ValidLogin(LoginVm vm)
		{
			var db = new AppDBContext();

			var member = db.Members.FirstOrDefault(p => p.Account == vm.Account);
			if (member == null)
			{
				throw new Exception("帳號或密碼有誤");
			}

			if (member.IsConfirmed != true)
			{
				throw new Exception("您尚未開通會員資格, 請先收確認信, 並點選信裡的連結, 完成認證, 才能登入本網站");
			}

			var salt = HashUtility.GetSalt();
			var hashedPassword = HashUtility.ToSHA256(vm.Password, salt);

			if (string.Compare(member.Password, hashedPassword, true) != 0)
			{
				throw new Exception("帳號或密碼有誤");
			}

		}

		private (string ReturnUrl, HttpCookie Cookie) ProcessLogin(LoginVm vm)
		{
			var rememberMe = false;
			var account = vm.Account;
			var roles = string.Empty;


			var ticket =
				new FormsAuthenticationTicket(
					1,
					account,
					DateTime.Now,
					DateTime.Now.AddDays(2),
					rememberMe,
					roles,
					"/"
				);

			var value = FormsAuthentication.Encrypt(ticket);

			var cookie = new HttpCookie(FormsAuthentication.FormsCookieName, value);

			var url = FormsAuthentication.GetRedirectUrl(account, true);

			return (url, cookie);

		}

		private void RegisterMember(RegisterVm vm)
		{
			var db = new AppDBContext();

			var memberInDb = db.Members.FirstOrDefault(p => p.Account == vm.Account);
			if (memberInDb != null)
			{
				throw new Exception("帳號已經存在");
			}

			var member = vm.ToEFModel();

			db.Members.Add(member);
			db.SaveChanges();
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
            
			var newDest = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, dest.Replace("../", ""));

            string destFullPath = Path.Combine(newDest, fileName);
            destFullPath = Path.GetFullPath(destFullPath);

            System.IO.File.Copy(sourceFullPath, destFullPath, true);

        }
    }
}