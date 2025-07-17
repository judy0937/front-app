import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../medicine/addnewmedicineScreen.dart';


class MedicineInventoryScreen extends StatefulWidget {
  @override
  _MedicineInventoryScreenState createState() => _MedicineInventoryScreenState();
}

class _MedicineInventoryScreenState extends State<MedicineInventoryScreen> {
  List<Map<String, dynamic>> inventoryList = [
    {
      "name": "DIUREX",
      "titer": "MG 25",
      "type": "TAB",
      "quantity": 10,
      "cost_price": 250.00,
      "selling_price": 300.00,
      "expiry_date": "2027-09-05",
      "barcode": "1234567890",
    },
    {
      "name": "PARACETAMOL",
      "titer": "500 MG",
      "type": "TAB",
      "quantity": 25,
      "cost_price": 15.00,
      "selling_price": 20.00,
      "expiry_date": "2026-03-12",
      "barcode": "0987654321",
    },
  ];

  List<Map<String, dynamic>> filteredList = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredList = inventoryList;
  }

  void filterSearch(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredList = inventoryList.where((item) {
        return item['name'].toLowerCase().contains(searchQuery);
      }).toList();
    });
  }

  void searchByBarcode(String barcode) {
    setState(() {
      filteredList = inventoryList.where((item) => item['barcode'] == barcode).toList();
    });
  }

  void sellMedicine(Map<String, dynamic> medicine) {
    if (medicine['quantity'] > 0) {
      setState(() {
        medicine['quantity'] -= 1;
      });
    }
  }

  void scanBarcode() async {
    final barcode = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BarcodeScannerScreen()),
    );

    if (barcode != null) {
      searchByBarcode(barcode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("💊 Medicine Inventory"),
        backgroundColor: Colors.teal, // هنا تغير اللون إلى Teal
        actions: [
          IconButton(
            icon: Icon(Icons.qr_code_scanner),
            onPressed: scanBarcode,
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddInventoryScreen()),
              );
            },
          ),

        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Search Medicine',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: filterSearch,
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Text("Total Items: ${filteredList.length}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Spacer(),
                Icon(Icons.inventory, color: Colors.brown[700]),
              ],
            ),
            SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final item = filteredList[index];
                  return MedicineCard(
                    item: item,
                    onSell: () => sellMedicine(item),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MedicineCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onSell;

  const MedicineCard({required this.item, required this.onSell});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.parse(item['expiry_date']));

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item['name'],
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.shade700,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text("Qty: ${item['quantity']}", style: TextStyle(color: Colors.white)),
                )
              ],
            ),
            SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.circle, size: 10, color: Colors.blue),
                SizedBox(width: 4),
                Text("${item['titer']} - ${item['type']}", style: TextStyle(fontSize: 14)),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PriceBox(
                  label: 'COST PRICE',
                  price: item['cost_price'],
                  color: Colors.red.shade100,
                  icon: Icons.monetization_on_outlined,
                  textColor: Colors.red.shade800,
                ),
                PriceBox(
                  label: 'SELLING PRICE',
                  price: item['selling_price'],
                  color: Colors.green.shade100,
                  icon: Icons.attach_money,
                  textColor: Colors.green.shade800,
                ),
              ],
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.yellow.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today_outlined, size: 18),
                  SizedBox(width: 8),
                  Text("Expires: $formattedDate"),
                ],
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: onSell,
              child: Text("Sell One"),
            )
          ],
        ),
      ),
    );
  }
}

class PriceBox extends StatelessWidget {
  final String label;
  final double price;
  final Color color;
  final IconData icon;
  final Color textColor;

  const PriceBox({
    required this.label,
    required this.price,
    required this.color,
    required this.icon,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: textColor.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: textColor),
                SizedBox(width: 6),
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            Text(
              "\$${price.toStringAsFixed(2)}",
              style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class BarcodeScannerScreen extends StatefulWidget {
  @override
  _BarcodeScannerScreenState createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  bool _isScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scan Barcode")),
      body: MobileScanner(
        onDetect: (capture) {
          if (_isScanned) return;

          final barcode = capture.barcodes.first.rawValue;
          if (barcode != null) {
            _isScanned = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pop(context, barcode);
            });
          }
        },
      ),
    );
  }
}
