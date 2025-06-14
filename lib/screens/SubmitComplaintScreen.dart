import 'package:flutter/material.dart';

class SubmitComplaintScreen extends StatefulWidget {
  const SubmitComplaintScreen({super.key});

  @override
  State<SubmitComplaintScreen> createState() => _SubmitComplaintScreenState();
}

class _SubmitComplaintScreenState extends State<SubmitComplaintScreen> {
  String? selectedContract;
  final complaintController = TextEditingController();

  final List<String> contracts = [
    'عقد رقم 101 - شقة في عمان',
    'عقد رقم 102 - فيلا في الزرقاء',
    'عقد رقم 103 - مكتب في اربد',
  ];

  void submitComplaint() {
    if (selectedContract == null || complaintController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى تعبئة جميع الحقول')),
      );
      return;
    }

    // هنا يمكنك إرسال الشكوى إلى السيرفر أو تخزينها
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم إرسال الشكوى بنجاح ✅')),
    );

    setState(() {
      selectedContract = null;
      complaintController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'تقديم شكوى' : 'Submit Complaint'),
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: isArabic ? 'اختر العقد' : 'Select Contract',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              value: selectedContract,
              items: contracts.map((contract) {
                return DropdownMenuItem(
                  value: contract,
                  child: Text(contract, textAlign: isArabic ? TextAlign.right : TextAlign.left),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedContract = value;
                });
              },
            ),
            const SizedBox(height: 30),

            TextField(
              controller: complaintController,
              decoration: InputDecoration(
                labelText: isArabic ? 'نص الشكوى' : 'Complaint Text',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              maxLines: 5,
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: submitComplaint,
                icon: const Icon(Icons.send),
                label: Text(
                  isArabic ? 'إرسال الشكوى' : 'Submit Complaint',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
