using Manzili.Core.Dto.UserDto;
using Manzili.Core.Entities;
using Mapster;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Manzili.Core.Mapper
{
    public static class UserMappingConfig
    {
        public static void Register()
        {
            TypeAdapterConfig<User, UserGetDto>
                .NewConfig();

            

        }
    }
}
