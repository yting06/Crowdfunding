using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Xml.Linq;
using static System.Net.Mime.MediaTypeNames;

namespace WebApplication1.Models.Infra
{
	public interface IFileValidator
	{
		void Validate(HttpPostedFileBase file);//若失敗，就傳回錯訊息
	}

	/// <summary>
	/// 若沒通過驗證就丟出例外
	/// 若沒上傳檔案就傳回空字串
	/// </summary>
	/// <param name="file"><param>
	/// <param name="path"><param>
	/// <param name="validators"><param>
	/// <returns></returns>
	public static class UploadFileHelper
	{
		public static string Save(HttpPostedFileBase file, string path, IFileValidator[] validators)
		{
			//驗證檔案
			if (validators != null)
			{
				foreach (var validator in validators)
				{
					validator.Validate(file);
				}
			}

			//如果沒有檔案就結束
			if (file == null || file.ContentLength == 0) return string.Empty;

			//取一個隨機檔名
			string ext = Path.GetExtension(file.FileName);
			string fileName = Path.GetRandomFileName() + ext;
			string fullpath = Path.Combine(path, fileName);
			file.SaveAs(fullpath);

			return fileName;

		}
	}
}