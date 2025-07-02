import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class SalesScreen extends StatefulWidget {
  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  String searchQuery = '';
  String selectedType = 'All';
  String selectedCompany = 'All';
  String selectedDateFilter = 'All';

  final List<Map<String, String>> medicines = [
    {
      'name': 'Paracetamol',
      'type': 'Medicine',
      'company': 'Life Pharma',
      'date': '2025-06-28',
      'barcode': '1234567890'
    },
    {
      'name': 'Syringe',
      'type': 'Supplies',
      'company': 'MedSupply',
      'date': '2025-06-25',
      'barcode': '0987654321'
    },
    {
      'name': 'Ibuprofen',
      'type': 'Medicine',
      'company': 'NewPharm',
      'date': '2025-06-10',
      'barcode': '1122334455'
    },
    {
      'name': 'Bandage',
      'type': 'Supplies',
      'company': 'Life Pharma',
      'date': '2025-05-15',
      'barcode': '5566778899'
    },
  ];

  List<Map<String, String>> get filteredMedicines {
    return medicines.where((med) {
      final matchesName =
      med['name']!.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesType = selectedType == 'All' || med['type'] == selectedType;
      final matchesCompany =
          selectedCompany == 'All' || med['company'] == selectedCompany;
      final matchesDate = _filterByDate(med['date']!);
      return matchesName && matchesType && matchesCompany && matchesDate;
    }).toList();
  }

  bool _filterByDate(String dateStr) {
    if (selectedDateFilter == 'All') return true;

    final medDate = DateTime.parse(dateStr);
    final now = DateTime.now();

    switch (selectedDateFilter) {
      case 'Today':
        return medDate.day == now.day &&
            medDate.month == now.month &&
            medDate.year == now.year;
      case 'This Week':
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final endOfWeek = startOfWeek.add(Duration(days: 6));
        return medDate.isAfter(startOfWeek.subtract(Duration(days: 1))) &&
            medDate.isBefore(endOfWeek.add(Duration(days: 1)));
      case 'This Month':
        return medDate.month == now.month && medDate.year == now.year;
      default:
        return true;
    }
  }

  void _scanBarcode() async {
    final barcode = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => BarcodeScannerPage(),
      ),
    );

    if (barcode != null && barcode.isNotEmpty) {
      try {
        final matchedMedicine = medicines.firstWhere(
              (med) => med['barcode'] == barcode,
        );

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Medicine Details'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${matchedMedicine['name']}'),
                Text('Company: ${matchedMedicine['company']}'),
                Text('Type: ${matchedMedicine['type']}'),
                Text('Date Added: ${matchedMedicine['date']}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
            ],
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No matching medicine found for this barcode')),
        );
      }
    }
  }

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.text = searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_searchController.text != searchQuery) {
      _searchController.text = searchQuery;
      _searchController.selection = TextSelection.fromPosition(
        TextPosition(offset: _searchController.text.length),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Sales'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white, // ← يجعل النص أبيض
        iconTheme: IconThemeData(color: Colors.white), // ← يجعل الأيقونات بيضاء
        actions: [
          IconButton(
            icon: Icon(Icons.qr_code_scanner),
            onPressed: _scanBarcode,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Search for medicine',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (val) => setState(() {
                searchQuery = val;
              }),
              controller: _searchController,
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedType,
                    decoration: InputDecoration(labelText: 'Product Type'),
                    items: ['All', 'Medicine', 'Supplies']
                        .map((type) =>
                        DropdownMenuItem(value: type, child: Text(type)))
                        .toList(),
                    onChanged: (val) => setState(() => selectedType = val!),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedCompany,
                    decoration: InputDecoration(labelText: 'Company'),
                    items: ['All', 'Life Pharma', 'MedSupply', 'NewPharm']
                        .map((company) => DropdownMenuItem(
                        value: company, child: Text(company)))
                        .toList(),
                    onChanged: (val) => setState(() => selectedCompany = val!),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedDateFilter,
              decoration: InputDecoration(labelText: 'Date Filter'),
              items: ['All', 'Today', 'This Week', 'This Month']
                  .map((val) =>
                  DropdownMenuItem(value: val, child: Text(val)))
                  .toList(),
              onChanged: (val) => setState(() => selectedDateFilter = val!),
            ),
            SizedBox(height: 16),
            Expanded(
              child: filteredMedicines.isEmpty
                  ? Center(child: Text('No results found'))
                  : ListView.builder(
                itemCount: filteredMedicines.length,
                itemBuilder: (context, index) {
                  final med = filteredMedicines[index];
                  return Card(
                    child: ListTile(
                      title: Text(med['name']!),
                      subtitle: Text(
                          'Company: ${med['company']} - Type: ${med['type']}'),
                      trailing: Text(med['date'] ?? ''),
                    ),
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

// ✅ Barcode Scanner Page
class BarcodeScannerPage extends StatefulWidget {
  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  bool _isScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Barcode'),
        backgroundColor: Colors.teal.shade700,
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
      body: MobileScanner(
        onDetect: (barcodeCapture) {
          if (_isScanned) return;

          final List<Barcode> barcodes = barcodeCapture.barcodes;
          if (barcodes.isNotEmpty) {
            final String? code = barcodes.first.rawValue;
            if (code != null && code.isNotEmpty) {
              _isScanned = true;
              Navigator.of(context).pop(code);
            }
          }
        },
      ),
    );
  }
}
