import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'MaintenanceCompaniesScreen.dart';
import 'PayRentScreen.dart';
import 'RateContractScreen.dart';
import 'SubmitComplaintScreen.dart';
import 'new_contract_screen.dart.dart';
import 'search_by_id_screen.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;

    return CustomScrollView(
      slivers: [
        // Header مع صورة الخلفية

        // محتوى الصفحة
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // بطاقات الإحصائيات
              _buildStatsCards(context, isArabic),
              const SizedBox(height: 30),

              // عناصر الوصول السريع
              Text(
                isArabic ? 'خدمات سريعة' : 'Quick Services',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildQuickServices(context, isArabic),
              const SizedBox(height: 30),

              // العقود الحديثة
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isArabic ? 'العقود الحديثة' : 'Recent Contracts',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(isArabic ? 'عرض الكل' : 'View All'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildRecentContracts(context, isArabic),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCards(BuildContext context, bool isArabic) {
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _statCard(
            context,
            value: '3',
            label: isArabic ? 'عقود نشطة' : 'Active Contracts',
            icon: Iconsax.document,
            color: Colors.blueAccent,
          ),
          const SizedBox(width: 15),
          _statCard(
            context,
            value: '250 JOD',
            label: isArabic ? 'إجمالي الدفعات' : 'Total Payments',
            icon: Iconsax.wallet_money,
            color: Colors.greenAccent,
          ),
          const SizedBox(width: 15),
          _statCard(
            context,
            value: '4.8',
            label: isArabic ? 'تقييمك' : 'Your Rating',
            icon: Iconsax.star,
            color: Colors.amber,
          ),
        ],
      ),
    );
  }

  Widget _statCard(BuildContext context, {
    required String value,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

 Widget _buildQuickServices(BuildContext context, bool isArabic) {
  return GridView.count(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    crossAxisCount: 2,
    childAspectRatio: 1.4,
    crossAxisSpacing: 15,
    mainAxisSpacing: 15,
    children: [
      _serviceCard(
        context,
        icon: Iconsax.search_normal,
        label: isArabic ? 'بحث بالهوية' : 'Search by ID',
        color: Colors.purpleAccent,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SearchByIdScreen(),
            ),
          );
        },
      ),
      _serviceCard(
        context,
        icon: Iconsax.receipt,
        label: isArabic ? 'دفع الإيجار' : 'Pay Rent',
        color: Colors.teal,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PayRentScreen(),
            ),
          );
        },
      ),
      _serviceCard(
        context,
        icon: Iconsax.document_upload,
        label: isArabic ? 'عقد جديد' : 'New Contract',
        color: Colors.blueAccent,
        onTap: () async {
          final prefs = await SharedPreferences.getInstance();
          final userId = prefs.getString('user_id') ?? '';
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewContractScreen(userId: userId),
            ),
          );
        },
      ),
      _serviceCard(
        context,
        icon: Iconsax.star,
        label: isArabic ? 'التقييم' : 'Ratings',
        color: Colors.orangeAccent,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RateContractScreen(),
            ),
          );
        },
      ),

      // ✅ بطاقة تقديم شكوى
      _serviceCard(
        context,
        icon: Iconsax.warning_2,
        label: isArabic ? 'تقديم شكوى' : 'Submit Complaint',
        color: Colors.redAccent,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SubmitComplaintScreen(),
            ),
          );
        },
      ),

      // ✅ بطاقة طلب صيانة
      _serviceCard(
        context,
        icon: Iconsax.setting_2,
        label: isArabic ? 'طلب صيانة' : 'Request Maintenance',
        color: Colors.indigo,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MaintenanceCompaniesScreen(),
            ),
          );
        },
      ),
    ],
  );
}

  Widget _serviceCard(BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color.withOpacity(0.3), color.withOpacity(0.1)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentContracts(BuildContext context, bool isArabic) {
    return Column(
      children: [
        _contractItem(
          context,
          title: isArabic ? 'فيلا ' : ' Villa',
          date: '15/06/2023',
          amount: '1,250 JOD',
          isActive: true,
        ),
        _contractItem(
          context,
          title: isArabic ? 'شقة ' : ' Apartment',
          date: '22/05/2023',
          amount: '1,000 JOD',
          isActive: true,
        ),
        _contractItem(
          context,
          title: isArabic ? 'مكتب المدينة' : 'Madinah Office',
          date: '10/03/2023',
          amount: '800 JOD',
          isActive: false,
        ),
      ],
    );
  }

  Widget _contractItem(BuildContext context, {
    required String title,
    required String date,
    required String amount,
    required bool isActive,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isActive 
                ? Colors.green.withOpacity(0.2)
                : Colors.grey.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Iconsax.document_text,
            color: isActive ? Colors.green : Colors.grey,
          ),
        ),
        title: Text(title),
        subtitle: Text(date),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              amount,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isActive 
                    ? Colors.green.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                isActive ? 'Active' : 'Expired',
                style: TextStyle(
                  color: isActive ? Colors.green : Colors.grey,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        onTap: () => Navigator.pushNamed(context, '/contract_details'),
      ),
    );
  }
}