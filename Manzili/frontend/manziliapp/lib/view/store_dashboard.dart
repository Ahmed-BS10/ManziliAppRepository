import 'package:flutter/material.dart';
import 'package:manziliapp/model/product_store.dart';
import 'package:manziliapp/widget/store_dashbord/analytics_card.dart';
import 'package:manziliapp/widget/store_dashbord/bottom_navigation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class StoreDashboard extends StatefulWidget {
  const StoreDashboard({super.key});

  @override
  State<StoreDashboard> createState() => _StoreDashboardState();
}

class _StoreDashboardState extends State<StoreDashboard> {
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();
  bool isFabVisible = false;
  bool isLoading = true; // Add a loading state
  final List<ProductStore> products = [
    ProductStore(
      id: '1',
      name: 'برجر لحم',
      price: 2000,
      rating: 4.6,
      imageUrl: 'assets/images/burger.jpg',
      isFavorite: true,
    ),
    
  ];

  String selectedMonth = 'مارس';
  final List<String> months = [
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
  ];

  final Map<String, int> monthlyProfits = {
    'يناير': 25000,
    'فبراير': 28000,
    'مارس': 30000,
    'أبريل': 32000,
    'مايو': 35000,
    'يونيو': 38000,
    'يوليو': 40000,
    'أغسطس': 42000,
    'سبتمبر': 45000,
    'أكتوبر': 48000,
    'نوفمبر': 50000,
    'ديسمبر': 55000,
  };

  int numberOfOrders = 0;
  int totalSales = 0;
  int orderInProgress = 0;

  List<Map<String, dynamic>> lastTwoOrders = []; // Store fetched orders

  @override
  void initState() {
    super.initState();
    _sheetController.addListener(_updateFabVisibility);
    _fetchAnalyticsData();
    _fetchLastTwoCompletedOrders(); // Fetch last two orders
  }

