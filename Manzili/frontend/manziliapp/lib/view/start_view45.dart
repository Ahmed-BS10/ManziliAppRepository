import 'package:flutter/material.dart';

class StartView extends StatelessWidget {
  const StartView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/Pica-enhance-20250103142731-removebg-preview-removebg-preview 3.png',
                height: 200,
                width: 200,
              ),
              SizedBox(height: 20),
              Text(
                " حيث يلتقي الإبداع بالحرفة اكتشف روائع العائلات المنتجة",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                "...هل أنت",
                style: TextStyle(fontSize: 21),
              ),
              SizedBox(height: 20),
              CustomButton(
                text: "إسرة منتجة",
                onPressed: () {
                  Navigator.of(context).pushNamed("Product");
                },
              ),
              SizedBox(height: 15),
              CustomButton(
                text: "عميل",
                onPressed: () {
                  Navigator.of(context).pushNamed("Product");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff1548c7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(vertical: 15),
        ),
        onPressed: onPressed,
        child: Text(text, style: TextStyle(fontSize: 19, color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
