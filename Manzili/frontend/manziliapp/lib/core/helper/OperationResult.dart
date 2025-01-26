class OperationResult {
  final bool isSuccess; // لتحديد ما إذا كانت العملية ناجحة
  final String message; // الرسالة المصاحبة للنتيجة

  OperationResult({required this.isSuccess, required this.message});

  // حالة النجاح
  factory OperationResult.success(String message) {
    return OperationResult(isSuccess: true, message: message);
  }

  // حالة الفشل
  factory OperationResult.failure(String message) {
    return OperationResult(isSuccess: false, message: message);
  }
}
