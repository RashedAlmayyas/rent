import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../controllers/auth_controller.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthController _authController = Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();
  String _selectedLang = 'ar';
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _nationalIdController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cliqPhoneController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String _identityType = 'username'; // 'username' or 'phone'

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLang = prefs.getString('lang') ?? 'ar';
    });
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    var userData = {
      'full_name': _fullNameController.text.trim(),
      'national_id': _nationalIdController.text.trim(),
      'phone': _phoneController.text.trim(),
      'password': _passwordController.text.trim(),
    };

    if (_identityType == 'username') {
      userData['username'] = _usernameController.text.trim();
    } else {
      userData['cliq_phone'] = _cliqPhoneController.text.trim();
    }

    try {
      final response = await http.post(
        Uri.parse('https://swipup.samehgroup.com/apis/api/register.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201 && responseData['success']) {
        Get.offAll(() => const LoginScreen());
        Get.snackbar(
          _selectedLang == 'ar' ? 'نجاح' : 'Success',
          _selectedLang == 'ar' ? 'تم إنشاء الحساب بنجاح' : 'Account created successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } else {
        String errorMessage = responseData['message'] ?? 
          (_selectedLang == 'ar' ? 'حدث خطأ أثناء التسجيل' : 'Registration error');
        
        if (responseData.containsKey('error')) {
  if (responseData['error'] == 'Phone exists') {
    errorMessage = _selectedLang == 'ar' ? 'رقم الهاتف مسجل مسبقاً' : 'Phone number already exists';
  } else if (responseData['error'] == 'Username exists') {
    errorMessage = _selectedLang == 'ar' ? 'اسم المستخدم موجود مسبقاً' : 'Username already exists';
  } else if (responseData['error'] == 'National ID exists') {
    errorMessage = _selectedLang == 'ar' ? 'الرقم الوطني مسجل مسبقاً' : 'National ID already exists';
  } else if (responseData['error'] == 'Cliq phone exists') {
    errorMessage = _selectedLang == 'ar' ? 'رقم CLIQ مسجل مسبقاً' : 'CLIQ phone already exists';
  }
}


        Get.snackbar(
          _selectedLang == 'ar' ? 'خطأ' : 'Error',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
  } catch (e) {
  Get.snackbar(
    _selectedLang == 'ar' ? 'خطأ' : 'Error',
    '${_selectedLang == 'ar' ? 'تفاصيل الخطأ:' : 'Error details:'} ${e.toString()}',
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.red,
    colorText: Colors.white,
    duration: const Duration(seconds: 5),
  );
}

  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = _selectedLang == 'ar';
    final theme = Theme.of(context);

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 255, 255, 255), Color.fromARGB(255, 255, 255, 255)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.person_add_alt, size: 50, color: theme.colorScheme.primary),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      isArabic ? 'إنشاء حساب' : 'Create Account',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      isArabic ? 'املأ المعلومات لإنشاء حساب جديد' : 'Fill in the info to create an account',
                      style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 30),

                    _buildTextField(
                      controller: _fullNameController,
                      label: isArabic ? 'الاسم الكامل' : 'Full Name',
                      hint: isArabic ? 'أدخل اسمك الكامل' : 'Enter your full name',
                      icon: Icons.person_outline,
                      isArabic: isArabic,
                      validator: (val) => val!.isEmpty ? (isArabic ? 'الرجاء إدخال الاسم' : 'Enter your name') : null,
                    ),
                    const SizedBox(height: 15),

                    _buildTextField(
                      controller: _nationalIdController,
                      label: isArabic ? 'الرقم الوطني' : 'National ID',
                      hint: isArabic ? 'أدخل الرقم الوطني' : 'Enter national ID',
                      icon: Icons.badge_outlined,
                      isArabic: isArabic,
                      keyboardType: TextInputType.number,
                      validator: (val) => val!.isEmpty ? (isArabic ? 'الرجاء إدخال الرقم الوطني' : 'Enter National ID') : null,
                    ),
                    const SizedBox(height: 15),

                    _buildPhoneField(
                      controller: _phoneController,
                      isArabic: isArabic,
                      label: isArabic ? 'رقم الهاتف' : 'Phone Number',
                      hint: isArabic ? '79xxxxxxx' : '79xxxxxxx',
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return isArabic ? 'هذا الحقل مطلوب' : 'This field is required';
                        }
                        final phoneRegex = RegExp(r'^7\d{8}$');
                        if (!phoneRegex.hasMatch(val)) {
                          return isArabic ? 'أدخل رقم هاتف صحيح (9 أرقام يبدأ بـ 7)' : 'Enter a valid 9-digit phone number starting with 7';
                        }
                        return null;
                      },
                    ),
                 
                    const SizedBox(height: 15),

                    _buildTextField(
                      controller: _passwordController,
                      label: isArabic ? 'كلمة المرور' : 'Password',
                      hint: isArabic ? 'أدخل كلمة المرور' : 'Enter password',
                      icon: Icons.lock_outline,
                      isArabic: isArabic,
                      obscureText: _obscurePassword,
                      toggleVisibility: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                      validator: (val) => val!.length < 6
                          ? (isArabic ? 'يجب أن تكون كلمة المرور 6 أحرف على الأقل' : 'Password must be at least 6 characters')
                          : null,
                    ),
                    const SizedBox(height: 15),

                    _buildTextField(
                      controller: _confirmPasswordController,
                      label: isArabic ? 'تأكيد كلمة المرور' : 'Confirm Password',
                      hint: isArabic ? 'أعد كتابة كلمة المرور' : 'Re-enter password',
                      icon: Icons.lock_outline,
                      isArabic: isArabic,
                      obscureText: _obscureConfirm,
                      toggleVisibility: () {
                        setState(() => _obscureConfirm = !_obscureConfirm);
                      },
                      validator: (val) => val != _passwordController.text
                          ? (isArabic ? 'كلمتا المرور غير متطابقتين' : 'Passwords do not match')
                          : null,
                    ),
                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Obx(() => ElevatedButton(
                        onPressed: _authController.isLoading.value ? null : _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _authController.isLoading.value
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(isArabic ? 'إنشاء حساب' : 'Create Account'),
                      )),
                    ),
                    const SizedBox(height: 15),

                    TextButton(
                      onPressed: () {
                        Get.offAll(() => const LoginScreen());
                      },
                      child: Text(isArabic ? 'لديك حساب بالفعل؟ تسجيل الدخول' : 'Already have an account? Login'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool isArabic,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    VoidCallback? toggleVisibility,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        suffixIcon: toggleVisibility != null
            ? IconButton(
                icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
                onPressed: toggleVisibility,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildPhoneField({
    required TextEditingController controller,
    required bool isArabic,
    required String label,
    required String hint,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      maxLength: 9,
      validator: validator,
      decoration: InputDecoration(
        counterText: '',
        filled: true,
        fillColor: Colors.white,
        labelText: label,
        hintText: hint,
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isArabic ? '+962' : '+962',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 5),
              const Icon(Icons.phone, size: 20),
            ],
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required String value,
    required List<DropdownMenuItem<String>> items,
    required void Function(String?)? onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}