using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;

namespace CrowdfundingWebsites.Models.Infra.FileValidators
{
	public class FileReqired : IFileValidator
	{
		public void Validate (HttpPostedFileBase file) 
		{
		if (file == null || file.ContentLength == 0)
			{
				throw new Exception("請選擇檔案");
			}
		}
	}
	public class ImageValidator : IFileValidator
	{
		public void Validate(HttpPostedFileBase file)
		{
			if (file == null || file.ContentLength == 0) return;

			string[] imgExts = new string[] { ".jpg", ".jpeg", ".png" };
			string ext = Path.GetExtension(file.FileName).ToLower();
			if (!imgExts.Contains(ext))
			{
				throw new Exception("請上傳圖檔，目前檔名是" + ext);

			}

		}
	}	
}