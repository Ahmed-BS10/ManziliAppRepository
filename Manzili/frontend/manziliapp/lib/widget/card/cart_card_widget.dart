import 'package:flutter/material.dart';
import 'package:manziliapp/widget/card/quantity_selector_widget.dart';

class CartCardWidget extends StatelessWidget {
  const CartCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: AspectRatio(
              aspectRatio: 117 / 85,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Image.asset(
                  'assets/image/burger.jpg',
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'برجر لحم',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'delete') {
                          print('Delete tapped');
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'delete',
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            child: Text(
                              'حذف من السلة',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                      icon: Icon(Icons.more_vert),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    QuantitySelectorWidget(),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        '51.00\$',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
