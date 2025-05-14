import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:manziliapp/view/add_product_screen.dart';

class ProductSroreDashbordView extends StatefulWidget {
  @override
  _ProductSroreDashbordViewState createState() =>
      _ProductSroreDashbordViewState();
}

class _ProductSroreDashbordViewState extends State<ProductSroreDashbordView>
    with SingleTickerProviderStateMixin {
  List<dynamic> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final url = 'http://man.runasp.net/api/Product/All?storeId=6';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['isSuccess']) {
          setState(() {
            products = data['data'];
          });
        }
      }
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  Future<void> deleteProduct(String productId) async {
    final url =
        'http://man.runasp.net/api/Product/DeleteProduct?productId=$productId';
    try {
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product deleted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete product')),
        );
      }
    } catch (e) {
      print('Error deleting product: $e');
    }
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('مجموع المنتجات: ${products.length}',
                        style: TextStyle(fontSize: 14)),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddProductScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                      ),
                      child: Text('إضافة منتج'),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductItem(
                    name: product['name'],
                    price: product['price'],
                    description: product['description'],
                    rate: product['rate'],
                    imageUrl: 'http://man.runasp.net${product['imageUrl']}',
                    productId: product['id'].toString(),
                    onDelete: () async {
                      await deleteProduct(product['id'].toString());
                      await fetchProducts(); // Refresh the product list after deletion
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductItem extends StatefulWidget {
  final String name;
  final int price;
  final String description;
  final int rate;
  final String imageUrl;
  final String productId;
  final VoidCallback onDelete;

  ProductItem({
    required this.name,
    required this.price,
    required this.description,
    required this.rate,
    required this.imageUrl,
    required this.productId,
    required this.onDelete,
  });

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: EdgeInsets.all(8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            widget.imageUrl,
            width: 70,
            height: 70,
            fit: BoxFit.fill,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.name, style: TextStyle(fontWeight: FontWeight.bold)),
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert),
              onSelected: (value) async {
                if (value == 'edit') {
                  // Edit action
                } else if (value == 'delete') {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('تأكيد الحذف'),
                      content: Text('هل أنت متأكد أنك تريد حذف المنتج؟'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          child: Text('إلغاء'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(true),
                          child: Text('حذف'),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true) {
                    widget.onDelete();
                  }
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(value: 'edit', child: Text('تعديل المنتج')),
                PopupMenuItem(value: 'delete', child: Text('حذف المنتج')),
              ],
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ريال ${widget.price}', style: TextStyle(color: Colors.blue)),
            GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Text(
                isExpanded
                    ? widget.description
                    : (widget.description.length > 50
                        ? '${widget.description.substring(0, 50)}...'
                        : widget.description),
                style: TextStyle(fontSize: 12),
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.star, size: 16, color: Colors.blue),
                Text('${widget.rate}', style: TextStyle(fontSize: 12)),
                SizedBox(width: 4),
                Text('(10 مراجعات)', style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
