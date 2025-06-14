import 'package:flutter/material.dart';

class RateContractScreen extends StatefulWidget {
  const RateContractScreen({super.key});

  @override
  State<RateContractScreen> createState() => _RateContractScreenState();
}

class _RateContractScreenState extends State<RateContractScreen> {
  String? selectedContract;
  double rating = 0;
  final commentController = TextEditingController();

  final List<String> contracts = [
    'عقد رقم 101 - شقة في عمان',
    'عقد رقم 102 - فيلا في الزرقاء',
    'عقد رقم 103 - مكتب في اربد',
  ];

  void submitRating() {
    if (selectedContract == null || rating == 0 || commentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى تعبئة جميع الحقول')),
      );
      return;
    }

    // يمكنك هنا إرسال التقييم إلى السيرفر
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('شكراً على تقييمك! 🌟')),
    );

    setState(() {
      selectedContract = null;
      rating = 0;
      commentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'تقييم العقد' : 'Rate Contract'),
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
                  child: Text(contract),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedContract = value;
                });
              },
            ),
            const SizedBox(height: 30),

            // تقييم النجوم
            Text(
              isArabic ? 'التقييم' : 'Rating',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 32,
                  ),
                  onPressed: () {
                    setState(() {
                      rating = index + 1.0;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 20),

            // التعليق
            TextField(
              controller: commentController,
              decoration: InputDecoration(
                labelText: isArabic ? 'أضف تعليقك' : 'Add your comment',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              maxLines: 4,
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 30),

            // زر الإرسال
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: submitRating,
                icon: const Icon(Icons.send),
                label: Text(
                  isArabic ? 'إرسال التقييم' : 'Submit Rating',
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
