
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;
    final theme = Theme.of(context);
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(
          child: Column(
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/profile.png'),
              ),
              const SizedBox(height: 10),
              Text(
                'محمود الغويري ',
                style: theme.textTheme.titleLarge,
              ),
            
            ],
          ),
        ),
        const SizedBox(height: 20),
        _profileMenuItem(
          context,
          icon: Icons.edit,
          label: isArabic ? 'تعديل الملف الشخصي' : 'Edit Profile',
          onTap: () => Navigator.pushNamed(context, '/edit_profile'),
        ),
        _profileMenuItem(
          context,
          icon: Icons.language,
          label: isArabic ? 'تغيير اللغة' : 'Change Language',
          onTap: () => Navigator.pushNamed(context, '/language'),
        ),
        _profileMenuItem(
          context,
          icon: Icons.security,
          label: isArabic ? 'الأمان' : 'Security',
          onTap: () => Navigator.pushNamed(context, '/security'),
        ),
        _profileMenuItem(
          context,
          icon: Icons.help_center,
          label: isArabic ? 'المساعدة والدعم' : 'Help & Support',
          onTap: () => Navigator.pushNamed(context, '/help'),
        ),
      ],
    );
  }

  Widget _profileMenuItem(BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(label),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}