import 'package:flutter/material.dart';

class AddInventoryScreen extends StatefulWidget {
  @override
  _AddInventoryScreenState createState() => _AddInventoryScreenState();
}

class _AddInventoryScreenState extends State<AddInventoryScreen> {
  final _formKey = GlobalKey<FormState>();
  int? medicineId;
  String locationType = "PHARMACY";
  int quantity = 0;
  String costPrice = '';
  String sellingPrice = '';
  DateTime? expiryDate;

  void submitInventory() {
    if (_formKey.currentState!.validate()) {
      final payload = {
        "medicine_id": medicineId,
        "location_type": locationType,
        "quantity": quantity,
        "cost_price": costPrice,
        "selling_price": sellingPrice,
        "expiry_date": expiryDate?.toIso8601String(),
        "pharmacy_id": 1, // يمكنك تغييره حسب الحاجة
      };

      print("✅ Sending this data:");
      print(payload);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("تم تجهيز البيانات بنجاح!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Add to Inventory"),
        backgroundColor: Colors.teal, // هنا تغير اللون إلى Teal
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: "Medicine ID",
                  border: OutlineInputBorder(),
                ),
                value: medicineId,
                items: [10, 11, 12]
                    .map((id) => DropdownMenuItem(
                  value: id,
                  child: Text("Medicine $id"),
                ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    medicineId = val;
                  });
                },
                validator: (val) => val == null ? "الرجاء اختيار دواء" : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "الكمية",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (val) => quantity = int.tryParse(val) ?? 0,
                validator: (val) => val == null || val.isEmpty ? "أدخل الكمية" : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "سعر التكلفة",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (val) => costPrice = val,
                validator: (val) => val == null || val.isEmpty ? "أدخل سعر التكلفة" : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "سعر البيع",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (val) => sellingPrice = val,
                validator: (val) => val == null || val.isEmpty ? "أدخل سعر البيع" : null,
              ),
              SizedBox(height: 16),
              ListTile(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                title: Text(expiryDate == null
                    ? "اختر تاريخ انتهاء الصلاحية"
                    : "تاريخ الانتهاء: ${expiryDate!.toLocal().toString().split(' ')[0]}"),
                trailing: Icon(Icons.calendar_today, color: Colors.teal),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2035),
                  );
                  if (picked != null) {
                    setState(() {
                      expiryDate = picked;
                    });
                  }
                },
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: submitInventory,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  child: Text("حفظ"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
