using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;

namespace CrowdfundingWebsites.Models.Infra
{
	public class EmailHelper
	{
		public string senderEmail = "mumu@gmail.com.xx";

		public void SendConfirmRegisterEmail(string url, string name, string email)
		{
			var subject = "[註冊確認信] 沐沐 : 募資平台";
			var body = $@"Hi{name},
<br/>
親愛的{name}您好:

歡迎您加入沐沐 : 募資平台會員，

請點擊連結[<a href='{url}' target='_blank'>確認註冊</a>],以正式開通您的會員帳號,
(連結無效時,請複製URL貼在瀏覽器網址列上按Enter),

若您並未申請，請不必理會此信件!
此為系統自動寄送訊息，請勿直接回覆本郵件";

			var from = senderEmail;
			var to = email;

			SendViaGoogle(from, to, subject, body);
		}


		public void SendForgetPosswordEmail(string url, string name, string email)
		{
			var subject = "[重設密碼通知] 沐沐 : 募資平台";
			var body = $@"Hi{name},
<br />
親愛的{name}您好:

已收到您忘記密碼的申請，

請點擊連結[<a href='{url}' target='_blank'>重設密碼</a>],進入重設密碼的頁面,
(連結無效時,請複製URL貼在瀏覽器網址列上按Enter),

若您並未申請，請不必理會此信件!
此為系統自動寄送訊息，請勿直接回覆本郵件";

			var from = senderEmail;
			var to = email;

			SendViaGoogle(from, to, subject, body);
		}

		public virtual void SendViaGoogle(string from, string to, string subject, string body)
		{
			var path = HttpContext.Current.Server.MapPath("~/Files/");
			CreateTextFile(path, from, to, subject, body);
			return;
		}

		public void CreateTextFile(string path, string from, string to, string subject, string body)
		{
			var fileName = $"{to.Replace("@", "_")}{DateTime.Now.ToString("yyyyMMdd_HHmmss")}.txt";

			var fullPath = Path.Combine(path, fileName);

			var contents = $@"from:{from}
to:{to}
subject:{subject}

{body}";
			File.WriteAllText(fullPath, contents, Encoding.UTF8);
		}
	}
}