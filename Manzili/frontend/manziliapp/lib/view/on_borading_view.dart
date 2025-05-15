import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manziliapp/view/start_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoradingView extends StatefulWidget {
  const OnBoradingView({super.key});

  @override
  State<OnBoradingView> createState() => _OnBoradingViewState();
}

class _OnBoradingViewState extends State<OnBoradingView> {
  int currentPageIndex = 0;
  PageController? pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  Widget _skipButton() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * .02,
          horizontal: MediaQuery.of(context).size.height * .01),
      child: GestureDetector(
        onTap: () => Get.to(() => StartView()),
        child: Text(
          "تخطي",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          textAlign: TextAlign.right,
        ),
      ),
    );
  }

  Widget _pageViewContent() {
    return PageView(
      onPageChanged: (val) {
        setState(() {
          currentPageIndex = val;
        });
      },
      controller: pageController,
      children: const [
        IntroPageItem(
          imagePath: "lib/assets/image/im_one.png",
          title: "ابدأ بيع منتجاتك بسهولة",
          description:
              "  افتح متجرك الآن واستقبل طلبات العملاء مباشرة! احصل على فرصة لعرض منتجاتك والتواصل مع المشترين المهتمين بكل سهولة",
        ),
        IntroPageItem(
          imagePath: "Lib/assets/image/im_tow.png",
          title: " وصل منتجاتك بسرعة وسهولة",
          description:
              "لا تقلق بشأن التوصيل! وفر خيارات مريحة لعملائك لتسليم الطلبات في الوقت المناسب، سواء عبر مندوب توصيل أو الاستلام المباشر",
        ),
        IntroPageItem(
          imagePath: "Lib/assets/image/im_three.png",
          title: " تجربة تسوق آمنة وسهلة",
          description:
              "اكتشف منتجات فريدة من الأسر المنتجة، وتسوّق بكل سهولة مع خيارات دفع آمنة وموثوقة، لضمان تجربة تسوق ممتعة",
        ),
      ],
    );
  }

  Widget _pageIndicator() {
    return Container(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * .1),
      child: SmoothPageIndicator(
        controller: pageController!,
        count: 3,
        effect: const WormEffect(
          activeDotColor: Color(0xffffffff),
          dotColor: Color(0xff728bcb),
          dotHeight: 16,
          dotWidth: 16,
          type: WormType.thinUnderground,
        ),
      ),
    );
  }

  Widget _floatingActionButtonContent() {
    return Transform.translate(
      offset: Offset(30, 30),
      child: SizedBox(
        width: 100,
        height: 100,
        child: FloatingActionButton(
          onPressed: () {
            if (currentPageIndex < 2) {
              pageController!.animateToPage(
                currentPageIndex + 1,
                duration: Duration(milliseconds: 700),
                curve: Curves.easeIn,
              );
            } else {
              // Navigator.of(context).pushNamed("HomeIontro");

              Get.to(() => StartView());
            }
          },
          backgroundColor: Color(0xff1d182a),
          shape: CircleBorder(),
          child: Icon(
            currentPageIndex == 2 ? Icons.check : Icons.arrow_forward,
            color: Colors.white,
            size: 50,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      body: SafeArea(
        child: Column(
          children: [
            _skipButton(),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(100)),
                child: Container(
                  width: double.infinity,
                  color: Color(0xff1548c7),
                  child: Column(
                    children: [
                      Expanded(child: _pageViewContent()),
                      _pageIndicator(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _floatingActionButtonContent(),
    );
  }
}

class IntroPageItem extends StatelessWidget {
  const IntroPageItem({
    required this.imagePath,
    required this.title,
    required this.description,
    super.key,
  });

  final String imagePath;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // Add this wrapper
      child: Column(
        children: [
          const SizedBox(height: 100),
          Stack(
            children: [
              _buildAvatarStack(),
              _buildImage(),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 30, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ConstrainedBox( // Add constraints
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.2,
                  ),
                  child: SingleChildScrollView( // Make description scrollable
                    child: Text(
                      description,
                      style: TextStyle(fontSize: 18, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Keep your original _buildAvatarStack and _buildImage methods unchanged
  Widget _buildAvatarStack() {
    return Center(
      child: CircleAvatar(
        radius: 90,
        backgroundColor: Color(0xff374ca7),
        child: CircleAvatar(
          radius: 60,
          backgroundColor: Color(0xff444e9a),
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Color(0xff4c4f92),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Center(
      child: SizedBox(
        height: 300,
        child: Image.asset(
          imagePath,
          width: 300,
          fit: BoxFit.contain, // Add this to prevent image overflow
        ),
      ),
    );
  }
}