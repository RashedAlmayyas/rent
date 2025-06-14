import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;

    final List<Map<String, String>> payments = [
      {
        'contract': isArabic ? 'عقد رقم 101 - فيلا فاخرة' : 'Contract 101 - Luxury Villa',
        'amount': '1,250 JOD',
        'date': '01/06/2024',
      },
      {
        'contract': isArabic ? 'عقد رقم 102 - شقة' : 'Contract 102 - Apartment',
        'amount': '1,000 JOD',
        'date': '15/05/2024',
      },
      {
        'contract': isArabic ? 'عقد رقم 103 - مكتب' : 'Contract 103 - Office',
        'amount': '800 JOD',
        'date': '28/04/2024',
      },
    ];

    return Scaffold(
 
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: payments.length,
        itemBuilder: (context, index) {
          final payment = payments[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 15),
            child: ListTile(
              contentPadding: const EdgeInsets.all(15),
              leading: Icon(Iconsax.wallet_check, color: Colors.green[700]),
              title: Text(
                payment['contract']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: isArabic ? TextAlign.right : TextAlign.left,
              ),
              subtitle: Column(
                crossAxisAlignment:
                    isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Text(
                    '${isArabic ? 'القيمة المدفوعة' : 'Amount Paid'}: ${payment['amount']}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    '${isArabic ? 'تاريخ الدفع' : 'Payment Date'}: ${payment['date']}',
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
