import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../model/order.dart';
import '../model/mock_data.dart';
import '../widget/store_order/order_card.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class StoreOrdersView extends StatefulWidget {
  const StoreOrdersView({super.key});

  @override
  State<StoreOrdersView> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<StoreOrdersView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Helper to delete order from API
  Future<bool> _deleteOrder(String orderId) async {
    final url = Uri.parse('http://man.runasp.net/api/Orders/$orderId');
    final response = await http.delete(url);
    return response.statusCode == 200;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('الطلبات')),
        body: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 0.5),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                padding: const EdgeInsets.all(6),
                tabs: const [
                  Tab(text: 'الطلبات الماضية'),
                  Tab(text: 'الطلبات الحالية'),
                  Tab(text: 'الطلبات الجديدة'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  FutureBuilder<List<Order>>(
                    future: MockData.getPreviousOrders(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('لا توجد بيانات'));
                      } else if (snapshot.hasData) {
                        return _buildOrderList(snapshot.data!);
                      } else {
                        return const Center(child: Text('لا توجد بيانات'));
                      }
                    },
                  ),
                  FutureBuilder<List<Order>>(
                    future: MockData.getCurrentOrders(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('لا توجد بيانات'));
                      } else if (snapshot.hasData) {
                        return _buildOrderList(snapshot.data!);
                      } else {
                        return const Center(child: Text('لا توجد بيانات'));
                      }
                    },
                  ),
                  FutureBuilder<List<Order>>(
                    future: MockData.getNewOrders(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child:Text('لا توجد بيانات'));
                      } else if (snapshot.hasData) {
                        return _buildOrderList(snapshot.data!);
                      } else {
                        return const Center(child: Text('لا توجد بيانات'));
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(List<Order> orders) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return OrderCard(
          order: orders[index],
          onAccept: () async {
            final orderId = orders[index].id;
            final url = Uri.parse('http://man.runasp.net/api/Orders/UpdateOrderStatus?orderId=$orderId&status=2');
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) => const Center(child: CircularProgressIndicator()),
            );
            try {
              final response = await http.put(url);
              Navigator.of(context).pop(); // remove loading dialog
              if (response.statusCode == 200) {
                final body = response.body;
                if (body.contains('"isSuccess": true')) {
                  setState(() {
                    orders.removeAt(index);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('تم تغيير حالة الطلب $orderId')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('فشل في تغيير حالة الطلب')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('فشل في تغيير حالة الطلب')),
                );
              }
            } catch (e) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('خطأ: $e')),
              );
            }
          },
          // acceptButtonLabel: 'تغيير حالة الطلب',
          onCancel: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('تأكيد الإلغاء'),
                content: const Text('هل أنت متأكد أنك تريد إلغاء هذا الطلب؟'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    child: const Text('لا'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(true),
                    child: const Text('نعم'),
                  ),
                ],
              ),
            );
            if (confirm != true) return;

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) => const Center(child: CircularProgressIndicator()),
            );
            final success = await _deleteOrder(orders[index].id);
            Navigator.of(context).pop(); // remove loading dialog
            if (success) {
              setState(() {
                orders.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تم إلغاء الطلب ${orders[index].id}')),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('فشل في إلغاء الطلب')),
              );
            }
          },
          onDetails: () {
            // Handle show details action
            if (orders[index] is Order) {
                  Get.toNamed('/sov', arguments: orders[index]);
                } else {
                  print('Invalid order object');
                }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('عرض تفاصيل الطلب ${orders[index].id}')),
            );
          },
          onProductDetails: () {
            // Handle product details action
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('عرض تفاصيل المنتج للطلب ${orders[index].id}'),
              ),
            );
          },
          onContactCustomer: () async {
            final String phone =  '+967${orders[index].customerPhone}';
            final whatsappUrl = Uri.parse('https://wa.me/$phone');
            if (await canLaunchUrl(whatsappUrl)) {
              await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('لا يمكن فتح واتساب لهذا الرقم: $phone'),
                ),
              );
            }
          },
        );
      },
    );
  }
}
