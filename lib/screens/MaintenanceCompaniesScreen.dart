import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

class MaintenanceCompaniesScreen extends StatefulWidget {
  const MaintenanceCompaniesScreen({super.key});

  @override
  State<MaintenanceCompaniesScreen> createState() =>
      _MaintenanceCompaniesScreenState();
}

class _MaintenanceCompaniesScreenState extends State<MaintenanceCompaniesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> filteredCompanies = [];

  final List<Map<String, String>> companies = [
    {
      'name': 'شركة الراحة للصيانة',
      'location': 'عمان - الدوار السابع',
      'phone': '0791234567',
    },
    {
      'name': 'البيت المثالي للخدمات',
      'location': 'الزرقاء - شارع الجيش',
      'phone': '0787654321',
    },
    {
      'name': 'صيانة بلس',
      'location': 'إربد - الحي الجنوبي',
      'phone': '0779999988',
    },
  ];

  @override
  void initState() {
    super.initState();
    filteredCompanies = companies;
  }

  void _search() {
    final query = _searchController.text.trim();
    setState(() {
      if (query.isEmpty) {
        filteredCompanies = companies;
      } else {
        filteredCompanies = companies
            .where((company) =>
                company['name']!.contains(query) ||
                company['location']!.contains(query))
            .toList();
      }
    });
  }

  void _call(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر بدء المكالمة')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'شركات الصيانة المنزلية' : 'Maintenance Companies'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: (_) => _search(),
              decoration: InputDecoration(
                labelText: isArabic ? 'بحث عن شركة' : 'Search Company',
                prefixIcon: Icon(Iconsax.search_normal, color: theme.colorScheme.primary),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: filteredCompanies.isEmpty
                  ? Center(
                      child: Text(
                        isArabic ? 'لا توجد شركات مطابقة.' : 'No companies found.',
                        style: const TextStyle(color: Colors.red),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredCompanies.length,
                      itemBuilder: (context, index) {
                        final company = filteredCompanies[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  company['name']!,
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold),
                                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.location_on,
                                        size: 20, color: Colors.grey[700]),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        company['location']!,
                                        style: const TextStyle(fontSize: 14),
                                        textAlign: isArabic ? TextAlign.right : TextAlign.left,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: theme.colorScheme.primary,
                                                      foregroundColor: Colors.white,

                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12)),
                                  ),
                                  onPressed: () => _call(company['phone']!),
                                  icon: const Icon(Iconsax.call),
                                  label: Text(isArabic ? 'اتصال' : 'Call'),
                                ),
                              ],
                            ),
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
