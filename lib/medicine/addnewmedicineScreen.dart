import 'package:flutter/material.dart';

class AddMedicineScreen extends StatefulWidget {
  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController scientificNameController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController expirationDateController = TextEditingController();

  String? selectedCategory;

  // Function to validate inputs
  bool _validateInputs() {
    if (nameController.text.isEmpty ||
        scientificNameController.text.isEmpty ||
        brandController.text.isEmpty ||
        quantityController.text.isEmpty ||
        priceController.text.isEmpty ||
        expirationDateController.text.isEmpty ||
        selectedCategory == null) {
      return false;
    }

    if (double.tryParse(quantityController.text) == null ||
        double.tryParse(priceController.text) == null) {
      return false;
    }

    return true;
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        expirationDateController.text = "${picked.month}/${picked.day}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _customAppBar(),
      backgroundColor: Color(0xFFF1F3F6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabeledField("Medicine Name", nameController),
              _buildLabeledField("Scientific Name", scientificNameController),
              _buildLabeledField("Brand", brandController),
              Row(
                children: [
                  Expanded(child: _buildLabeledField("Quantity", quantityController, inputType: TextInputType.number)),
                  SizedBox(width: 10),
                  Expanded(child: _buildLabeledField("Price", priceController, inputType: TextInputType.numberWithOptions(decimal: true))),
                ],
              ),
              SizedBox(height: 15),
              Text("Category", style: _labelStyle()),
              SizedBox(height: 5),
              DropdownButtonFormField<String>(
                decoration: _inputDecoration().copyWith(
                  hintText: "Select medicine category",
                ),
                items: ['Antibiotic', 'Painkiller', 'Vaccine', 'Other']
                    .map((category) => DropdownMenuItem(
                  value: category,
                  child: Text(category),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
              ),
              SizedBox(height: 15),
              Text("Expiration Date", style: _labelStyle()),
              SizedBox(height: 5),
              TextField(
                controller: expirationDateController,
                readOnly: true,
                onTap: () => _selectDate(context),
                decoration: _inputDecoration().copyWith(
                  hintText: "Enter expiration date",
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_validateInputs()) {
                      print("Medicine Saved!");
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Please fill in all fields with valid data."),
                        backgroundColor: Colors.red,
                      ));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Add New Medicine',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _customAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(100),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.teal[500],
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Add New Medicine',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 10,
                top: 20,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledField(String label, TextEditingController controller, {TextInputType inputType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: _labelStyle()),
          SizedBox(height: 5),
          TextField(
            controller: controller,
            keyboardType: inputType,
            decoration: _inputDecoration().copyWith(
              hintText: "Enter ${label.toLowerCase()}",
            ),
          ),
        ],
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
    return TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey.shade800);
  }
}
