import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manziliapp/controller/cart_controller2.dart';
import 'package:manziliapp/view/checkout_view.dart';
import 'package:manziliapp/view/store_details_view.dart';
import 'package:manziliapp/widget/card/cart_card_widget.dart';


class CartView extends StatefulWidget {
  const CartView({super.key, required this.cartCardModel});

  final CartCardModel cartCardModel;

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final CartController2 _cartController = Get.put(CartController2());
  late final int _cartId;
  String note = '';

  @override
  void initState() {
    super.initState();
    _cartId = widget.cartCardModel.cartId;
    _initializeCart();
  }

  Future<void> _initializeCart() async {
    await _cartController.loadTotalPrice(
      _cartId,
      widget.cartCardModel.getProductCard,
    );
    _cartController.calculateTotalPrice(
      _cartId,
      widget.cartCardModel.getProductCard,
    );
  }

  void _showNoteBottomSheet() {
    final noteController = TextEditingController(text: note);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
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
              onSubmitted: (value) => _saveNote(noteController),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _saveNote(noteController),
              child: const Text('حفظ'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveNote(TextEditingController controller) {
    setState(() => note = controller.text.trim());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(title: const Text('السلة')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: widget.cartCardModel.getProductCard.isEmpty
            ? _buildEmptyCart()
            : _buildCartWithItems(),
      ),
    );
  }

  Widget _buildEmptyCart() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cartController.calculateTotalPrice(_cartId, []);
    });
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('lib/assets/image/parcel.png', width: 100, height: 100),
          const SizedBox(height: 8),
          const Text('السلة فارغة'),
          const SizedBox(height: 16),
          _buildExploreButton(),
        ],
      ),
    );
  }

  Widget _buildCartWithItems() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: widget.cartCardModel.getProductCard.length,
            itemBuilder: (context, index) => CartCardWidget(
              cartCardModel: widget.cartCardModel,
              index: index,
              onQuantityChanged: () => _cartController.calculateTotalPrice(
                _cartId,
                widget.cartCardModel.getProductCard,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildTotalPriceSection(),
        const SizedBox(height: 16),
        _buildNoteSection(),
        const SizedBox(height: 16),
        _buildCheckoutButton(),
      ],
    );
  }

  Widget _buildTotalPriceSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'المجموع الكلي',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Obx(() => Text(
              '${_cartController.getTotalPrice(_cartId)} ريال',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            )),
      ],
    );
  }

  Widget _buildNoteSection() {
    return InkWell(
      onTap: _showNoteBottomSheet,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 298,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xff1548C7), width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: note.isEmpty
            ? _buildNotePlaceholder()
            : Text(
                note,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.black),
              ),
      ),
    );
  }

  Widget _buildNotePlaceholder() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('اكتب ملاحظة', style: TextStyle(color: Colors.black)),
        SizedBox(width: 8),
        ImageIcon(
          AssetImage('lib/assets/image/Note_Edit.png'),
          size: 15,
          color: Colors.black,
        ),
      ],
    );
  }

  Widget _buildExploreButton() {
    return SafeArea(
      child: SizedBox(
        height: 51,
        width: 298,
        child: ElevatedButton(
          onPressed: () => Navigator.pop(
            context,
            StoreDetailsScreen(storeId: widget.cartCardModel.storeId),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff1548C7),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: const Text(
            'إستكشف التصنيفات',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckoutButton() {
    return SafeArea(
      child: SizedBox(
        height: 51,
        width: 298,
        child: ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CheckoutView(note: note),
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff1548C7),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: const Text(
            'الدفع',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////
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
