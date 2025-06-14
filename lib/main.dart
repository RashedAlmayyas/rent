import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SafeRent',
      debugShowCheckedModeBanner: false,
      locale: Locale('en'), // يمكن تغييره حسب لغة المستخدم
      home: SplashScreen(),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white, // خلفية بيضاء
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.lightBlue,
          primary: Colors.lightBlue,       // أزرق فاتح
          secondary: Color(0xFFFFD700),    // ذهبي
        ),
        useMaterial3: true,
      ),
    );
  }
}
