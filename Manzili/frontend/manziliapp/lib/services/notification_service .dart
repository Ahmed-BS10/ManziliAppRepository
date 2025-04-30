import 'package:signalr_core/signalr_core.dart';

class NotificationService {
  late HubConnection _hubConnection;

  Future<void> init(int storeId) async {
    _hubConnection = HubConnectionBuilder()
        .withUrl('http://man.runasp.net/hubs/notifications')
        .build();

    // 1. استمع لحدث ReceiveNotification بدون cast
    _hubConnection.on('ReceiveNotification', (args) {
      _handleNotification(args as List<Object>?);
    });

    // 2. ابدأ الاتصال
    await _hubConnection.start();

    // 3. انضم إلى مجموعة المتجر
    await _hubConnection
        .invoke('JoinGroup', args: <Object>[storeId.toString()]);
  }

  // دالة المعالجة (يمكنها أن تبقى Future إذا أردت تنفيذ عمليات async بداخلها)
  Future<void> _handleNotification(List<Object>? args) async {
    if (args == null || args.isEmpty) return;
    // في بعض الأحيان يكون payload من نوع LinkedHashMap؛ لذا نستخدم Map<String, dynamic>
    final payload = Map<String, dynamic>.from(args[0] as Map);
    print('New notification: ${payload['Type']} - ${payload['Payload']}');

    // مثال: عرض إشعار محلي أو تحديث واجهة المستخدم:
    // await showLocalNotification(payload['Type'], payload['Payload']);
  }

  // عند الخروج من الشاشة أو إغلاق التطبيق
  Future<void> dispose() async {
    await _hubConnection.stop();
  }
}
