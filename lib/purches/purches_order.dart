import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'add_purches_screen.dart';

class PurchaseHistoryScreen extends StatefulWidget {
  @override
  _PurchaseHistoryScreenState createState() => _PurchaseHistoryScreenState();
}

class _PurchaseHistoryScreenState extends State<PurchaseHistoryScreen> {
  final List<Map<String, dynamic>> purchaseHistory = [
    {
      'id': 'PO12348',
      'date': '2025-06-18',
      'total': 120.50,
      'status': 'Completed',
      'paymentMethod': 'Credit Card',
      'paymentStatus': 'Paid',
      'medicines': [
        {'name': 'Paracetamol', 'quantity': 5, 'price': 10.00},
        {'name': 'Ibuprofen', 'quantity': 3, 'price': 15.00},
      ],
      'updates': ['Order confirmed', 'Shipped on 2025-06-19', 'Delivered on 2025-06-20']
    },
    {
      'id': 'PO12349',
      'date': '2025-06-20',
      'total': 99.99,
      'status': 'Pending',
      'paymentMethod': 'Cash',
      'paymentStatus': 'Pending',
      'medicines': [
        {'name': 'Amoxicillin', 'quantity': 2, 'price': 25.00},
      ],
      'updates': ['Order received']
    },
    // Add this new cancelled order
    {
      'id': 'PO12350',
      'date': '2025-06-22',
      'total': 75.25,
      'status': 'Cancelled',
      'paymentMethod': 'Credit Card',
      'paymentStatus': 'Refunded',
      'medicines': [
        {'name': 'Aspirin', 'quantity': 4, 'price': 12.50},
        {'name': 'Vitamin C', 'quantity': 2, 'price': 12.50},
      ],
      'updates': ['Order placed', 'Cancelled by user on 2025-06-23', 'Refund processed']
    },
  ];


  List<Map<String, dynamic>> filteredHistory = [];
  String _searchQuery = '';
  String _selectedFilter = 'All';


  // عدد الطلبات المعلقة
  int get pendingOrdersCount => purchaseHistory.where((order) => order['status'] == 'Pending').length;

  @override
  void initState() {
    super.initState();
    filteredHistory = List.from(purchaseHistory);
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _filterHistory() {
    setState(() {
      filteredHistory = purchaseHistory.where((purchase) {
        final matchesSearch = _searchQuery.isEmpty ||
            purchase['id'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
            purchase['medicines'].any((med) => med['name'].toLowerCase().contains(_searchQuery.toLowerCase()));

        final matchesFilter = _selectedFilter == 'All' || purchase['status'] == _selectedFilter;

        return matchesSearch && matchesFilter;
      }).toList();
    });
  }

  void _showOrderDetails(Map<String, dynamic> order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order #${order['id']}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Divider(),
              Text('Date: ${order['date']}'),
              SizedBox(height: 8),
              Text('Total: \$${order['total'].toStringAsFixed(2)}'),
              SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _statusColor(order['status']).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      order['status'],
                      style: TextStyle(
                        color: _statusColor(order['status']),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Text('Payment: ${order['paymentMethod']}'),
                  SizedBox(width: 16),
                  Text(
                    '${order['paymentStatus']}',
                    style: TextStyle(
                      color: order['paymentStatus'] == 'Paid'
                          ? Colors.green
                          : Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Medicines:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: order['medicines'].length,
                  itemBuilder: (context, index) {
                    final medicine = order['medicines'][index];
                    return ListTile(
                      title: Text(medicine['name']),
                      subtitle: Text('Quantity: ${medicine['quantity']}'),
                      trailing: Text('\$${medicine['price'].toStringAsFixed(2)}'),
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Order Updates:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: order['updates'].length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(Icons.info_outline, color: Colors.blue),
                      title: Text(order['updates'][index]),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase History'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Filter by Date'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text('Last Week'),
                        onTap: () {
                          final now = DateTime.now();
                          final lastWeek = now.subtract(Duration(days: 7));
                          _filterByDateRange(lastWeek, now);
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: Text('Last Month'),
                        onTap: () {
                          final now = DateTime.now();
                          final lastMonth = now.subtract(Duration(days: 30));
                          _filterByDateRange(lastMonth, now);
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: Text('Custom Range'),
                        onTap: () {
                          Navigator.pop(context);
                          _showCustomDateRangePicker();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPurchaseScreen()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          // إشعار الطلبات المعلقة
          if (pendingOrdersCount > 0)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.orange[50],
              child: Row(
                children: [
                  Icon(Icons.notification_important, color: Colors.orange),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'You have $pendingOrdersCount pending orders that need review',
                      style: TextStyle(
                        color: Colors.orange[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by order ID or medicine name...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                  _filterHistory();
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Completed', 'Pending', 'Cancelled']
                    .map((filter) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: _selectedFilter == filter,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = selected ? filter : 'All';
                        _filterHistory();
                      });
                    },
                  ),
                ))
                    .toList(),
              ),
            ),
          ),
          Expanded(
            child: filteredHistory.isEmpty
                ? Center(
              child: Text('No orders found'),
            )
                : ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: filteredHistory.length,
              itemBuilder: (context, index) {
                final purchase = filteredHistory[index];
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  margin: EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: Icon(Icons.shopping_cart_outlined,
                        color: Colors.teal),
                    title: Text('Order #${purchase['id']}'),
                    subtitle: Text(
                      'Date: ${purchase['date']}\nTotal: \$${purchase['total'].toStringAsFixed(2)}',
                    ),
                    trailing: Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _statusColor(purchase['status'])
                            .withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        purchase['status'],
                        style: TextStyle(
                          color: _statusColor(purchase['status']),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    isThreeLine: true,
                    onTap: () {
                      _showOrderDetails(purchase);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _filterByDateRange(DateTime start, DateTime end) {
    setState(() {
      filteredHistory = purchaseHistory.where((purchase) {
        final purchaseDate = DateFormat('yyyy-MM-dd').parse(purchase['date']);
        return purchaseDate.isAfter(start) && purchaseDate.isBefore(end);
      }).toList();
    });
  }

  void _showCustomDateRangePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      _filterByDateRange(picked.start, picked.end);
    }
  }
}