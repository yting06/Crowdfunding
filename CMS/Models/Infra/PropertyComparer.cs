using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CrowdfundingWebsites.Models.Infra
{
    public class PropertyComparer<T> : IEqualityComparer<T>
    {
        private readonly IEnumerable<string> _fields;

        private readonly Type _type;

        public PropertyComparer(IEnumerable<string> fields)
        {
            _type = typeof(T);
            _fields = fields.Where(field => _type.GetProperty(field) != null).ToList();
        }

        public bool Equals(T x, T y)
        {
            return _fields.All(fieldName =>
            {
                var targetProp = _type.GetProperty(fieldName);
                return Object.Equals(targetProp?.GetValue(x), targetProp?.GetValue(y));
            });
        }

        public int GetHashCode(T obj)
        {
            int result = _fields.Select(field =>
            {
                var prop = _type.GetProperty(field);
                return prop.GetValue(obj).GetHashCode();
            }).Aggregate((x, y) => x ^ y);
            return result;
        }
    }

}