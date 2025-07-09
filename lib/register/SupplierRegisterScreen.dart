import 'package:flutter/material.dart';

class SupplierRegisterScreen extends StatefulWidget {
  @override
  _SupplierRegisterScreenState createState() => _SupplierRegisterScreenState();
}

class _SupplierRegisterScreenState extends State<SupplierRegisterScreen> {
  final TextEditingController propertyNameController = TextEditingController();
  final TextEditingController warehouseAddressController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController contactPersonController = TextEditingController();

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
        title: Text('Supplier Registration'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildTextField('Property Name', propertyNameController),
            buildTextField('Warehouse Address', warehouseAddressController),
            buildTextField('Contact Number', contactNumberController),
            buildTextField('Name', nameController),
            buildTextField('Email', emailController),
            buildTextField('Password', passwordController, isPassword: true),
            buildTextField('Address', addressController),
            buildTextField('Phone', phoneController),
            buildTextField('Contact Person', contactPersonController),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // لا يوجد إرسال بيانات هنا
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('بيانات جاهزة ولكن غير مربوطة بالباك')),
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
