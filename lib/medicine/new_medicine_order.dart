import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewMedicineOrderScreen extends StatefulWidget {
  @override
  _NewMedicineOrderScreenState createState() => _NewMedicineOrderScreenState();
}

class _NewMedicineOrderScreenState extends State<NewMedicineOrderScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  DateTime? selectedDate;
  final _formKey = GlobalKey<FormState>();

  void _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _submitOrder() {
    if (_formKey.currentState!.validate() && selectedDate != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order is being processed...'),
          backgroundColor: Colors.teal.shade700,
        ),
      );

      // Reset fields
      nameController.clear();
      quantityController.clear();
      setState(() {
        selectedDate = null;
      });
    } else if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a delivery date'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatted = selectedDate != null
        ? DateFormat('yyyy-MM-dd').format(selectedDate!)
        : 'No date selected';

    return Scaffold(
      appBar: AppBar(
        title: Text('New Medicine Order',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.teal.shade700,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Medicine Name", style: _labelStyle),
              const SizedBox(height: 6),
              TextFormField(
                controller: nameController,
                decoration: _inputDecoration("Enter medicine name", Icons.medication_outlined),
                validator: (value) => value == null || value.isEmpty ? "Required field" : null,
              ),
              const SizedBox(height: 20),

              Text("Quantity", style: _labelStyle),
              const SizedBox(height: 6),
              TextFormField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration("Enter quantity", Icons.format_list_numbered),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Required field";
                  final qty = int.tryParse(value);
                  if (qty == null || qty <= 0) return "Invalid quantity";
                  return null;
                },
              ),
              const SizedBox(height: 20),

              Text("Delivery Date", style: _labelStyle),
              const SizedBox(height: 6),
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: _inputDecoration("Select delivery date", Icons.calendar_today),
                  child: Text(dateFormatted),
                ),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.send,color: Colors.white),
                  label: Text("Submit Order", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white)),
                  onPressed: _submitOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade700,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle get _labelStyle => TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey.shade800);

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon),
      hintText: hint,
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
