using CoraLibrary.SqlDataLayer;
using CrowdfundingWebsites.Models.DTO;
using CrowdfundingWebsites.Models.EFModels;
using CrowdfundingWebsites.Models.ViewModels;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Metadata.Edm;
using System.Linq;
using System.Web;

namespace CrowdfundingWebsites.Models.Repositories
{
    public class OrderRepository
    {
        private readonly string _cnnKey = "AppDBContext";
        static OrderRepository()
        {
            //_orders = new List<OrderRecordVm>
            //{
            //    new OrderRecordVm
            //    {
            //        Id = 1,
            //        No = "20220918001",
            //        ProjectName="2023 植物日歷",
            //        Total=300,
            //        Payment="信用卡付款",
            //        PaymentIStatus="付款成功",
            //        OrderTime = new DateTime(2022, 09, 18, 9, 23, 2),
            //        Items = new List<OrderItemRecordVm>
            //        {
            //            new OrderItemRecordVm
            //            {
            //                Id = 1,
            //                ProductDetail = "植物日曆1本",
            //                Price = 300,
            //                Qty = 1,
            //                RecipientName="Allen Kuo",
            //                RecipientPhoneNumber="0960072498",
            //                RecipientPostalCode="338",
            //                RecipientAddress="桃園市蘆竹區南工路28號"
            //            },
            //        },
            //    },
            //};
        }

        public List<OrderRecordDTO> GetAll(int userId)
        {
            string sql = @"
SELECT
O.*, C.*, C2.*, Oi.Id, Oi.Qty, Ps.* , P.*, R.*
FROM Orders O
INNER JOIN Categories C ON C.Id = O.PaymentId 
INNER JOIN Categories C2 ON C2.Id = O.PaymentIStatusId
INNER JOIN Recipients R ON R.Id = O.RecipientId
INNER JOIN OrderItems Oi ON Oi.OrderId = O.Id 
INNER JOIN Products Ps ON Ps.Id = Oi.ProductId
INNER JOIN Projects P ON P.Id = Ps.ProjectId
WHERE O.MemberId = @MemberId
ORDER BY O.OrderTime desc
";
            Dictionary<int, OrderRecordDTO> dict = new Dictionary<int, OrderRecordDTO>();

            using (var cnn = new SqlDb().GetSqlConnection(_cnnKey))
            {
                cnn.Query<Order, Category, Category, OrderItemRecordDTO, Product, Project, RecipientDTO, OrderRecordDTO>(sql, (o, c, c2, oi, ps, p, r) =>
                {
                    if (!dict.ContainsKey(o.Id))
                    {
                        var newItem = AutoMapperHelper.MapperObj.Map<OrderRecordDTO>(o);
                        newItem.Payment = c;
                        newItem.PaymentStatus = c2;
                        newItem.Project = p;
                        newItem.Recipient = r;
                        newItem.Items = new List<OrderItemRecordDTO>();
                        dict.Add(o.Id, newItem);
                    }
                    var value = dict[o.Id];
                    oi.Product = ps;
                    value.Items.Add(oi);
                    dict[o.Id] = value;

                    return value;
                }, new { MemberId = userId}).ToList();
                return dict.Values.ToList();
            }





        }
    }
}