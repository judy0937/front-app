import 'package:flutter/material.dart';

class AddPurchaseScreen extends StatefulWidget {
  @override
  _AddPurchaseScreenState createState() => _AddPurchaseScreenState();
}

class _AddPurchaseScreenState extends State<AddPurchaseScreen> {
  final _formKey = GlobalKey<FormState>();

  String itemName = '';
  int quantity = 1;
  bool isRecurring = false;
  bool repeatByDate = true;
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Purchase',style: TextStyle(color:Colors.white),),
        backgroundColor: Colors.teal.shade700,
        centerTitle: true,
      ),
      body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
              key: _formKey,
              child: ListView(
                children: [
                Text(
                'Purchase Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Item Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  itemName = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter item name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                initialValue: '1',
                onChanged: (value) {
                  quantity = int.tryParse(value) ?? 1;
                },
              ),
              SizedBox(height: 20),
              SwitchListTile(
                title: Text('Is this a recurring purchase?'),
                value: isRecurring,
                onChanged: (value) {
                  setState(() {
                    isRecurring = value;
                  });
                },
              ),
              if (isRecurring) ...[
      Row(
      children: [
      Expanded(
      child: RadioListTile<bool>(
      title: Text('Repeat on Date'),
      value: true,
      groupValue: repeatByDate,
      onChanged: (value) {
        setState(() {
          repeatByDate = value!;
        });
      },
    ),
    ),
    Expanded(
    child: RadioListTile<bool>(
    title: Text('Repeat on Request'),
    value: false,
    groupValue: repeatByDate,
    onChanged: (value) {
    setState(() {
    repeatByDate = value!;
    });
    },
    ),
    ),
    ],
    ),
    if (repeatByDate)
    ListTile(
    title: Text(selectedDate == null
    ? 'Choose a Date'
        : 'Repeat Date: ${selectedDate!.toLocal()}'.split(' ')[0]),
    trailing: Icon(Icons.calendar_today),
    onTap: () async {
    final picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(2100),
    );
    if (picked != null) {
    setState(() {
    selectedDate = picked;
    });
    }
    },
    ),
              ],
                  SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // تنفيذ حفظ العملية الشرائية
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Purchase Added')),
                        );
                      }
                    },
                    icon: Icon(Icons.save,color:Colors.white),
                    label: Text('Save Purchase',style: TextStyle(color:Colors.white),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade700,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
          ),
      ),
    );
  }
}