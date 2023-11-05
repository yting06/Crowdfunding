using CrowdfundingWebsites.Models.EFModels;
using CrowdfundingWebsites.Models.Infra;
using CrowdfundingWebsites.Models.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using static System.Web.Razor.Parser.SyntaxConstants;

namespace CrowdfundingWebsites.Models.Repositories
{
    public class ManagerRepository
    {
        private readonly AppDBContext _db;

        public ManagerRepository()
        {
            _db = new AppDBContext();
        }

        public (IEnumerable<Manager> data, int total) GetAllByCondiction(SearchManagerVm vm)
        {
            string value = vm.SearchValue;
            var allData = !string.IsNullOrEmpty(value) ? _db.Managers.Where(x =>
                    x.Account.IndexOf(value) > -1 ||
                    x.Email.IndexOf(value) > -1 ||
                    x.FirstName.IndexOf(value) > -1 ||
                    x.LastName.IndexOf(value) > -1 ||
                    (x.Birthday != null && x.Birthday.ToString().IndexOf(value) > -1)
                ) : _db.Managers;


            var total = allData.Count();


            var data = vm.PageStart == 0 && vm.PageSize == 0 ? allData.OrderBy(e => e.Id).ToList()
                       : allData.OrderBy(e => e.Id)
                              .Skip(vm.PageStart)
                              .Take(vm.PageSize).ToList();

            return (data, total);
        }


        public Manager GetUserByEmailOrAccount(string account)
        {
            var manager = _db.Managers
                .Where(entity => string.Compare(entity.Account, account, true) == 0 || string.Compare(entity.Email, account, true) == 0)
                .FirstOrDefault();
            return manager;
        }

        public Manager GetUser(int id)
        {
            var manager = _db.Managers
                .Where(entity => entity.Id == id)
                .FirstOrDefault();
            return manager;
        }

        public void Update(ManagerVm o)
        {
            var manager = _db.Managers.FirstOrDefault(m => m.Id == o.Id);
            manager.UpdateTime = DateTime.Now;
            manager.FirstName = o.FirstName;
            manager.LastName = o.LastName;
            manager.Email = o.Email;
            manager.Birthday = o.Birthday;
            manager.ConfirmCode = o.ConfirmCode;

            _db.SaveChanges();
        }

        public void Update(ManagerProfileVm o)
        {
            var manager = _db.Managers.FirstOrDefault(m => m.Id == o.Id);
            manager.UpdateTime = DateTime.Now;
            manager.FirstName = o.FirstName;
            manager.LastName = o.LastName;
            manager.Email = o.Email;
            manager.Birthday = o.Birthday;

            _db.SaveChanges();
        }


        public void Update(Manager o)
        {
            var manager = _db.Managers.FirstOrDefault(m => m.Id == o.Id);
            manager.UpdateTime = DateTime.Now;
            manager.FirstName = o.FirstName;
            manager.LastName = o.LastName;
            manager.Email = o.Email;
            manager.Birthday = o.Birthday;
            manager.ConfirmCode = o.ConfirmCode;
            manager.Password = o.Password;

            _db.SaveChanges();
        }




        public void Delete(int id)
        {
            var item = _db.Managers.FirstOrDefault(m => m.Id == id);
            _db.Managers.Remove(item);
            _db.SaveChanges();
        }


        public void Register(Manager manager)
        {
            _db.Managers.Add(manager);
            _db.SaveChanges();
        }

        public void RegisterManagers(IEnumerable<Manager> managers)
        {
            List<string> fields = new List<string> { "Account", "Email" };
            var comparer = new PropertyComparer<Manager>(fields);
            var differentItems = managers.Except(_db.Managers, comparer);

            _db.Managers.AddRange(differentItems);
            _db.SaveChanges();
        }

        /// <summary>
        /// 透過帳號，取得 User 授權
        /// </summary>
        /// <param name="account"></param>
        /// <returns></returns>
        public string GetPermission(string account)
        {
            var manager = _db.ManagersAuths
                             .Where(m => string.Compare(m.Account, account) == 0)
                             .FirstOrDefault();

            var authJSON = manager?.Json;

            return authJSON;
        }

        public void ConfirmUser(int id, string confirmCode)
        {
            var user = _db.Managers
                .FirstOrDefault(m => m.Id == id && string.Compare(m.ConfirmCode, confirmCode, StringComparison.OrdinalIgnoreCase) == 0);

            if (user == null) return;
            user.Enabled = true;
            user.ConfirmCode = null;
            user.IsConfirmed = true;
            _db.SaveChanges();
        }

    }






}