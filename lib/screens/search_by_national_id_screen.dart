// lib/screens/search_by_national_id_screen.dart
import 'package:flutter/material.dart';

class SearchByNationalIdScreen extends StatefulWidget {
  const SearchByNationalIdScreen({super.key});

  @override
  State<SearchByNationalIdScreen> createState() => _SearchByNationalIdScreenState();
}

class _SearchByNationalIdScreenState extends State<SearchByNationalIdScreen> {
  final TextEditingController _nationalIdController = TextEditingController();

  Map<String, dynamic>? _userData;
  bool _loading = false;
  String? _error;

  String _selectedLang = 'en';
  bool get isArabic => _selectedLang == 'ar';

  void _search() async {
    final id = _nationalIdController.text.trim();
    if (id.isEmpty) {
      setState(() {
        _error = isArabic ? 'الرجاء إدخال الرقم الوطني' : 'Please enter National ID';
        _userData = null;
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
      _userData = null;
    });

    // هنا مكان تنفيذ طلب البحث عبر API أو قاعدة البيانات
    await Future.delayed(const Duration(seconds: 1)); // محاكاة انتظار

    // نموذج بيانات وهمي للعرض (استبدلها ببيانات حقيقية من قاعدة البيانات)
    if (id == '1234567890') {
      setState(() {
        _userData = {
          'name': isArabic ? 'أحمد علي' : 'Ahmed Ali',
          'role': 'Tenant',
          'nationalId': id,
          'rating': 4.5,
          'feedbacks': [
            isArabic ? 'مستأجر ملتزم وملتزم بدفع الإيجار' : 'Responsible tenant, pays rent on time',
            isArabic ? 'تعامل ممتاز' : 'Excellent behavior',
          ],
        };
        _loading = false;
      });
    } else {
      setState(() {
        _error = isArabic ? 'لم يتم العثور على مستخدم بهذا الرقم الوطني' : 'No user found with this National ID';
        _loading = false;
      });
    }
  }

  Widget _buildUserInfo() {
    if (_userData == null) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.only(top: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              '${isArabic ? 'الاسم' : 'Name'}: ${_userData!['name']}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '${isArabic ? 'الدور' : 'Role'}: ${_userData!['role']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              '${isArabic ? 'الرقم الوطني' : 'National ID'}: ${_userData!['nationalId']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Text(
                  isArabic ? 'التقييم:' : 'Rating:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Icon(Icons.star, color: Colors.amber),
                Text(
                  '${_userData!['rating']}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              isArabic ? 'الملاحظات:' : 'Feedbacks:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ...(_userData!['feedbacks'] as List<String>).map(
              (fb) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text('- $fb', style: TextStyle(fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nationalIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(isArabic ? 'البحث بالرقم الوطني' : 'Search by National ID'),
          backgroundColor: Colors.teal,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
                isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nationalIdController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: isArabic ? 'الرقم الوطني' : 'National ID',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loading ? null : _search,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  isArabic ? 'بحث' : 'Search',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 20),
              if (_loading)
                Center(child: CircularProgressIndicator()),
              if (_error != null)
                Text(
                  _error!,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                ),
              _buildUserInfo(),
            ],
          ),
        ),
      ),
    );
  }
}
