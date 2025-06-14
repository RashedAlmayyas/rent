import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchController extends GetxController {
  var isLoading = false.obs;
  var searchResults = <dynamic>[].obs; // يمكن تعديل النوع حسب بياناتك
  var query = ''.obs;

  final String baseUrl = 'https://yourapi.com/api';

  // دالة البحث بالاستعلام query
  Future<void> search(String queryText) async {
    query.value = queryText.trim();
    if (query.value.isEmpty) {
      searchResults.clear();
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search?query=${Uri.encodeComponent(query.value)}'),
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        // افترضنا أن البيانات قائمة، يمكن تعديل حسب هيكل بياناتك
        searchResults.value = data;
      } else {
        // إذا كانت هناك مشكلة في الاستجابة
        searchResults.clear();
        Get.snackbar('خطأ', 'فشل في جلب النتائج');
      }
    } catch (e) {
      searchResults.clear();
      Get.snackbar('خطأ', 'حدث خطأ أثناء البحث');
    } finally {
      isLoading.value = false;
    }
  }
}
