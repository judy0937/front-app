import 'package:flutter/material.dart';

class ShowCompaniesScreen extends StatefulWidget {
  @override
  _ShowCompaniesScreenState createState() => _ShowCompaniesScreenState();
}

class _ShowCompaniesScreenState extends State<ShowCompaniesScreen> {
  List<String> companies = [
    'Tech Solutions Inc.',
    'Smart Code LLC',
    'Digital Future Co.',
    'Creative Softwares',
    'E-Commerce Group'
  ];

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    List<String> filteredCompanies = companies
        .where((company) => company.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Search Bar
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search companies...',
                          prefixIcon: Icon(Icons.search, color: Colors.teal),
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Title
                  Text(
                    'Companies',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade800,
                    ),
                  ),

                  SizedBox(height: 10),

                  // Companies List
                  if (filteredCompanies.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Column(
                        children: [
                          Icon(Icons.business, size: 50, color: Colors.grey.shade400),
                          SizedBox(height: 10),
                          Text(
                            'No companies found',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: filteredCompanies.length,
                      separatorBuilder: (context, index) => SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final company = filteredCompanies[index];
                        return Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            leading: Icon(Icons.business, color: Colors.teal),
                            title: Text(
                              company,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            trailing: Icon(Icons.chevron_right, color: Colors.grey),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CompanyDetailScreen(companyName: company),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),

          // Add Button
        ],
      ),
    );
  }

  void _showAddCompanyDialog(BuildContext context) {
    String newCompanyName = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Company'),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Company Name',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              newCompanyName = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              onPressed: () {
                if (newCompanyName.isNotEmpty) {
                  setState(() {
                    companies.add(newCompanyName);
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class CompanyDetailScreen extends StatelessWidget {
  final String companyName;

  const CompanyDetailScreen({required this.companyName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Company Details'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(Icons.business, size: 60, color: Colors.teal),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                companyName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 30),
            _buildDetailRow('Contact', 'John Doe', Icons.person),
            _buildDetailRow('Phone', '+1 234 567 890', Icons.phone),
            _buildDetailRow('Email', 'info@${companyName.toLowerCase().replaceAll(' ', '')}.com', Icons.email),
            _buildDetailRow('Address', '123 Business St.', Icons.location_on),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}