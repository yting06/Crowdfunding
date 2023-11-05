using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;

namespace CrowdfundingWebsites.Models.Infra
{
    public class MailHelper
    {
        private string senderEmail = "g01.webapp@gamail.com";

        public void SendForgetPasswordEMail(string url, string name, string email)
        {
            var subject = "[重設密碼通知]";
            var body = $"Hi {name}, <br /> 請點擊此連結 [<a href='{url}' target='_blank'>我要重設密碼</a>]，以進行重設密碼，如果您沒有提出申請，請忽略此信，謝謝";

            var from = senderEmail;
            var to = email;

            SendViaGoogle(from, to, subject, body);
        }


        public void SendConfirmRegisterEMail(string url, string name, string email)
        {
            var subject = "[新會員確認信]";
            var body = $@"Hi {name}, <br /> 請點擊此連結 [<a href='{url}' target='_blank'>申請的會員</a>]，如果您沒有提出申請，請忽略本信謝謝";


            var from = senderEmail;
            var to = email;
            SendViaGoogle(from, to, subject, body);
        }




        public virtual void SendViaGoogle(string from, string to, string subject, string body)
        {
            var path = HttpContext.Current.Server.MapPath("~/files");

            CreateTextFile(path, from, to, subject, body);
            return;
        }

        public void CreateTextFile(string path, string from, string to, string subject, string body)
        {
            var fileName = $"{to.Replace("@", "_")} {subject} {DateTime.Now.ToString("yyyyMMdd_HHmmss")}.txt";

            var fullPath = Path.Combine(path, fileName);

            var contents = $@"from:{from}
to:{to}
subject:{subject}
{body}";

            File.WriteAllText(fullPath, contents, Encoding.UTF8);



        }
    }
}