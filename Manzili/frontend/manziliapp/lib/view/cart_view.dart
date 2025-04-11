import 'package:flutter/material.dart';

import 'package:manziliapp/view/checkout_view.dart';
import 'package:manziliapp/widget/card/cart_card_widget.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final int count = 10;
  String note = '';

  void _showNoteBottomSheet() {
    TextEditingController noteController = TextEditingController(text: note);

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
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
                  setState(() => note = value);
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 16),
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
        title: Text('السلة'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: count == 0
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/image/parcel.png',
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 8),
                    Text('السلة فارغة'),
                    const SizedBox(height: 16),
                    SafeArea(
                      child: SizedBox(
                        height: 51,
                        width: 298,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff1548C7),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Text(
                            'إستكشف التصنيفات',
                            style: const TextStyle(
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
                      itemCount: count,
                      itemBuilder: (context, index) {
                        return CartCardWidget();
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'المجموع الكلي',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$60.00',
                        style: TextStyle(
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
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Color(0xff1548C7), width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: note.isEmpty
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'اكتب ملاحظة',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  SizedBox(width: 8),
                                  Image.asset(
                                    'assets/image/Note_Edit.png',
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
                                    style: TextStyle(color: Colors.black),
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
                              builder: (context) => CheckoutView(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff1548C7),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Text(
                          'الدفع',
                          style: const TextStyle(
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
}
