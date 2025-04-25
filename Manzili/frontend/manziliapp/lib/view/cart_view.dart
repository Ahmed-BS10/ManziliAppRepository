import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:manziliapp/view/checkout_view.dart';
import 'package:manziliapp/view/store_details_view.dart';
import 'package:manziliapp/widget/card/cart_card_widget.dart';
import 'package:flutter/material.dart';

class CartView extends StatefulWidget {
  const CartView({super.key, required this.cartCardModel});

  final CartCardModel cartCardModel;

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  String note = '';

  void _showNoteBottomSheet() {
    TextEditingController noteController = TextEditingController(text: note);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: noteController,
                decoration: InputDecoration(
                  hintText: 'اكتب ملاحظتك هنا...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                textInputAction: TextInputAction.done,
                onSubmitted: (value) {
                  setState(() => note = noteController.text.trim());
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() => note = noteController.text.trim());
                  Navigator.pop(context);
                },
                child: const Text('حفظ'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('السلة'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: widget.cartCardModel.getProductCard.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'lib/assets/image/parcel.png',
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 8),
                    const Text('السلة فارغة'),
                    const SizedBox(height: 16),
                    SafeArea(
                      child: SizedBox(
                        height: 51,
                        width: 298,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(
                                context,
                                StoreDetailsScreen(
                                    storeId: widget.cartCardModel.storeId));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff1548C7),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            'إستكشف التصنيفات',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.cartCardModel.getProductCard.length,
                      itemBuilder: (context, index) {
                        return CartCardWidget(
                          cartCardModel: widget.cartCardModel,
                          index: index,
                          onQuantityChanged: () {
                            setState(() {}); // إعادة بناء الواجهة
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'المجموع الكلي',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${_calculateTotalPrice()} ريال',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: _showNoteBottomSheet,
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 298,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xff1548C7), width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: note.isEmpty
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'اكتب ملاحظة',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  const SizedBox(width: 8),
                                  Image.asset(
                                    'lib/assets/image/Note_Edit.png',
                                    width: 15,
                                    height: 15,
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    note,
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SafeArea(
                    child: SizedBox(
                      height: 51,
                      width: 298,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckoutView(note: note),
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
                        child: const Text(
                          'الدفع',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  int _calculateTotalPrice() {
    return widget.cartCardModel.getProductCard.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }
}

class CartCardModel {
  final int cartId;
  final int userId;
  final int storeId;
  final String note;
  final List<GetProductCard> getProductCard;

  CartCardModel({
    required this.cartId,
    required this.userId,
    required this.storeId,
    required this.note,
    required this.getProductCard,
  });
}

class GetProductCard {
  final int productId;
  final String name;
  final String imageUrl;
  final int price;
  int quantity;

  GetProductCard({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });
}