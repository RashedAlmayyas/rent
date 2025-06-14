// lib/screens/pay_rent_screen.dart
import 'package:flutter/material.dart';

class PayRentScreen extends StatefulWidget {
  const PayRentScreen({super.key});

  @override
  State<PayRentScreen> createState() => _PayRentScreenState();
}

class _PayRentScreenState extends State<PayRentScreen> {
  final _formKey = GlobalKey<FormState>();

  String contractId = '';
  String amountToPay = '';
  String paymentMethod = 'cash'; // 'cash', 'bank', 'online' مثلاً

  String _selectedLang = 'en';

  bool get isArabic => _selectedLang == 'ar';

  @override
  void initState() {
    super.initState();
    _selectedLang = 'en'; // أو استخرج اللغة من إعدادات المستخدم
  }

  void _submitPayment() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // هنا ضع منطق الدفع (مثلاً إرسال البيانات للسيرفر)

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isArabic ? 'تم دفع الإيجار بنجاح!' : 'Rent payment successful!'),
          backgroundColor: Colors.green,
        ),
      );

      // إعادة توجيه أو إعادة ضبط النموذج حسب الحاجة
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text(isArabic ? 'دفع الإيجار' : 'Pay Rent'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                _buildTextField(
                  label: isArabic ? 'رقم العقد' : 'Contract ID',
                  keyboardType: TextInputType.text,
                  onSaved: (val) => contractId = val!.trim(),
                  validator: (val) => val == null || val.isEmpty ? (isArabic ? 'هذا الحقل مطلوب' : 'Required field') : null,
                ),
                _buildTextField(
                  label: isArabic ? 'المبلغ المطلوب' : 'Amount to Pay',
                  keyboardType: TextInputType.number,
                  onSaved: (val) => amountToPay = val!.trim(),
                  validator: (val) {
                    if (val == null || val.isEmpty) return isArabic ? 'هذا الحقل مطلوب' : 'Required field';
                    if (double.tryParse(val) == null) return isArabic ? 'أدخل رقم صالح' : 'Enter a valid number';
                    return null;
                  },
                ),

                SizedBox(height: 20),

                Text(
                  isArabic ? 'طريقة الدفع' : 'Payment Method',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),

                ListTile(
                  title: Text(isArabic ? 'نقداً' : 'Cash'),
                  leading: Radio<String>(
                    value: 'cash',
                    groupValue: paymentMethod,
                    onChanged: (value) => setState(() => paymentMethod = value!),
                  ),
                ),
                ListTile(
                  title: Text(isArabic ? 'تحويل بنكي' : 'Bank Transfer'),
                  leading: Radio<String>(
                    value: 'bank',
                    groupValue: paymentMethod,
                    onChanged: (value) => setState(() => paymentMethod = value!),
                  ),
                ),
                ListTile(
                  title: Text(isArabic ? 'دفع إلكتروني' : 'Online Payment'),
                  leading: Radio<String>(
                    value: 'online',
                    groupValue: paymentMethod,
                    onChanged: (value) => setState(() => paymentMethod = value!),
                  ),
                ),

                SizedBox(height: 30),

                ElevatedButton(
                  onPressed: _submitPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(
                    isArabic ? 'ادفع الآن' : 'Pay Now',
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

  Widget _buildTextField({
    required String label,
    TextInputType keyboardType = TextInputType.text,
    required FormFieldSetter<String> onSaved,
    FormFieldValidator<String>? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
        onSaved: onSaved,
        validator: validator,
      ),
    );
  }
}
