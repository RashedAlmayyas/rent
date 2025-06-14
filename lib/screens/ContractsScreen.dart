import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ContractsScreen extends StatelessWidget {
  const ContractsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
   
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: _buildRecentContracts(context, isArabic),
      ),
    );
  }

  Widget _buildRecentContracts(BuildContext context, bool isArabic) {
    return Column(
      children: [
        _contractItem(
          context,
          title: isArabic ? 'فيلا فاخرة' : 'Luxury Villa',
          date: '15/06/2023',
          amount: '1,250 JOD',
          isActive: true,
          isArabic: isArabic,
        ),
        _contractItem(
          context,
          title: isArabic ? 'شقة حديثة' : 'Modern Apartment',
          date: '22/05/2023',
          amount: '1,000 JOD',
          isActive: true,
          isArabic: isArabic,
        ),
        _contractItem(
          context,
          title: isArabic ? 'مكتب المدينة' : 'City Office',
          date: '10/03/2023',
          amount: '800 JOD',
          isActive: false,
          isArabic: isArabic,
        ),
      ],
    );
  }

  Widget _contractItem(
    BuildContext context, {
    required String title,
    required String date,
    required String amount,
    required bool isActive,
    required bool isArabic,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment:
              isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Iconsax.document,
                color: isActive ? Colors.green : Colors.grey,
              ),
              title: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: isArabic ? TextAlign.right : TextAlign.left,
              ),
              subtitle: Column(
                crossAxisAlignment: isArabic
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text('${isArabic ? 'التاريخ' : 'Date'}: $date'),
                  Text('${isArabic ? 'القيمة' : 'Amount'}: $amount'),
                  Text(
                    isActive
                        ? (isArabic ? 'نشط' : 'Active')
                        : (isArabic ? 'منتهي' : 'Expired'),
                    style: TextStyle(
                      color: isActive ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment:
                  isArabic ? Alignment.centerRight : Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () {
                  // TODO: تنفيذ عملية التنزيل
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          isArabic ? 'جاري تنزيل العقد...' : 'Downloading contract...'),
                    ),
                  );
                },
                icon: const Icon(Icons.download_rounded, color: Colors.blue),
                label: Text(
                  isArabic ? 'تنزيل العقد' : 'Download Contract',
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
