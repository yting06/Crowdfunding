using CoraLibrary.Utilities;
using System.Collections.Generic;

namespace CrowdfundingWebsites.Models.Interface
{

    public interface IService<T>
    {
        T Get(int id);
        (IEnumerable<T>, int) GetAll(ISearchVm searchVm);

        ValidationResult Insert(IDataVm dataVm);
        ValidationResult Update(IDataVm dataVm);
        ValidationResult Delete(int id);

    }

}
