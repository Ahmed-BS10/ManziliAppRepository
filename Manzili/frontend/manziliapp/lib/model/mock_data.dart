import 'order.dart';

class MockData {
  static List<Order> getNewOrders() {
    return [
      Order(
        id: '1001',
        customerName: 'أحمد محمد',
        customerAvatar: 'https://i.pravatar.cc/150?img=1',
        status: OrderStatus.new_order,
        date: DateTime.now().subtract(const Duration(hours: 1)),
        notes: 'يرجى التوصيل بسرعة، شكراً',
        items: [
          OrderItem(name: 'منتج أول', price: 24.00, quantity: 1),
          OrderItem(name: 'منتج ثاني', price: 35.00, quantity: 2),
          OrderItem(name: 'منتج ثالث', price: 42.50, quantity: 1),
          OrderItem(name: 'منتج رابع', price: 18.75, quantity: 3),
        ],
      ),
      Order(
        id: '1002',
        customerName: 'سارة أحمد',
        customerAvatar: 'https://i.pravatar.cc/150?img=5',
        status: OrderStatus.new_order,
        date: DateTime.now().subtract(const Duration(hours: 2)),
        notes: 'الرجاء الاتصال قبل التوصيل',
        items: [
          OrderItem(name: 'منتج أول', price: 24.00, quantity: 2),
          OrderItem(name: 'منتج ثاني', price: 35.00, quantity: 1),
          OrderItem(name: 'منتج ثالث', price: 42.50, quantity: 3),
        ],
      ),
    ];
  }

  static List<Order> getCurrentOrders() {
    return [
      Order(
        id: '1003',
        customerName: 'محمد علي',
        customerAvatar: 'https://i.pravatar.cc/150?img=3',
        status: OrderStatus.in_progress,
        date: DateTime.now().subtract(const Duration(hours: 5)),
        notes: 'يرجى التوصيل في المساء',
        items: [
          OrderItem(name: 'منتج أول', price: 24.00, quantity: 1),
          OrderItem(name: 'منتج ثاني', price: 35.00, quantity: 2),
          OrderItem(name: 'منتج ثالث', price: 42.50, quantity: 1),
        ],
      ),
      Order(
        id: '1004',
        customerName: 'فاطمة محمد',
        customerAvatar: 'https://i.pravatar.cc/150?img=9',
        status: OrderStatus.in_progress,
        date: DateTime.now().subtract(const Duration(hours: 8)),
        notes: 'لا توجد ملاحظات',
        items: [
          OrderItem(name: 'منتج أول', price: 24.00, quantity: 3),
          OrderItem(name: 'منتج ثاني', price: 35.00, quantity: 1),
        ],
      ),
      Order(
        id: '1005',
        customerName: 'خالد أحمد',
        customerAvatar: 'https://i.pravatar.cc/150?img=7',
        status: OrderStatus.in_progress,
        date: DateTime.now().subtract(const Duration(hours: 10)),
        notes: 'يرجى إرسال إيصال',
        items: [
          OrderItem(name: 'منتج أول', price: 24.00, quantity: 2),
          OrderItem(name: 'منتج ثاني', price: 35.00, quantity: 1),
          OrderItem(name: 'منتج ثالث', price: 42.50, quantity: 2),
          OrderItem(name: 'منتج رابع', price: 18.75, quantity: 1),
        ],
      ),
    ];
  }

  static List<Order> getPreviousOrders() {
    return [
      Order(
        id: '1006',
        customerName: 'نورا سعيد',
        customerAvatar: 'https://i.pravatar.cc/150?img=6',
        status: OrderStatus.completed,
        date: DateTime.now().subtract(const Duration(days: 2)),
        notes: 'تم التسليم بنجاح',
        items: [
          OrderItem(name: 'منتج أول', price: 24.00, quantity: 1),
          OrderItem(name: 'منتج ثاني', price: 35.00, quantity: 2),
        ],
      ),
      Order(
        id: '1007',
        customerName: 'عمر خالد',
        customerAvatar: 'https://i.pravatar.cc/150?img=4',
        status: OrderStatus.cancelled,
        date: DateTime.now().subtract(const Duration(days: 3)),
        notes: 'تم الإلغاء بناءً على طلب العميل',
        items: [
          OrderItem(name: 'منتج أول', price: 24.00, quantity: 2),
          OrderItem(name: 'منتج ثاني', price: 35.00, quantity: 1),
          OrderItem(name: 'منتج ثالث', price: 42.50, quantity: 1),
        ],
      ),
    ];
  }
}
