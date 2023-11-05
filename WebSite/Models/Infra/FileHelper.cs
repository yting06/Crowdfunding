using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Text.RegularExpressions;
using System.Web;

namespace CrowdfundingWebsites.Models.Infra
{
    public class FileHelper
    {
        private readonly string defaultPath;

        public FileHelper(string path = "")
        {
            defaultPath = string.IsNullOrEmpty(path) ? HttpContext.Current.Server.MapPath("~/App_Data") : path;
        }

        public IEnumerable<FileInfoVm> GetFolderFiles(string fileType = ".txt")
        {
            try
            {
                if (Directory.Exists(defaultPath))
                {
                    string[] files = Directory.GetFiles(defaultPath);
                    return files.Select(f => new FileInfoVm(new FileInfo(f)))
                                .Where(vm => vm.FileName.EndsWith(fileType))
                                .OrderByDescending(vm => vm.CreateTime)
                                .ToList();
                }
                else throw new Exception("指定的文件夹不存在.");
            }
            catch (Exception ex)
            {
                throw new Exception($"發生異常：{ex.Message}");
            }
        }

        public void SaveFile(string fileName, string content, string path = null)
        {
            string filePath = GetFullFilePath(fileName, path ?? defaultPath);
            try
            {
                File.WriteAllText(filePath, content);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public string GetFileData(string fileName, string path = "")
        {
            string root = string.IsNullOrEmpty(path) ? defaultPath : path;
            if (!Exists(fileName, root)) return null;

            try
            {
                string filePath = GetFullFilePath(fileName, root);
                return File.ReadAllText(filePath);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }



        public bool Exists(string fileName, string path = null)
        {
            string filePath = GetFullFilePath(fileName, path ?? defaultPath);
            return File.Exists(filePath);
        }


        private string GetFullFilePath(string fileName, string path)
        {
            path = Path.GetFullPath(path);
            return Path.Combine(path, fileName);
        }


    }


    public class FileInfoVm
    {
        public string Subject
        {
            get
            {
                return TryParseSubject(_info?.Name);
            }
        }
        public string FileName
        {
            get
            {
                return _info?.Name;
            }
        }
        public string CreateTime
        {
            get
            {
                return _info?.CreationTime.ToString("yyyy-MM-dd HH:mm:ss");
            }
        }

        private readonly FileInfo _info;

        public FileInfoVm(FileInfo info)
        {
            _info = info;
        }

        private string TryParseSubject(string fileName)
        {
            Match match = Regex.Match(fileName, @"\[([^\]]+)\]");
            return match.Success ? match.Groups[1].Value : "";
        }
    }

    public class EmailContext
    {
        public readonly string Subject;

        public readonly string From;

        public readonly string To;

        public readonly string Content;

        public EmailContext(string data)
        {
            To = TryParse(data, @"to:(.*?)\r\n");
            From = TryParse(data, @"from:(.*?)\r\n");
            Subject = TryParse(data, @"subject:(.*?)\r\n");
            Content = data.Substring(data.IndexOf(Subject) + Subject.Length );
        }

        private string TryParse(string data, string pattern)
        {
            Match match = Regex.Match(data, pattern);
            return match.Success ? match.Groups[1].Value : "";
        }
    }


}