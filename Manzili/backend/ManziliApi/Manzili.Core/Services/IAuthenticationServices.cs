using Manzili.Core.Dto.StoreDtp;
using Manzili.Core.Dto.UserDto;

namespace Manzili.Core.Services
{
    public interface IAuthenticationServices
    {
        Task<OperationResult<AuthModel>> Login(LoginUserDto userLogin);
        Task<OperationResult<string>> RegisterAsStore(CreateStoreDto storeCreate , List<int> categories);
        Task<OperationResult<string>> RegisterAsUser(CreateUserDto userCreate);
    }
}


public class AuthModel
{
    public int id { get; set; }
    public string token { get; set; }

}