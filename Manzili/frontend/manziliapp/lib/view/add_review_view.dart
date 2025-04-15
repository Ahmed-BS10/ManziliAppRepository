import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class AddReviewView extends StatefulWidget {
  const AddReviewView({Key? key, required this.storeId, required this.userId})
      : super(key: key);

  final int storeId;
  final int userId;

  @override
  State<AddReviewView> createState() => _AddReviewViewState();
}

class _AddReviewViewState extends State<AddReviewView> {
  int _rating = 4; // Default rating
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios, color: Colors.black54, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'قيم المتجر من 5',
          style: TextStyle(
            color: Color(0xFF223263),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Rating instructions
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Text(
                'يرجى التقييم عن مستوى الرضا العام عن خدمة الشحن/التسليم او المنتجات الخاصة بنا',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFF223263),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 24),

            // Star rating
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$_rating/5',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF223263),
                  ),
                ),
                const SizedBox(width: 16),
                Row(
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _rating = index + 1;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(
                          index < _rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 45,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Comment input

            const Spacer(),

            // Submit button
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final url =
                      Uri.parse('http://man.runasp.net/api/StoreRating/Create');
                  final body = json.encode({
                    'userId': widget.userId,
                    'storeId': widget.storeId,
                    'valueRate': _rating,
                  });

                  try {
                    final response = await http.post(
                      url,
                      headers: {'Content-Type': 'application/json'},
                      body: body,
                    );

                    if (response.statusCode == 200) {
                      final responseData = json.decode(response.body);
                      if (responseData['isSuccess'] == true) {
                        Get.snackbar('نجاح', 'تم إرسال التقييم بنجاح');
                        Navigator.of(context).pop();
                      } else {
                        Get.snackbar('خطأ', responseData['message']);
                      }
                    } else {
                      Get.snackbar('خطأ', 'فشل في إرسال التقييم');
                    }
                  } catch (e) {
                    Get.snackbar('خطأ', 'حدث خطأ أثناء الإرسال');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1548C7),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'إرسال التقييم',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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
