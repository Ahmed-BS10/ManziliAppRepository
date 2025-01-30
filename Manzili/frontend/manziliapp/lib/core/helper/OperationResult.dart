class ApiResponse {
  final bool isSuccess;
  final String message;
  final dynamic? data;

  ApiResponse({required this.isSuccess, required this.message, this.data});
}
