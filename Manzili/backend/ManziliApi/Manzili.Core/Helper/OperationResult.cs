public class OperationResult<T>
{
    public bool IsSuccess { get; set; }
    public string Message { get; set; }
    public T Data { get; set; }

    public static OperationResult<T> Success(T data, string message = "Operation completed successfully.")
        => new OperationResult<T> { IsSuccess = true, Message = message, Data = data };

    public static OperationResult<T> Failure(string message)
        => new OperationResult<T> { IsSuccess = false, Message = message, Data = default };
}
