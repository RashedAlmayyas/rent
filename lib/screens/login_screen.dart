import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../controllers/auth_controller.dart';
import 'home_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController _authController = Get.put(AuthController());
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _selectedLang = 'en';
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLang = prefs.getString('lang') ?? 'en';
    });
  }

  Future<void> _login() async {
    String phone = _phoneController.text.trim();
    String password = _passwordController.text.trim();

    if (phone.isEmpty || password.isEmpty) {
      Get.snackbar(
        _selectedLang == 'ar' ? 'خطأ' : 'Error',
        _selectedLang == 'ar' ? 'الرجاء تعبئة جميع الحقول' : 'Please fill all fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://swipup.samehgroup.com/apis/api/login.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phone': phone,
          'password': password,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success']) {
        // حفظ بيانات المستخدم في SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', responseData['token']);
        await prefs.setString('user_id', responseData['user_id'].toString());
        await prefs.setString('full_name', responseData['full_name']);
        await prefs.setString('lang', _selectedLang);

        // انتقل إلى الشاشة الرئيسية
        Get.offAll(() => const HomeScreen());

        Get.snackbar(
          _selectedLang == 'ar' ? 'نجاح' : 'Success',
          _selectedLang == 'ar' ? 'تم تسجيل الدخول بنجاح' : 'Logged in successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        String errorMessage = responseData['message'] ??
            (_selectedLang == 'ar' ? 'بيانات الدخول غير صحيحة' : 'Invalid login credentials');

        Get.snackbar(
          _selectedLang == 'ar' ? 'خطأ' : 'Error',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        _selectedLang == 'ar' ? 'خطأ' : 'Error',
        '${_selectedLang == 'ar' ? 'تفاصيل الخطأ:' : 'Error details:'} ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
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
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color.fromARGB(255, 255, 255, 255), Color.fromARGB(255, 255, 255, 255)],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
             
                   child: Image.asset(
  'assets/images/logo.jpg',  // مسار الصورة التي اخترتها
  width: 200,
  height: 200,
  fit: BoxFit.contain,
),

                  ),
                  const SizedBox(height: 30),

                  Text(
                    isArabic ? 'تسجيل الدخول' : 'Login',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    isArabic ? 'مرحباً بعودتك!' : 'Welcome back!',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 40),

                  _buildPhoneField(
                    context,
                    controller: _phoneController,
                    isArabic: isArabic,
                    label: isArabic ? 'رقم الهاتف' : 'Phone Number',
                    hint: isArabic ? 'أدخل رقم هاتفك' : 'Enter your phone number',
                  ),
                  const SizedBox(height: 20),

                  _buildPasswordField(
                    context,
                    controller: _passwordController,
                    isArabic: isArabic,
                    obscureText: _obscurePassword,
                    onToggleVisibility: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  const SizedBox(height: 10),

                  Align(
                    alignment: isArabic ? Alignment.centerLeft : Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // TODO: إضافة شاشة استعادة كلمة المرور
                      },
                      child: Text(
                        isArabic ? 'هل نسيت كلمة المرور؟' : 'Forgot Password?',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  Obx(() => SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _authController.isLoading.value ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        shadowColor: theme.colorScheme.primary.withOpacity(0.3),
                      ),
                      child: _authController.isLoading.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              isArabic ? 'تسجيل الدخول' : 'Login',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  )),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey[300])),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          isArabic ? 'أو' : 'OR',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey[300])),
                    ],
                  ),
                  const SizedBox(height: 20),

                  TextButton(
                    onPressed: () {
                      Get.offAll(() => const SignUpScreen());
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.primary,
                    ),
                    child: RichText(
                      text: TextSpan(
                        text: isArabic ? 'ليس لديك حساب؟ ' : 'Don\'t have an account? ',
                        style: TextStyle(color: Colors.grey[700]),
                        children: [
                          TextSpan(
                            text: isArabic ? 'أنشئ حساباً' : 'Sign up',
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneField(
    BuildContext context, {
    required TextEditingController controller,
    required bool isArabic,
    required String label,
    required String hint,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      maxLength: 9,
      decoration: InputDecoration(
        counterText: '',
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
              const Icon(Icons.phone, size: 20, color: Colors.grey),
              const SizedBox(width: 10),
              Container(
                width: 1,
                height: 20,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
    );
  }

  Widget _buildPasswordField(
    BuildContext context, {
    required TextEditingController controller,
    required bool isArabic,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: isArabic ? 'كلمة المرور' : 'Password',
        hintText: isArabic ? 'أدخل كلمة المرور' : 'Enter your password',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: onToggleVisibility,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
    );
  }
}
