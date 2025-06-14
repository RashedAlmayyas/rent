import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewContractScreen extends StatefulWidget {
  final String userId;

  const NewContractScreen({super.key, required this.userId});

  @override
  State<NewContractScreen> createState() => _NewContractScreenState();
}

class _NewContractScreenState extends State<NewContractScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedLang = 'en';
  String _nationalId = '';
  String _contractType = 'apartment';
  bool _isSubmitting = false;

  final Map<String, dynamic> _contractTypes = {
    'apartment': {'name_ar': 'شقة', 'name_en': 'Apartment'},
    'house': {'name_ar': 'بيت', 'name_en': 'House'},
    'warehouse': {'name_ar': 'مخزن', 'name_en': 'Warehouse'},
    'complex': {'name_ar': 'مجمع', 'name_en': 'Complex'},
  };

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _rentAmountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLang = prefs.getString('lang') ?? 'en';
    });
  }

  void _submitContract() {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isSubmitting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _selectedLang == 'ar'
                ? 'تم حفظ العقد بنجاح (محلياً)'
                : 'Contract saved successfully (locally)',
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    });
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = "${picked.toLocal()}".split(' ')[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = _selectedLang == 'ar';
    final theme = Theme.of(context);

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(isArabic ? 'عقد جديد' : 'New Contract'),
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _isSubmitting ? null : _submitContract,
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // معلومات المستأجر
                _buildCard(
                  title: isArabic ? 'معلومات المستأجر' : 'Tenant Information',
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: isArabic ? 'الرقم الوطني' : 'National ID',
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) => _nationalId = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return isArabic ? 'الرجاء إدخال الرقم الوطني' : 'Please enter the national ID';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // نوع العقد
                _buildCard(
                  title: isArabic ? 'نوع العقار' : 'Property Type',
                  child: DropdownButtonFormField<String>(
                    value: _contractType,
                    items: _contractTypes.entries.map((entry) {
                      return DropdownMenuItem<String>(
                        value: entry.key,
                        child: Text(isArabic ? entry.value['name_ar'] : entry.value['name_en']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _contractType = value!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: isArabic ? 'اختر نوع العقار' : 'Select property type',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // تفاصيل العقد
                _buildCard(
                  title: isArabic ? 'تفاصيل العقد' : 'Contract Details',
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _startDateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: isArabic ? 'تاريخ البدء' : 'Start Date',
                          suffixIcon: const Icon(Icons.calendar_today),
                          border: const OutlineInputBorder(),
                        ),
                        onTap: () => _selectDate(context, _startDateController),
                        validator: (value) =>
                            (value == null || value.isEmpty)
                                ? (isArabic ? 'يجب تحديد تاريخ البدء' : 'Start date is required')
                                : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _endDateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: isArabic ? 'تاريخ الانتهاء' : 'End Date',
                          suffixIcon: const Icon(Icons.calendar_today),
                          border: const OutlineInputBorder(),
                        ),
                        onTap: () => _selectDate(context, _endDateController),
                        validator: (value) =>
                            (value == null || value.isEmpty)
                                ? (isArabic ? 'يجب تحديد تاريخ الانتهاء' : 'End date is required')
                                : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _rentAmountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: isArabic ? 'مبلغ الإيجار' : 'Rent Amount',
                          prefixText: 'JOD ',
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return isArabic ? 'يجب إدخال مبلغ الإيجار' : 'Rent amount is required';
                          }
                          if (double.tryParse(value) == null) {
                            return isArabic ? 'يجب أن يكون المبلغ رقمًا' : 'Amount must be a number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: isArabic ? 'وصف إضافي' : 'Additional Description',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitContract,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: _isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            isArabic ? 'حفظ العقد' : 'Save Contract',
                            style: const TextStyle(fontSize: 18),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}
