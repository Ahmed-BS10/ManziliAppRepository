using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Manzili.Core.Mapper
{
    public static class MapsterConfig
    {
        public static void RegisterMappings()
        {
            UserMappingConfig.Register();
        }
    }
}
