using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Web;
using CoraLibrary.Models;
using CoraLibrary.Utilities;
using OfficeOpenXml;
using WebGrease.Css.Extensions;

namespace CrowdfundingWebsites.Models.Infra
{
    // OfficeOpenXml; 使用 EPPlus 库来处理 Excel 文件
    public class ExcelHelper
    {
        private readonly string sheetName;

        public ExcelHelper(string sheetName = "Data")
        {
            this.sheetName = sheetName;
        }

        public List<T> ProcessSingleSheetFile<T>(HttpPostedFile file)
        {
            using (var package = new ExcelPackage(file.InputStream))
            {
                var worksheet = package.Workbook.Worksheets
                                       .FirstOrDefault(sheet => sheet.Name == sheetName);

                if (worksheet == null) throw new Exception("沒有資料");

                Dictionary<int, string> propDict = new Dictionary<int, string>();
                List<T> result = new List<T>();

                for (int row = 1; row <= worksheet.Dimension.Rows; row++)
                {
                    List<object> list = new List<object>();
                    for (int col = 1; col <= worksheet.Dimension.Columns; col++)
                    {
                        var cellValue = worksheet.Cells[row, col].Value;
                        if (row > 1) list.Add(cellValue);
                        else propDict.Add(col - 1, cellValue.ToString());
                    }
                    if (row == 1) continue;
                    var item = SetClass<T>(propDict, list);
                    result.Add(item);
                }
                return result;
            }
        }

        private T SetClass<T>(Dictionary<int, string> propDict, List<object> values)
        {
            var targetObject = Activator.CreateInstance(typeof(T));
            Type sourceType = typeof(T);

            foreach (var pair in propDict)
            {
                PropertyInfo targetProp = sourceType.GetProperty(pair.Value);
                if (targetProp == null) continue;
                var type = targetProp.PropertyType;
                var value = values[pair.Key];
                if (type.IsGenericType && type.GetGenericTypeDefinition() == typeof(Nullable<>))
                {
                    type = Nullable.GetUnderlyingType(targetProp.PropertyType);
                }
                var valueToSet = Convert.ChangeType(value, type);
                targetProp.SetValue(targetObject, valueToSet);
            }
            return (T)targetObject;
        }



    }

    public static class FileExt
    {
        public static bool IsExcelFileName(this string fileName)
        {
            var index = fileName.LastIndexOf('.') + 1;
            string fileType = fileName.ToLower().Substring(index);

            return fileType == "xlsx";
        }
    }

}