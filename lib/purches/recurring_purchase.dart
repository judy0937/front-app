import 'package:flutter/material.dart';

// نموذج بيانات للطلب المتكرر
class RecurringPurchase {
  final String itemName;
  final int quantity;

  RecurringPurchase({required this.itemName, required this.quantity});
}

class RecurringRequestsScreen extends StatefulWidget {
  @override
  _RecurringRequestsScreenState createState() => _RecurringRequestsScreenState();
}

class _RecurringRequestsScreenState extends State<RecurringRequestsScreen> {
  // قائمة مؤقتة بالطلبات المتكررة (Repeat on Request)
  List<RecurringPurchase> recurringRequests = [
    RecurringPurchase(itemName: 'Item A', quantity: 2),
    RecurringPurchase(itemName: 'Item B', quantity: 5),
    RecurringPurchase(itemName: 'Item C', quantity: 1),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recurring Requests'),
        backgroundColor: Colors.teal.shade700,
        centerTitle: true,
      ),
      body: recurringRequests.isEmpty
          ? Center(
        child: Text(
          'No recurring requests found.',
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: recurringRequests.length,
        itemBuilder: (context, index) {
          final request = recurringRequests[index];
          return Card(
            margin: EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text(request.itemName,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Quantity: ${request.quantity}'),
              trailing: ElevatedButton(
                onPressed: () {
                  // هنا يمكنك تنفيذ العملية عند الطلب (مثلاً إعادة الطلب)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Request for ${request.itemName} placed successfully!'),
                    ),
                  );
                },
                child: Text('Order Now'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade700,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}