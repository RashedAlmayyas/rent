import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SearchByIdScreen extends StatefulWidget {
  const SearchByIdScreen({super.key});

  @override
  State<SearchByIdScreen> createState() => _SearchByIdScreenState();
}

class _SearchByIdScreenState extends State<SearchByIdScreen> {
  final TextEditingController _idController = TextEditingController();
  Map<String, dynamic>? result;

  final dummyData = {
    '123456789': {
      'name': 'محمد أحمد',
      'rating': 4.5,
      'comments': [
        'خدمة ممتازة وسريعة.',
        'مستأجر موثوق جدًا.',
        'دائم الالتزام بالمواعيد.',
      ]
    },
    '987654321': {
      'name': 'سارة خالد',
      'rating': 3.8,
      'comments': [
        'جيدة لكنها تأخرت في الدفع مرة.',
        'تواصل ممتاز.',
        'إيجار مستقر.',
      ]
    },
  };

  void _search() {
    final id = _idController.text.trim();
    if (dummyData.containsKey(id)) {
      setState(() {
        result = dummyData[id];
      });
    } else {
      setState(() {
        result = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'بحث بالهوية' : 'Search by ID'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _idController,
              decoration: InputDecoration(
                labelText: isArabic ? 'الرقم الوطني' : 'National ID',
                prefixIcon: Icon(Iconsax.search_normal, color: theme.colorScheme.primary),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
              keyboardType: TextInputType.number,
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _search,
                icon: const Icon(Iconsax.search_normal, size: 20),
                label: Text(
                  isArabic ? 'بحث' : 'Search',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 25),
            if (result != null)
              _buildResultCard(result!, isArabic)
            else if (_idController.text.isNotEmpty)
              Text(
                isArabic ? 'لا توجد نتائج.' : 'No results found.',
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(Map<String, dynamic> data, bool isArabic) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              isArabic ? 'الاسم: ${data['name']}' : 'Name: ${data['name']}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  isArabic ? 'التقييم:' : 'Rating:',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 10),
                _buildStars(data['rating']),
                const SizedBox(width: 5),
                Text('(${data['rating']})', style: const TextStyle(fontSize: 14)),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              isArabic ? 'التعليقات:' : 'Comments:',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ...List.generate(data['comments'].length, (i) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.comment, size: 20, color: Colors.lightBlue),
                title: Text(
                  data['comments'][i],
                  style: const TextStyle(fontSize: 14),
                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildStars(double rating) {
    int fullStars = rating.floor();
    bool halfStar = (rating - fullStars) >= 0.5;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        if (i < fullStars) {
          return const Icon(Icons.star, color: Color(0xFFFFD700), size: 20);
        } else if (i == fullStars && halfStar) {
          return const Icon(Icons.star_half, color: Color(0xFFFFD700), size: 20);
        } else {
          return const Icon(Icons.star_border, color: Color(0xFFFFD700), size: 20);
        }
      }),
    );
  }
}
