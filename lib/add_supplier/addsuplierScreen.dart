import 'package:flutter/material.dart';

class AddSupplierScreen extends StatefulWidget {
  @override
  State<AddSupplierScreen> createState() => _AddSupplierScreenState();
}

class _AddSupplierScreenState extends State<AddSupplierScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactPersonController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  String? selectedPaymentTerms;

  final _formKey = GlobalKey<FormState>();

  bool _validateInputs() {
    if (_formKey.currentState?.validate() ?? false) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _customAppBar(),
      backgroundColor: Color(0xFFF1F3F6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFieldWithTitle(
                  title: "Supplier name",
                  controller: nameController,
                  required: true,
                  hintText: "Enter supplier name",
                ),
                Center(
                  child: Text(
                    'Contact Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade800,
                    ),
                  ),
                ),
                _buildSimpleField("Contact person name", contactPersonController, required: true),
                _buildSimpleField("Email address", emailController,
                    inputType: TextInputType.emailAddress, required: true),
                _buildSimpleField("Phone number", phoneController,
                    inputType: TextInputType.phone, required: true),

                Center(
                  child: Text(
                    'Payment',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade800,
                    ),
                  ),
                ),
                DropdownButtonFormField<String>(
                  decoration: _inputDecoration().copyWith(
                    hintText: "Select Payment Terms",
                  ),
                  items: ['Net 30', 'Net 60', 'On Delivery', 'Advance Payment']
                      .map((term) => DropdownMenuItem(
                    value: term,
                    child: Text(term),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPaymentTerms = value;
                    });
                  },
                  validator: (value) =>
                  value == null ? 'Please select payment terms' : null,
                ),

                SizedBox(height: 15),
                Center(
                  child: Text(
                    'Notes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade800,
                    ),
                  ),
                ),
                TextFormField(
                  controller: notesController,
                  maxLines: 3,
                  decoration: _inputDecoration().copyWith(
                    hintText: "Additional notes about this supplier",
                  ),
                  validator: (value) {
                    if (value != null &&
                        value.isNotEmpty &&
                        value.length < 5) {
                      return 'Notes must be at least 5 characters';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          side: BorderSide(color: Colors.teal),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.teal, fontSize: 16),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_validateInputs()) {
                            print("Supplier Saved!");
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                              content: Text(
                                  "Please fill in all required fields with valid data."),
                              backgroundColor: Colors.red,
                            ));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Save',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldWithTitle({
    required String title,
    required TextEditingController controller,
    bool required = false,
    TextInputType inputType = TextInputType.text,
    String? hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: _labelStyle()),
        SizedBox(height: 5),
        TextFormField(
          controller: controller,
          keyboardType: inputType,
          decoration: _inputDecoration().copyWith(hintText: hintText),
          validator: required
              ? (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          }
              : null,
        ),
        SizedBox(height: 15),
      ],
    );
  }

  Widget _buildSimpleField(
      String hintText,
      TextEditingController controller, {
        bool required = false,
        TextInputType inputType = TextInputType.text,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        decoration: _inputDecoration().copyWith(hintText: hintText),
        validator: required
            ? (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          if (hintText == "Email address") {
            if (!value.contains('@') || !value.contains('.com')) {
              return 'Please enter a valid email address';
            }
          }
          return null;
        }
            : null,
      ),
    );
  }

  PreferredSizeWidget _customAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(120),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Text(
              'Add Supplier',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
    );
  }

  TextStyle _labelStyle() {
    return TextStyle(
        fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey.shade800);
  }
}
