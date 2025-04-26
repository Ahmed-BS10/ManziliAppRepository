import 'package:flutter/material.dart';
import 'package:manziliapp/view/order_view.dart';
import 'package:manziliapp/widget/card/payment_receipt_widget.dart';
import 'package:manziliapp/widget/card/shipment_address_widget.dart';

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
  int deliveryCost = 10;
  String? selectedAddress; // Holds the address from ShipmentAddress
  String? uploadedPdfPath; // Holds the PDF path from PaymentReceipt

  @override
  void initState() {
    super.initState();
    debugPrint(
        'Cart Items: ${widget.cartItems}, totalPrice: ${widget.totalPrice}, note: ${widget.note}');
  }

  // Callback to receive the address from ShipmentAddress
  void _onAddressSelected(String address) {
    setState(() {
      selectedAddress = address;
    });
    debugPrint('Selected Address: $selectedAddress');
  }

  // Callback to receive the PDF path from PaymentReceipt
  void _onPdfUploaded(String pdfPath) {
    setState(() {
      uploadedPdfPath = pdfPath;
    });
    debugPrint('Uploaded PDF Path: $uploadedPdfPath');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'الدفع',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // UI Part 2: ShipmentAddress
              ShipmentAddress(
                onAddressSelected: _onAddressSelected, // Pass callback
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    'قم برفع إيصال الدفع',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // UI Part 3: PaymentReceipt
              PaymentReceipt(
                onPdfUploaded: _onPdfUploaded, // Pass callback
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'الإجمالي الفرعي',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    widget.totalPrice.toString(),
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'تكلفة التوصيل',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    widget.deliveryFee.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'الإجمالي الكلي',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '\$${widget.totalPrice + deliveryCost}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),
              SafeArea(
                child: SizedBox(
                  height: 51,
                  width: 298,
                  child: ElevatedButton(
                    onPressed: () {
                      // Ensure both address and PDF are provided
                      if (selectedAddress == null || uploadedPdfPath == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('يرجى تحديد العنوان ورفع إيصال الدفع'),
                          ),
                        );
                        return;
                      }

                      // Debugging: Print all order details
                      debugPrint('Order Details:');
                      debugPrint('User ID: ${widget.userid}');
                      debugPrint('Store ID: ${widget.storeId}');
                      debugPrint(
                          'Total Price: ${widget.totalPrice + deliveryCost}');
                      debugPrint('Note: ${widget.note}');
                      debugPrint('Cart Items: ${widget.cartItems}');
                      debugPrint('Address: $selectedAddress');
                      debugPrint('PDF Path: $uploadedPdfPath');

                      // Proceed to the next screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OrderView(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff1548C7),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'إتمام الطلب',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$${widget.totalPrice + deliveryCost}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
