import 'package:flutter/material.dart';



import '../login/loginScreen.dart';



class OnboardingScreen extends StatefulWidget {

  @override

  _OnboardingScreenState createState() => _OnboardingScreenState();

}



class _OnboardingScreenState extends State<OnboardingScreen> {

  final PageController _pageController = PageController(initialPage: 0);

  int _currentPage = 0;



  final List<Map<String, String>> _pagesData = [

    {

      'title': 'Track Inventory Easily',

      'description':

      'Monitor your pharmacy stock levels in real-time and receive alerts when items need to be reordered.',

    },

    {

      'title': 'Manage Suppliers Efficiently',

      'description':

      'Streamline your procurement process and maintain strong relationships with your suppliers.',

    },

    {

      'title': 'Generate Reports Instantly',

      'description':

      'Access comprehensive reports on your pharmacy operations with just a few taps.',

    },

  ];



  @override

  void dispose() {

    _pageController.dispose();

    super.dispose();

  }



  @override

  Widget build(BuildContext context) {

    return Scaffold(

      body: Column(

        children: <Widget>[

          Expanded(

            child: PageView.builder(

              controller: _pageController,

              itemCount: _pagesData.length,

              onPageChanged: (int page) {

                setState(() {

                  _currentPage = page;

                });

              },

              itemBuilder: (BuildContext context, int index) {

                return Padding(

                  padding: EdgeInsets.all(32.0),

                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: <Widget>[

                      Spacer(),

                      Text(

                        _pagesData[index]['title']!,

                        textAlign: TextAlign.center,

                        style: TextStyle(

                          fontSize: 24.0,

                          fontWeight: FontWeight.bold,

                          color: Colors.teal[700],

                        ),

                      ),

                      SizedBox(height: 16.0),

                      Text(

                        _pagesData[index]['description']!,

                        textAlign: TextAlign.center,

                        style: TextStyle(

                          fontSize: 16.0,

                          color: Colors.grey[600],

                        ),

                      ),

                    ],

                  ),

                );

              },

            ),

          ),

          Padding(

            padding: const EdgeInsets.all(32.0),

            child: Column(

              children: [

                Row(

                  mainAxisAlignment: MainAxisAlignment.center,

                  children: _buildPageIndicator(),

                ),

                SizedBox(height: 48.0),

                SizedBox(

                  width: double.infinity,

                  child: ElevatedButton(

                    onPressed: () {

                      if (_currentPage < _pagesData.length - 1) {

                        _pageController.nextPage(

                          duration: Duration(milliseconds: 300),

                          curve: Curves.easeInOut,

                        );

                      } else {

// الانتقال إلى شاشة تسجيل الدخول

                        Navigator.push(

                          context,

                          MaterialPageRoute(builder: (context) => LoginScreen()),

                        );

                      }

                    },

                    style: ElevatedButton.styleFrom(

                      backgroundColor: Colors.teal[500],

                      padding: EdgeInsets.symmetric(vertical: 16.0),

                      shape: RoundedRectangleBorder(

                        borderRadius: BorderRadius.circular(8.0),

                      ),

                    ),

                    child: Text(

                      _currentPage < _pagesData.length - 1 ? 'Next' : 'Get Started',

                      style: TextStyle(

                        color: Colors.white,

                        fontSize: 18.0,

                        fontWeight: FontWeight.bold,

                      ),

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



  List<Widget> _buildPageIndicator() {

    List<Widget> indicators = [];

    for (int i = 0; i < _pagesData.length; i++) {

      indicators.add(

        i == _currentPage

            ? _indicator(true)

            : _indicator(false),

      );

    }

    return indicators;

  }



  Widget _indicator(bool isActive) {

    return AnimatedContainer(

      duration: Duration(milliseconds: 150),

      margin: EdgeInsets.symmetric(horizontal: 8.0),

      height: 8.0,

      width: isActive ? 24.0 : 8.0,

      decoration: BoxDecoration(

        color: isActive ? Colors.teal[400] : Colors.grey[300],

        borderRadius: BorderRadius.circular(4.0),

      ),

    );

  }

}