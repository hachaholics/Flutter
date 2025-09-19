import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class StatusService {
  static String _authHeaderFromToken(String token) {
    if (token.trim().isEmpty) return '';
    return token.startsWith('Bearer ') ? token : 'Bearer $token';
  }

  static Future<Map<String, dynamic>> startShift(String token, String busNo) async {
    final url = Uri.parse("${Config.apiBaseUrl}/status/start-shift");
    try {
      final res = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authHeaderFromToken(token),
        },
        body: jsonEncode({"busNo": busNo}),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        dynamic body;
        try {
          body = res.body.isNotEmpty ? jsonDecode(res.body) : {};
        } catch (_) {
          body = {};
        }
        return {"success": true, "body": body};
      } else {
        return {"success": false, "error": res.body};
      }
    } catch (e) {
      return {"success": false, "error": e.toString()};
    }
  }

  static Future<Map<String, dynamic>> updateStatus(String token, String status) async {
    final url = Uri.parse("${Config.apiBaseUrl}/status/status");
    try {
      final res = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authHeaderFromToken(token),
        },
        body: jsonEncode({"status": status}),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        dynamic body;
        try {
          body = res.body.isNotEmpty ? jsonDecode(res.body) : {};
        } catch (_) {
          body = {};
        }
        return {"success": true, "body": body};
      } else {
        return {"success": false, "error": res.body};
      }
    } catch (e) {
      return {"success": false, "error": e.toString()};
    }
  }

  static Future<Map<String, dynamic>> endShift(String token) async {
    final url = Uri.parse("${Config.apiBaseUrl}/status/end-shift");
    try {
      final res = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": _authHeaderFromToken(token),
        },
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        dynamic body;
        try {
          body = res.body.isNotEmpty ? jsonDecode(res.body) : {};
        } catch (_) {
          body = {};
        }
        return {"success": true, "body": body};
      } else {
        return {"success": false, "error": res.body};
      }
    } catch (e) {
      return {"success": false, "error": e.toString()};
    }
  }
}