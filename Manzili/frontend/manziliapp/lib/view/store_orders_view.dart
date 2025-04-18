import 'package:flutter/material.dart';
import '../model/order.dart';
import '../model/mock_data.dart';
import '../widget/store_order/order_card.dart';

class StoreOrdersView extends StatefulWidget {
  const StoreOrdersView({Key? key}) : super(key: key);

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
                  _buildOrderList(MockData.getPreviousOrders()),
                  _buildOrderList(MockData.getCurrentOrders()),
                  _buildOrderList(MockData.getNewOrders()),
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
          onAccept: () {
            // Handle accept action
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('تم قبول الطلب ${orders[index].id}')),
            );
          },
          onCancel: () {
            // Handle cancel action
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('تم إلغاء الطلب ${orders[index].id}')),
            );
          },
          onDetails: () {
            // Handle show details action
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
          onContactCustomer: () {
            // Handle contact customer action
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('التواصل مع العميل للطلب ${orders[index].id}'),
              ),
            );
          },
        );
      },
    );
  }
}
