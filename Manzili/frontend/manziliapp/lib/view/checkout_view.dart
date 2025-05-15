import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:manziliapp/view/order_placed_view.dart';
import 'package:manziliapp/widget/card/payment_receipt_widget.dart';
import 'package:manziliapp/widget/card/shipment_address_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({
    super.key,
    required this.userid,
    required this.storeId,
    required this.totalPrice,
    required this.note,
    required this.cartItems,
    required this.deliveryFee,
  });

  final int deliveryFee;
  final int userid;
  final int storeId;
  final int totalPrice;
  final String? note;
  final List<Map<String, dynamic>> cartItems;

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  String? selectedAddress = 'rcrc7rcr5';
  String? uploadedPdfPath;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    debugPrint(
        'Cart Items: ${widget.cartItems}, totalPrice: ${widget.totalPrice}, note: ${widget.note}');
  }

  void _onAddressSelected(String address) {
    setState(() => selectedAddress = address);
    debugPrint('Selected Address: $selectedAddress');
  }

  void _onPdfUploaded(String pdfPath) {
    setState(() => uploadedPdfPath = pdfPath);
    debugPrint('Uploaded PDF Path: $uploadedPdfPath');
  }

  Future<void> _submitOrder() async {
    if (selectedAddress == null || uploadedPdfPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى تحديد العنوان ورفع إيصال الدفع')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final uri = Uri.parse('http://man.runasp.net/api/Orders/AddOrder');
      final request = http.MultipartRequest('POST', uri);

      // 1. الحقول البسيطة
      request.fields['UserId'] = widget.userid.toString();
      request.fields['StoreId'] = widget.storeId.toString();
      request.fields['DeliveryAddress'] = selectedAddress!;
      request.fields['Note'] = widget.note ?? '';

      // 2. العناصر المفهرسة من OrderProducts
      for (var i = 0; i < widget.cartItems.length; i++) {
        final item = widget.cartItems[i];
        final productId = item['id'] ?? item['productId'];
        request.fields['OrderProducts[$i].ProductId'] = productId.toString();
        request.fields['OrderProducts[$i].Quantity'] =
            item['quantity'].toString();
      }

      // 3. إضافة ملف PDF
      request.files.add(
        await http.MultipartFile.fromPath(
          'PdfFile',
          uploadedPdfPath!,
          contentType: MediaType('application', 'pdf'),
        ),
      );

      // 4. إرسال الطلب والحصول على Response عادي
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('HTTP ${response.statusCode} — Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['isSuccess'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم إرسال الطلب بنجاح')),
          );

          // Clear all product states
          await _clearAllProductStates();

          // Call API to delete the cart
          await _deleteCart();

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => OrderPlacedView()),
            (route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message'] ?? 'حدث خطأ أثناء إرسال الطلب'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'فشل الاتصال بالخادم (كود: ${response.statusCode})',
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error submitting order: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدث خطأ أثناء إرسال الطلب')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _deleteCart() async {
    final uri = Uri.parse(
        'http://man.runasp.net/api/Cart/DeleteCartByUserIdAndStoreId?storeId=${widget.storeId}&userId=${widget.userid}');
    try {
      final response = await http.delete(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['isSuccess'] == true) {
          debugPrint('Cart deleted successfully.');
        } else {
          debugPrint('Failed to delete cart: ${data['message']}');
        }
      } else {
        debugPrint('Failed to delete cart. HTTP ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error deleting cart: $e');
    }
  }

  Future<void> _clearAllProductStates() async {
    for (var item in widget.cartItems) {
      final productId = item['id'] ?? item['productId'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('isInCart_$productId');
      await prefs.remove('quantity_$productId');
      await prefs.remove('price_$productId');
    }
    debugPrint('All product states cleared.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('الدفع', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ShipmentAddress(onAddressSelected: _onAddressSelected),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('قم برفع إيصال الدفع',
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
              ),
              const SizedBox(height: 10),
              PaymentReceipt(onPdfUploaded: _onPdfUploaded),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('الإجمالي الفرعي',
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                  Text(widget.totalPrice.toString(),
                      style: const TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('تكلفة التوصيل',
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                  Text(widget.deliveryFee.toString(),
                      style: const TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('الإجمالي الكلي',
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                  Text('\$${widget.totalPrice + widget.deliveryFee}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 60),
              SafeArea(
                child: SizedBox(
                  height: 51,
                  width: 298,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _submitOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff1548C7),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('إتمام الطلب',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                  '\$${widget.totalPrice + widget.deliveryFee}',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
