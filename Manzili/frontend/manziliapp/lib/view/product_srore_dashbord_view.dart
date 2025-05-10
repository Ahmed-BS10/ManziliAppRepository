
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProductSroreDashbordView extends StatefulWidget {
  @override
  _ProductSroreDashbordViewState createState() => _ProductSroreDashbordViewState();
}

class _ProductSroreDashbordViewState extends State<ProductSroreDashbordView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> tabs = ['الكل', 'ماكولات', 'حلويات', 'مشروبات'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Icon(Icons.arrow_back, color: Colors.black),
          title: Text(
            'منتجاتي',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Container(
              child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.blue,
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.black,
                tabs: tabs.map((e) => Tab(text: e)).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('مجموع المنتجات: ٣', style: TextStyle(fontSize: 14)),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                    child: Text('إضافة منتج'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return ProductItem();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: EdgeInsets.all(8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            'https://cdn.pixabay.com/photo/2014/10/23/18/05/burger-500054_1280.jpg',
            width: 70,
            height: 70,
            fit: BoxFit.cover,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('برجر لحم', style: TextStyle(fontWeight: FontWeight.bold)),
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'edit') {
                  // Edit action
                } else if (value == 'delete') {
                  // Delete action
                }
              },
              itemBuilder:
                  (context) => [
                    PopupMenuItem(value: 'edit', child: Text('تعديل المنتج')),
                    PopupMenuItem(value: 'delete', child: Text('حذف المنتج')),
                  ],
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ريال 2000', style: TextStyle(color: Colors.blue)),
            Row(
              children: [
                Text('ماكولات', style: TextStyle(fontSize: 12)),
                SizedBox(width: 8),
                Row(
                  children: [
                    Icon(Icons.star, size: 16, color: Colors.blue),
                    Text('4.9', style: TextStyle(fontSize: 12)),
                    SizedBox(width: 4),
                    Text('(10 مراجعات)', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
