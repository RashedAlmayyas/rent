import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/payment.dart';

class PaymentController extends GetxController {
  var payments = <Payment>[].obs;
  var isLoading = false.obs;

  final String baseUrl = 'https://yourapi.com/api';

  Future<void> fetchPayments(int contractId) async {
    isLoading.value = true;
    final response = await http.get(Uri.parse('$baseUrl/payments?contract_id=$contractId'));
    isLoading.value = false;

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      payments.value = data.map((json) => Payment.fromJson(json)).toList();
    }
  }

  Future<bool> makePayment(int contractId, double amount) async {
    isLoading.value = true;
    final response = await http.post(
      Uri.parse('$baseUrl/payments'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'contract_id': contractId, 'amount': amount}),
    );
    isLoading.value = false;
    return response.statusCode == 201;
  }
}
