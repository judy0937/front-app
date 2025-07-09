import 'package:flutter/material.dart';

class PharmacistRegisterScreen extends StatefulWidget {
  @override
  _PharmacistRegisterScreenState createState() => _PharmacistRegisterScreenState();
}

class _PharmacistRegisterScreenState extends State<PharmacistRegisterScreen> {
  final TextEditingController propertyNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Widget buildTextField(String label, TextEditingController controller, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pharmacist Registration'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildTextField('Property Name', propertyNameController),
            buildTextField('Address', addressController),
            buildTextField('Contact Number', contactNumberController),
            buildTextField('Username', usernameController),
            buildTextField('Email', emailController),
            buildTextField('Password', passwordController, isPassword: true),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // لا يوجد إرسال بيانات حالياً
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Form ready (not connected to backend)')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text(
                'Register',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
