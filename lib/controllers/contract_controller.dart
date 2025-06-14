import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/contract.dart';

class ContractController extends GetxController {
  var contracts = <Contract>[].obs;
  var isLoading = false.obs;

  final String baseUrl = 'https://yourapi.com/api';

  Future<void> fetchContracts(int userId) async {
    isLoading.value = true;
    final response = await http.get(Uri.parse('$baseUrl/contracts?user_id=$userId'));
    isLoading.value = false;

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      contracts.value = data.map((json) => Contract.fromJson(json)).toList();
    }
  }

  Future<bool> createContract({
    required int landlordId,
    required int tenantId,
    required String startDate,
    required String endDate,
    required double rentAmount,
  }) async {
    isLoading.value = true;
    final response = await http.post(
      Uri.parse('$baseUrl/contracts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'landlord_id': landlordId,
        'tenant_id': tenantId,
        'start_date': startDate,
        'end_date': endDate,
        'rent_amount': rentAmount,
      }),
    );
    isLoading.value = false;
    return response.statusCode == 201;
  }
}
