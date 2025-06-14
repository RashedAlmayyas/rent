// lib/screens/ratings_screen.dart
import 'package:flutter/material.dart';

class RatingsScreen extends StatefulWidget {
  const RatingsScreen({super.key});

  @override
  State<RatingsScreen> createState() => _RatingsScreenState();
}

class _RatingsScreenState extends State<RatingsScreen> {
  final _formKey = GlobalKey<FormState>();

  double landlordRating = 0;
  double tenantRating = 0;

  String landlordFeedback = '';
  String tenantFeedback = '';

  String _selectedLang = 'en';

  bool get isArabic => _selectedLang == 'ar';

  @override
  void initState() {
    super.initState();
    _selectedLang = 'en'; // يمكنك جلبها من إعدادات التطبيق أو المستخدم
  }

  void _submitRatings() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // هنا يمكنك إرسال التقييمات إلى الـ backend

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isArabic ? 'تم إرسال التقييم بنجاح' : 'Ratings submitted successfully'),
          backgroundColor: Colors.green,
        ),
      );

      // إعادة تعيين الحقول أو الانتقال لشاشة أخرى حسب الحاجة
    }
  }

  Widget buildStarRating({
    required double rating,
    required void Function(double) onRatingChanged,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        return IconButton(
          icon: Icon(
            starIndex <= rating ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 32,
          ),
          onPressed: () => onRatingChanged(starIndex.toDouble()),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text(isArabic ? 'تقييم الخدمة' : 'Service Ratings'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Text(
                  isArabic ? 'تقييم المؤجر' : 'Landlord Rating',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                buildStarRating(
                  rating: landlordRating,
                  onRatingChanged: (val) => setState(() => landlordRating = val),
                ),
                TextFormField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: isArabic ? 'ملاحظات المؤجر' : 'Landlord Feedback',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (val) => landlordFeedback = val?.trim() ?? '',
                  validator: (val) {
                    if (val == null || val.isEmpty) return isArabic ? 'الرجاء كتابة ملاحظات' : 'Please enter feedback';
                    return null;
                  },
                ),
                SizedBox(height: 30),
                Text(
                  isArabic ? 'تقييم المستأجر' : 'Tenant Rating',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                buildStarRating(
                  rating: tenantRating,
                  onRatingChanged: (val) => setState(() => tenantRating = val),
                ),
                TextFormField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: isArabic ? 'ملاحظات المستأجر' : 'Tenant Feedback',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (val) => tenantFeedback = val?.trim() ?? '',
                  validator: (val) {
                    if (val == null || val.isEmpty) return isArabic ? 'الرجاء كتابة ملاحظات' : 'Please enter feedback';
                    return null;
                  },
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _submitRatings,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(
                    isArabic ? 'إرسال التقييم' : 'Submit Ratings',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
