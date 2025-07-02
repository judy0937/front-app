import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drug Suggestions',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const DrugSuggestionsScreen(),
    );
  }
}

class Drug {
  final String id;
  final String name;
  final String company;
  final String description;
  final String category;
  final double price;
  final String imageUrl;

  const Drug({
    required this.id,
    required this.name,
    required this.company,
    required this.description,
    required this.category,
    required this.price,
    required this.imageUrl,
  });
}

class DrugSuggestionsScreen extends StatelessWidget {
  const DrugSuggestionsScreen({super.key});

  final List<Drug> topDrugs = const [
    Drug(
      id: '1',
      name: 'Paracetamol',
      company: 'Life Pharma',
      description: 'مسكن للألم وخافض للحرارة، يستخدم لعلاج الآلام الخفيفة إلى المتوسطة والحمى.',
      category: 'مسكنات',
      price: 5.99,
      imageUrl: 'assets/paracetamol.png',
    ),
    Drug(
      id: '2',
      name: 'Amoxicillin',
      company: 'Medico',
      description: 'مضاد حيوي يستخدم لعلاج الالتهابات البكتيرية المختلفة.',
      category: 'مضادات حيوية',
      price: 12.50,
      imageUrl: 'assets/amoxicillin.png',
    ),
    Drug(
      id: '3',
      name: 'Ibuprofen',
      company: 'NewPharm',
      description: 'مضاد للالتهاب غير ستيرويدي، مسكن للألم وخافض للحرارة.',
      category: 'مسكنات',
      price: 8.75,
      imageUrl: 'assets/ibuprofen.png',
    ),
  ];

  final List<Drug> suggestedDrugs = const [
    Drug(
      id: '4',
      name: 'Cetirizine',
      company: 'AllergyRelief',
      description: 'مضاد للهيستامين يستخدم لعلاج أعراض الحساسية مثل العطس والحكة.',
      category: 'مضادات الحساسية',
      price: 7.25,
      imageUrl: 'assets/cetirizine.png',
    ),
    Drug(
      id: '5',
      name: 'Azithromycin',
      company: 'Antibio',
      description: 'مضاد حيوي واسع الطيف يستخدم لعلاج الالتهابات البكتيرية.',
      category: 'مضادات حيوية',
      price: 15.99,
      imageUrl: 'assets/azithromycin.png',
    ),
    Drug(
      id: '6',
      name: 'Omeprazole',
      company: 'StomachCare',
      description: 'مثبط لمضخة البروتون يستخدم لعلاج حرقة المعدة وقرحة المعدة.',
      category: 'معدة وجهاز هضمي',
      price: 9.50,
      imageUrl: 'assets/omeprazole.png',
    ),
    Drug(
      id: '7',
      name: 'Metformin',
      company: 'Diabetix',
      description: 'يستخدم لعلاج النوع الثاني من داء السكري.',
      category: 'أدوية السكري',
      price: 6.80,
      imageUrl: 'assets/metformin.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade700,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Recommended Drugs',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top Purchased Drugs',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 130,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: topDrugs.length,
                itemBuilder: (context, index) {
                  final drug = topDrugs[index];
                  return GestureDetector(
                    onTap: () => _showDrugDetails(context, drug),
                    child: Container(
                      width: 160,
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6A1B9A).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.purple.shade200),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.local_pharmacy, color: Colors.purple),
                          const SizedBox(height: 10),
                          Text(
                            drug.name,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            drug.company,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Suggested for You',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: suggestedDrugs.length,
                itemBuilder: (context, index) {
                  final drug = suggestedDrugs[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: const Icon(Icons.medication_outlined, color: Colors.teal),
                      title: Text(drug.name),
                      subtitle: Text('Company: ${drug.company}'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => _showDrugDetails(context, drug),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showDrugDetails(BuildContext context, Drug drug) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(Icons.medication, size: 40, color: Colors.teal),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          drug.name,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          drug.company,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),
              _buildDetailRow('Category', drug.category),
              _buildDetailRow('Price', '\$${drug.price.toStringAsFixed(2)}'),
              const SizedBox(height: 20),
              const Text(
                'Description',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                drug.description,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Close',
                    style: TextStyle(fontSize: 16),
                  ),
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}