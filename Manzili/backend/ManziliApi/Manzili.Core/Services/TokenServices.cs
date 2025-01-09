using Manzili.Core.Entities;
using Manzili.Core.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Manzili.Core.Services
{
    public class TokenServices
    {
        #region Field
        private readonly IRepository<User> _userRepo;
        #endregion


        #region Constructor
        public TokenServices(IRepository<User> userRepo)
        {
            _userRepo=userRepo;
        }
        #endregion


        #region Method


        #endregion  

    }
}
