import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'auth_service.dart';

class ApiService {
  final AuthService _authService = AuthService();

  Future<dynamic> fetchData(String endpoint) async {
    final token = await _authService.getAccessToken();
    if (token == null) throw Exception('No access token available');

    final response = await http.get(
      Uri.parse('${dotenv.env['AUTH0_AUDIENCE']}$endpoint'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  }
}
