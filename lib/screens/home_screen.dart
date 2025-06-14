import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Dashboard_screen.dart';
import 'Profile_screen.dart';
import 'contractsscreen.dart';
import 'paymentsscreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedLang = 'en';
  String _userName = 'User';
  int _currentIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _loadPreferences();

    _pages = const [
      DashboardPage(),       // 0 - الرئيسية
      ContractsScreen(),     // 1 - العقود
      PaymentsScreen(),      // 2 - الدفعات
      ProfilePage(),         // 3 - الملف الشخصي
    ];
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLang = prefs.getString('lang') ?? 'en';
      _userName = prefs.getString('full_name') ?? 'User';
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = _selectedLang == 'ar';
    final theme = Theme.of(context);

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _currentIndex == 0
                ? _userName
                : _currentIndex == 1
                    ? (isArabic ? 'العقود' : 'Contracts')
                    : _currentIndex == 2
                        ? (isArabic ? 'الدفعات' : 'Payments')
                        : (isArabic ? 'الملف الشخصي' : 'Profile'),
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: theme.colorScheme.primary,
          actions: _currentIndex == 0
              ? [
                  IconButton(
                    icon: const Icon(Icons.notifications, color: Colors.white),
                    onPressed: () => Navigator.pushNamed(context, '/notifications'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.white),
                    onPressed: () => _logout(context),
                  ),
                ]
              : null,
        ),
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: theme.colorScheme.primary,
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: isArabic ? 'الرئيسية' : 'Home',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.assignment),
              label: isArabic ? 'العقود' : 'Contracts',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.payment),
              label: isArabic ? 'الدفعات' : 'Payments',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              label: isArabic ? 'الملف' : 'Profile',
            ),
          ],
        ),
        floatingActionButton: _currentIndex == 1
            ? FloatingActionButton(
                onPressed: () => Navigator.pushNamed(context, '/new_contract'),
                backgroundColor: theme.colorScheme.primary,
                child: const Icon(Icons.add, color: Colors.white),
              )
            : null,
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/login');
  }
}
