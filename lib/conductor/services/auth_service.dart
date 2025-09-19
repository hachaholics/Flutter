import 'dart:convert';
import 'package:http/http.dart' as http;

class Config {
  // 🔹 Your Render API Base URL
  static const String apiBaseUrl = "https://bus-tracking-uuut.onrender.com/api";
}

class AuthService {
  /// LOGIN
  static Future<Map<String, dynamic>> login(String conductorId, String password) async {
    final url = Uri.parse("${Config.apiBaseUrl}/auth/login");

    try {
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"conductorId": conductorId, "password": password}),
      );

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        return {
          "success": true,
          "token": body["token"],
          "conductor": body["conductor"],
        };
      } else {
        return {"success": false, "error": res.body};
      }
    } catch (e) {
      return {"success": false, "error": e.toString()};
    }
  }

  /// SIGNUP
  static Future<Map<String, dynamic>> signup(
      String conductorId, String name, String phone) async {
    final url = Uri.parse("${Config.apiBaseUrl}/auth/signup");

    try {
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "conductorId": conductorId,
          "name": name,
          "phone": phone,
        }),
      );

      if (res.statusCode == 201) {
        final body = jsonDecode(res.body);
        return {
          "success": true,
          "password": body["password"], // 🔹 API generates password
        };
      } else {
        return {"success": false, "error": res.body};
      }
    } catch (e) {
      return {"success": false, "error": e.toString()};
    }
  }

  /// START SHIFT
  static Future<Map<String, dynamic>> startShift(String token, String busNo) async {
    final url = Uri.parse("${Config.apiBaseUrl}/status/start-shift");

    try {
      final res = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"busNo": busNo}),
      );

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        return {"success": true, "status": body["status"]};
      } else {
        return {"success": false, "error": res.body};
      }
    } catch (e) {
      return {"success": false, "error": e.toString()};
    }
  }

  /// UPDATE STATUS
  static Future<Map<String, dynamic>> updateStatus(String token, String status) async {
    final url = Uri.parse("${Config.apiBaseUrl}/status/status"); // ✅ fixed

    try {
      final res = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"status": status}),
      );

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        return {"success": true, "status": body["status"]};
      } else {
        return {"success": false, "error": res.body};
      }
    } catch (e) {
      return {"success": false, "error": e.toString()};
    }
  }

  /// END SHIFT
  static Future<Map<String, dynamic>> endShift(String token) async {
    final url = Uri.parse("${Config.apiBaseUrl}/status/end-shift");

    try {
      final res = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (res.statusCode == 200) {
        return {"success": true};
      } else {
        return {"success": false, "error": res.body};
      }
    } catch (e) {
      return {"success": false, "error": e.toString()};
    }
  }
}