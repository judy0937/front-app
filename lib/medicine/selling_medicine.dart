import 'package:flutter/material.dart';

class SellMedicineScreen extends StatefulWidget {
  final String medicineName;
  final double unitPrice;
  final int stock;
  final Function(int soldQuantity) onSellComplete;

  const SellMedicineScreen({
    required this.medicineName,
    required this.unitPrice,
    required this.stock,
    required this.onSellComplete,
  });

  @override
  _SellMedicineScreenState createState() => _SellMedicineScreenState();
}

class _SellMedicineScreenState extends State<SellMedicineScreen> {
  int quantity = 1;
  String paymentMethod = 'Cash';
  String? errorText;

  late TextEditingController quantityController;

  @override
  void initState() {
    super.initState();
    quantityController = TextEditingController(text: quantity.toString());
  }

  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }

  void updateQuantity(int newQuantity) {
    if (newQuantity < 1) newQuantity = 1;
    if (newQuantity > widget.stock) newQuantity = widget.stock;

    setState(() {
      quantity = newQuantity;
      errorText = null;
      quantityController.text = quantity.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final total = (quantity * widget.unitPrice).toStringAsFixed(2);

    return Scaffold(
      appBar: AppBar(
        title: Text('Sell ${widget.medicineName}'),
        backgroundColor: Colors.teal.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      widget.medicineName,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Unit Price: ${widget.unitPrice} JD'),
                        Text('Stock: ${widget.stock} units'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Quantity selector (with +/- buttons and text field)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Quantity", style: TextStyle(fontSize: 16)),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove_circle_outline),
                      onPressed: quantity > 1
                          ? () => updateQuantity(quantity - 1)
                          : null,
                    ),
                    SizedBox(
                      width: 60,
                      child: TextField(
                        controller: quantityController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                          border: OutlineInputBorder(),
                          errorText: errorText,
                        ),
                        onChanged: (value) {
                          final input = int.tryParse(value);
                          if (input == null) {
                            setState(() {
                              errorText = 'Please enter a valid number';
                            });
                          } else if (input < 1) {
                            setState(() {
                              errorText = 'Quantity must be at least 1';
                            });
                          } else if (input > widget.stock) {
                            setState(() {
                              errorText = 'Quantity exceeds available stock';
                            });
                          } else {
                            setState(() {
                              quantity = input;
                              errorText = null;
                            });
                          }
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      onPressed: quantity < widget.stock
                          ? () => updateQuantity(quantity + 1)
                          : null,
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 20),

            // Payment method dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Payment Method", style: TextStyle(fontSize: 16)),
                DropdownButton<String>(
                  value: paymentMethod,
                  items: ['Cash', 'Card', 'Online']
                      .map((method) => DropdownMenuItem(
                    value: method,
                    child: Text(method),
                  ))
                      .toList(),
                  onChanged: (value) => setState(() {
                    paymentMethod = value!;
                  }),
                ),
              ],
            ),

            SizedBox(height: 30),

            // Total price display
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                Text(
                  '$total JD',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal.shade700),
                ),
              ],
            ),

            Spacer(),

            // Confirm button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: Icon(Icons.check_circle,color: Colors.white),
                label: Text('Confirm Sale', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade700,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  if (quantity <= 0) {
                    setState(() {
                      errorText = 'Quantity must be at least 1';
                    });
                    return;
                  }
                  if (quantity > widget.stock) {
                    setState(() {
                      errorText = 'Quantity exceeds available stock';
                    });
                    return;
                  }
                  // Notify parent about sold quantity
                  widget.onSellComplete(quantity);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
