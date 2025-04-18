import 'package:flutter/material.dart';
import 'package:manziliapp/CustomerViews/view/home_view.dart';
import 'package:manziliapp/CustomerViews/view/order_detalis_view.dart';

// Order Model
class Order {
  final String id;
  final String storeName;
  final String orderDate;
  final bool isDelivered;
  final int productCount;
  final double price;

  Order({
    required this.id,
    required this.storeName,
    required this.orderDate,
    required this.isDelivered,
    required this.productCount,
    required this.price,
  });
}

// Orders Controller
class OrdersController {
  // Sample data for delivered orders
  List<Order> getDeliveredOrders() {
    return [
      Order(
        id: 'SDG1525KJD',
        storeName: 'متجر لولي',
        orderDate: '1 مارس 2025',
        isDelivered: true,
        productCount: 5,
        price: 500.43,
      ),
      Order(
        id: 'SDG5679KJD',
        storeName: 'متجر لولي',
        orderDate: '1 مارس 2025',
        isDelivered: true,
        productCount: 4,
        price: 250.00,
      ),
    ];
  }

  // Sample data for in-progress orders
  List<Order> getInProgressOrders() {
    return [
      Order(
        id: 'SDG1345KJD',
        storeName: 'متجر لولي',
        orderDate: '1 مارس 2025',
        isDelivered: false,
        productCount: 2,
        price: 299.43,
      ),
      Order(
        id: 'SDG1345KJD',
        storeName: 'متجر لولي',
        orderDate: '1 مارس 2025',
        isDelivered: false,
        productCount: 2,
        price: 299.43,
      ),
    ];
  }
}

// Reusable Text Row Widget
class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  const InfoRow({
    Key? key,
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: valueColor ?? Colors.black,
          ),
        ),
      ],
    );
  }
}

// Main Widget Code (Refactored)
class OrdersView extends StatefulWidget {
  const OrdersView({Key? key}) : super(key: key);

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  final OrdersController _controller = OrdersController();
  bool _showDelivered = true;

  @override
  Widget build(BuildContext context) {
    final orders = _showDelivered
        ? _controller.getDeliveredOrders()
        : _controller.getInProgressOrders();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'الطلبات',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 30),
              _buildTabToggle(),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    return OrderCard(order: orders[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTab('تم توصيلها', _showDelivered, () {
            setState(() => _showDelivered = true);
          }),
          _buildTab('قيد المعالجة', !_showDelivered, () {
            setState(() => _showDelivered = false);
          }),
        ],
      ),
    );
  }

  Widget _buildTab(String title, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.horizontal(
            right:
                title == 'تم توصيلها' ? const Radius.circular(20) : Radius.zero,
            left: title == 'قيد المعالجة'
                ? const Radius.circular(20)
                : Radius.zero,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const OrderDetailsView()),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoRow(label: ' رقم الطلب', value: order.id, isBold: true),
            const SizedBox(height: 4),
            Text(
              'تم الطلب من متجر ${order.storeName}: ${order.orderDate}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const Divider(height: 24),
            _buildStatusRow(order),
            const SizedBox(height: 8),
            InfoRow(
              label: ' المنتجات',
              value: 'تم شراء ${order.productCount} منتج',
            ),
            const SizedBox(height: 8),
            InfoRow(
              label: ' السعر',
              value: '\$${order.price.toStringAsFixed(2)}',
              isBold: true,
              valueColor: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(Order order) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          ' حالة الطلب',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        Row(
          children: [
            order.isDelivered
                ? const Icon(Icons.check_circle, color: Colors.green, size: 20)
                : const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                    ),
                  ),
            const SizedBox(width: 8),
            Text(
              order.isDelivered ? 'تم التوصيل' : 'جاري التحضير',
              style: TextStyle(
                fontSize: 14,
                color: order.isDelivered ? Colors.green : Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// class OrderDetailsScreen extends StatelessWidget {
//   const OrderDetailsScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('تفاصيل الطلب')),
//       body: const Center(child: Text('تفاصيل الطلب هنا')),
//     );
//   }
// }