  Future<void> _fetchAnalyticsData() async {
    const String apiUrl = 'http://man.runasp.net/api/Store/GetAnalysisStore?storeId=2';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['isSuccess'] == true) {
          setState(() {
            numberOfOrders = data['data']['numberOfOrders'];
            totalSales = data['data']['totalSales'];
            orderInProgress = data['data']['orderInProgress'];
            isLoading = false; // Set loading to false after data is fetched
          });
        } else {
          print('Error: ${data['message']}');
        }
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> _fetchLastTwoCompletedOrders() async {
    const String apiUrl = 'http://man.runasp.net/api/Store/GetLastTwoCompletedOrders?storeId=2';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        setState(() {
          lastTwoOrders = data.map((order) {
            return {
              'buyerName': order['buyerName'],
              'price': order['price'],
              'date': order['date'],
            };
          }).toList();
        });
      } else {
        print('Failed to fetch orders. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }

  void _updateFabVisibility() {
    final size = _sheetController.size;
    setState(() {
      isFabVisible = size > 0.2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: isLoading
            ? Center(child: CircularProgressIndicator()) // Show loading indicator
            : Stack(
                children: [
                  // Main dashboard content
                  SafeArea(
                    child: Column(
                      children: [
                        _buildHeader(),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: 16),
                                _buildAnalyticsCards(numberOfOrders, totalSales, orderInProgress),
                                const SizedBox(height: 24),
                                _buildProfitSection(),
                                const SizedBox(height: 24),
                                _buildTransactionSection(),
                                const SizedBox(height: 100), // Extra space for the draggable sheet
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Simple draggable sheet for products
                  _buildProductsSheet(),
                  if (isFabVisible)
                    Positioned(
                      bottom: 50 + (100 * _sheetController.size),
                      right: 20,
                      child: SizedBox(
                        width: 65,
                        height: 65,
                        child: FloatingActionButton(
                          onPressed: () {},
                          backgroundColor: const Color(0xFF1548C7),
                          elevation: 8,
                          shape: const CircleBorder(),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 45,
                          ),
                        ),
                      ),
                    ),
                  // Bottom navigation
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: BottomNavigation(
                      currentIndex: 3,
                      onTap: (index) {
                        print('تم النقر على التبويب: $index');
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Notification bell (now on the left)
          Stack(
            children: [
              const Icon(
                Icons.notifications_outlined,
                size: 35, // تغيير الحجم هنا (القيمة الافتراضية 24)
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),

          // Date (now on the right, without dropdown icon)
          const Padding(
            padding: EdgeInsets.only(top: 12),
            child: Text(
              'WED, 6 MARCH',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCards(int numberOfOrders, int totalSales, int orderInProgress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'تحليلات المتجر',
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 120,
                child: AnalyticsCard(
                  title: 'إجمالي الطلبات',
                  value: numberOfOrders.toString(),
                  color: Color(0xFF1548C7),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 120,
                child: AnalyticsCard(
                  title: 'إجمالي الارباح',
                  value: totalSales.toString(),
                  color: Color(0xFF1548C7),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 120,
                child: AnalyticsCard(
                  title: 'منتجات قيد التحضير',
                  value: orderInProgress.toString(),
                  color: Color(0xFF1548C7),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfitSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'الأرباح',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
            Transform.translate(
              offset: const Offset(0, 45), // تحريك للأسفل بمقدار 10
              child: Text(
                totalSales.toString(),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'إجمالي الربح',
          style: TextStyle(
            fontSize: 20,
            color: Color(0xFFA8AAAB),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Month dropdown with arrow icon
              InkWell(
                onTap: () {
                  _showMonthPicker(context);
                },
                child: Row(
                  children: [
                    Text(
                      'الأرباح في $selectedMonth',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF1548C7),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 23,
                      color: Color(0xFF1548C7),
                    ),
                  ],
                ),
              ),

              // Monthly profit amount
              Text(
                '${monthlyProfits[selectedMonth]} ريال',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1548C7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showMonthPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'اختر الشهر',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: months.length,
                  itemBuilder: (context, index) {
                    final month = months[index];
                    return ListTile(
                      title: Text(month),
                      trailing: month == selectedMonth
                          ? const Icon(Icons.check, color: Color(0xFF1548C7))
                          : null,
                      onTap: () {
                        setState(() {
                          selectedMonth = month;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTransactionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'السجل',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        if (lastTwoOrders.isEmpty)
          const Text('لا توجد طلبات مكتملة.', style: TextStyle(fontSize: 18)),
        if (lastTwoOrders.isNotEmpty)
          ...lastTwoOrders.map((order) {
            final formattedDate = DateTime.parse(order['date']).toLocal().toString().split(' ')[0];
            return Column(
              children: [
                _buildTransactionItem(order['buyerName'], order['price'].toDouble(), formattedDate),
                const Divider(),
              ],
            );
          }),
      ],
    );
  }

  Widget _buildTransactionItem(String name, double amount, String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'تم الدفع من $name',
                style: const TextStyle(
                  color: Color(0xFF1548C7),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                date,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFA8AAAB),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Text(
            '${amount.toStringAsFixed(2)} ريال',
            style: const TextStyle(
              color: Color(0xFF000000),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsSheet() {
    return DraggableScrollableSheet(
      controller: _sheetController,
      initialChildSize: 0.2, // رفع البداية للأعلى
      minChildSize: 0.15,
      maxChildSize: 0.9,
      snap: true,
      snapSizes: const [0.4, 0.7, 0.9],
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: ListView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(top: 8), // تقليل التباعد العلوية
            children: [
              Column(
                children: [
                  // أيقونة السحب
                  Container(
                    margin: const EdgeInsets.only(
                        top: 4, bottom: 8), // تقليل المسافة العلوية
                    width: 60,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),

                  // العنوان وعدد المنتجات
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'منتجاتي',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${products.length} منتجات',
                          style: TextStyle(
                            fontSize: 22, // تقليل الحجم قليلاً
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8), // تقليل المسافة قبل عرض المنتجات

                  // عرض المنتجات
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return _buildProductCard(product);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProductCard(ProductStore product) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Product image
            Image.asset(
              product.imageUrl,
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),

            // Gradient overlay for better text visibility
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.7),
                    ],
                    stops: const [0.0, 0.6, 0.8, 1.0],
                  ),
                ),
              ),
            ),

            // Product name
            Positioned(
              bottom: 40,
              right: 12,
              child: Text(
                product.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),

            // Rating and price
            Positioned(
              bottom: 8,
              left: 12,
              right: 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Rating
                  Row(
                    crossAxisAlignment: CrossAxisAlignment
                        .center, // تأكد من أن العناصر تصطف بشكل جيد
                    children: [
                      Transform.translate(
                        offset: const Offset(
                            0, -3), // رفع النجمة للأعلى بمقدار 3 بكسل
                        child: const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 24, // يمكنك زيادته إذا أردت
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        product.rating.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22, // تكبير الرقم ليكون أوضح
                        ),
                      ),
                    ],
                  ),

                  // Price
                  Text(
                    '${product.price} ريال',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
