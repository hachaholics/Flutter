import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/route_model.dart';

class ApiService {
  // TODO: replace with your backend base
  static const String baseUrl = 'https://bus-tracking-uuut.onrender.com';

  /// GET /api/routes/find?start=...&end=...
  /// returns the first matching RouteModel, or null if none
  static Future<RouteModel?> findRoute(String start, String end) async {
    final uri = Uri.parse('$baseUrl/api/route/find')
      .replace(queryParameters: {'start': start, 'dest': end});
    final resp = await http.get(uri);

    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      if (body is List && body.isNotEmpty) {
        return RouteModel.fromJson(body[0] as Map<String, dynamic>);
      }
      return null;
    } else {
      throw Exception('API error: ${resp.statusCode}');
    }
  }
}
