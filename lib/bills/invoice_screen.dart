import 'package:flutter/material.dart';

class InvoiceScreen extends StatefulWidget {
  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String searchText = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openFilterDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 5,
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10)
              ),
            ),
            Text(
              'Filter Invoices',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Add your filter widgets here
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade700,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Invoice Management',
          style: TextStyle(color: Colors.white),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          indicator: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.white,
                width: 3,
              ),
            ),
          ),
          tabs: [
            Tab(text: 'Current Invoices'),
            Tab(text: 'Past Invoices'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _openFilterDialog,
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search invoices...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                InvoiceList(type: 'current', searchText: searchText),
                InvoiceList(type: 'old', searchText: searchText),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class InvoiceList extends StatelessWidget {
  final String type;
  final String searchText;

  InvoiceList({required this.type, required this.searchText});

  final List<Map<String, dynamic>> invoices = [
    {
      'number': '1001',
      'status': 'Paid',
      'company': 'Life Pharma',
      'amount': 3.5,
      'date': '2023-05-15',
      'type': 'current',
      'items': [
        {'name': 'Paracetamol', 'quantity': 50, 'price': 0.5},
        {'name': 'Ibuprofen', 'quantity': 30, 'price': 0.75},
      ]
    },
    {
      'number': '1002',
      'status': 'Unpaid',
      'company': 'Pharma Med',
      'amount': 5.0,
      'date': '2023-06-20',
      'type': 'current',
      'items': [
        {'name': 'Amoxicillin', 'quantity': 20, 'price': 1.25},
      ]
    },
    {
      'number': '9001',
      'status': 'Paid',
      'company': 'NewPharm',
      'amount': 2.0,
      'date': '2023-01-10',
      'type': 'old',
      'items': [
        {'name': 'Cetirizine', 'quantity': 40, 'price': 0.3},
        {'name': 'Omeprazole', 'quantity': 15, 'price': 0.8},
      ]
    },
  ];

  Color _getStatusColor(String status) {
    return status == 'Paid' ? Colors.green : Colors.orange;
  }

  void _showInvoiceDetails(BuildContext context, Map<String, dynamic> invoice) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 5,
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10)
                  ),
                ),
              ),
              Text(
                'Invoice #${invoice['number']}',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.business, size: 20, color: Colors.grey),
                  SizedBox(width: 5),
                  Text(
                    invoice['company'],
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(invoice['status']).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      invoice['status'],
                      style: TextStyle(
                        color: _getStatusColor(invoice['status']),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Divider(),
              SizedBox(height: 15),
              Text(
                'Invoice Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildDetailRow('Date', invoice['date']),
              _buildDetailRow('Total Amount', '\$${invoice['amount'].toStringAsFixed(2)}'),
              SizedBox(height: 20),
              Text(
                'Items',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ...invoice['items'].map<Widget>((item) => Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item['name'],
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Text(
                      '${item['quantity']} x \$${item['price'].toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(width: 20),
                    Text(
                      '\$${(item['quantity'] * item['price']).toStringAsFixed(2)}',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal
                      ),
                    ),
                  ],
                ),
              )).toList(),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = invoices.where((invoice) {
      final combinedText = '${invoice['number']} ${invoice['company']} ${invoice['status']} ${invoice['amount']}'.toLowerCase();
      return invoice['type'] == type && combinedText.contains(searchText.toLowerCase());
    }).toList();

    return ListView.builder(
      padding: EdgeInsets.all(12),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final invoice = filtered[index];
        return Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          margin: EdgeInsets.only(bottom: 12),
          elevation: 0,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _showInvoiceDetails(context, invoice),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Invoice #${invoice['number']}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${invoice['amount'].toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.business, size: 18, color: Colors.grey),
                      SizedBox(width: 5),
                      Text(
                        invoice['company'],
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                      SizedBox(width: 5),
                      Text(
                        invoice['date'],
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getStatusColor(invoice['status'])
                              .withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          invoice['status'],
                          style: TextStyle(
                            color: _getStatusColor(invoice['status']),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}