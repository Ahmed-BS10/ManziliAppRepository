public class OperationResult
{
    public bool IsSuccess { get; set; }
    public string Message { get; set; }

    public static OperationResult Success(string message) => new OperationResult { IsSuccess = true, Message = message };
    public static OperationResult Failure(string message) => new OperationResult { IsSuccess = false, Message = message };
}
