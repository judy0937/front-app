import 'package:flutter/material.dart';

import 'introPage.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 1.0; // تحديد قيمة التدرج الابتدائي

  @override
  void initState() {
    super.initState();
    // بعد ثانيتين نبدأ في تلاشي الشاشة تدريجيًا
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _opacity = 0.0; // نغير القيمة لجعل الشاشة تختفي تدريجيًا
      });
    });

    // بعد خمس ثوانٍ ننتقل للصفحة التالية
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: AnimatedOpacity(
        opacity: _opacity,
        duration: Duration(seconds: 2), // مدة التلاشي
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            // خلفية التطبيق
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // شعار التطبيق
                Image.asset(
                  'assets/images/logo.png',
                  width: 150.0,
                  height: 150.0,
                ),
                SizedBox(height: 20.0),
                // اسم التطبيق بألوان مختلفة
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Pharma',
                        style: TextStyle(
                          color: Colors.black, // لون أسود
                        ),
                      ),
                      TextSpan(
                        text: ' Track', // إضافة مسافة قبل الكلمة الثانية
                        style: TextStyle(
                          color: Colors.teal, // لون تيلي
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                // شعار ثانوي (اختياري)
                Text(
                  'Your Pharmacy, Simplified',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16.0,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            // حقوق النشر
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Text(
                  '© 2025 Pharma Track, All rights reserved.',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12.0,
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
