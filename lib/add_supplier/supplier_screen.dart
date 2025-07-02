import 'package:flutter/material.dart';
import 'package:test2/add_supplier/supplier_details.dart';
import 'addsuplierScreen.dart';

class SuppliersScreen extends StatelessWidget {

  final List<Map<String, dynamic>> suppliers = [
    {
      'name': 'Medicare Co.',
      'phone': '+963 944 123 456',
      'email': 'contact@medicare.com',
      'products': 12,
    },
    {
      'name': 'HealthPlus Supplies',
      'phone': '+963 993 456 789',
      'email': 'sales@healthplus.com',
      'products': 8,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEFFC),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: suppliers.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final supplier = suppliers[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SupplierDetailsScreen(supplier: supplier,),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: Text(
                      supplier['name'][0],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    supplier['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(supplier['phone']),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddSupplierScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
