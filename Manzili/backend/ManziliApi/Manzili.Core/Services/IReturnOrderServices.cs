using Manzili.Core.Dto.ReturnOrder;

public interface IReturnOrderServices
{
    Task<OperationResult<bool>> CreateReturnOrder(CreateReturnOrder createReturn);


    Task<OperationResult<IEnumerable<ReturnOrder>>> GetReturnOrder(int pageNumber, int size);
   
}