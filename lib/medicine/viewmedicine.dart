import 'package:flutter/material.dart';
import 'package:test2/medicine/selling_medicine.dart';

class DrugListScreen extends StatefulWidget {
  @override
  _DrugListScreenState createState() => _DrugListScreenState();
}

class _DrugListScreenState extends State<DrugListScreen> {
  final List<Map<String, dynamic>> drugs = [
    {
      'name': 'Paracetamol',
      'company': 'Life Pharma',
      'quantity': 120,
      'price': 3.5,
      'expiry': '2026-08-01'
    },
    {
      'name': 'Amoxicillin',
      'company': 'Pharma Med',
      'quantity': 60,
      'price': 5.0,
      'expiry': '2025-12-15'
    },
    {
      'name': 'Vitamin C',
      'company': 'NewPharm',
      'quantity': 200,
      'price': 2.0,
      'expiry': '2024-11-30'
    },
  ];

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredDrugs = drugs.where((drug) {
      final name = drug['name'].toString().toLowerCase();
      final query = searchQuery.toLowerCase();
      return name.contains(query);
    }).toList();

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search by drug name...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: filteredDrugs.length,
                  separatorBuilder: (context, index) => SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final drug = filteredDrugs[index];
                    final originalIndex = drugs.indexOf(drug);
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.medication_outlined, color: Colors.teal, size: 24),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  drug['name'],
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                                ),
                              ),
                              Text(
                                "${drug['price']} JD",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal.shade700,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Divider(),
                          SizedBox(height: 10),
                          InfoRow(icon: Icons.business, label: 'Company', value: drug['company']),
                          InfoRow(icon: Icons.inventory_2_outlined, label: 'Quantity', value: '${drug['quantity']} units'),
                          InfoRow(icon: Icons.date_range, label: 'Expiry Date', value: drug['expiry']),
                          SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              icon: Icon(Icons.shopping_cart_checkout,color: Colors.white,),
                              label: Text('Sell',style: TextStyle(color: Colors.white),),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal.shade600,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SellMedicineScreen(
                                      medicineName: drug['name'],
                                      unitPrice: drug['price'],
                                      stock: drug['quantity'],
                                      onSellComplete: (soldQuantity) {
                                        setState(() {
                                          drugs[originalIndex]['quantity'] -= soldQuantity;
                                        });
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        SizedBox(width: 8),
        Text(
          '$label:',
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700]),
        ),
        SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontWeight: FontWeight.w400),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
