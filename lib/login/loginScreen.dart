import 'package:flutter/material.dart';

import '../homepage/homepage.dart';
import 'forgetpassword/sendemail.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // مفتاح للتحكم في حالة النموذج

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(32.0),
        child: Form(
          key: _formKey, // ربط النموذج بالمفتاح
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 80.0),
              Image.asset(
                'assets/images/logo.png',
                height: 150.0,
              ),
              SizedBox(height: 40.0),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email address';
                  }
                  if (!value.contains('@') || !value.contains('.com')) {
                    return 'Please enter a valid email address';
                  }
                  return null; // الإدخال صالح
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null; // الإدخال صالح
                },
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPasswordScreen()));
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.red,
                      fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => PharmacyDashboard()),
                  );
                  if (_formKey.currentState!.validate()) {
                    // إذا كان النموذج صالحًا، قم بتنفيذ منطق تسجيل الدخول هنا
                    String email = _emailController.text;
                    String password = _passwordController.text;
                    print('Email: $email, Password: $password');
                    // يمكنك هنا إرسال بيانات الاعتماد إلى الخادم
                  }
                },
                child: Text(
                  'Sign In',
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

