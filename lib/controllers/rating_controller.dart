import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/rating.dart';

class RatingController extends GetxController {
  var ratings = <Rating>[].obs;
  var isLoading = false.obs;

  final String baseUrl = 'https://yourapi.com/api';

  Future<void> fetchRatings(int contractId) async {
    isLoading.value = true;
    final response = await http.get(Uri.parse('$baseUrl/ratings?contract_id=$contractId'));
    isLoading.value = false;

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      ratings.value = data.map((json) => Rating.fromJson(json)).toList();
    }
  }

  Future<bool> rateContract({
    required int contractId,
    required int raterId,
    required int rateeId,
    required int ratingValue,
    required String comment,
  }) async {
    isLoading.value = true;
    final response = await http.post(
      Uri.parse('$baseUrl/ratings'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contract_id': contractId,
        'rater_id': raterId,
        'ratee_id': rateeId,
        'rating_value': ratingValue,
        'comment': comment,
      }),
    );
    isLoading.value = false;
    return response.statusCode == 201;
  }
}
