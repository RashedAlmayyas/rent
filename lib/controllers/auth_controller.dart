import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var isLoggedIn = false.obs;
  var userData = {}.obs;

  Future<void> register(Map<String, dynamic> userData) async {
    try {
      isLoading(true);
      final response = await http.post(
        Uri.parse('https://swipup.samehgroup.com/apis/api/register.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201 && responseData['success']) {
        isLoggedIn(true);
        this.userData.value = responseData;
      } else {
        throw Exception(responseData['message'] ?? 'Registration failed');
      }
    } finally {
      isLoading(false);
    }
  }
}