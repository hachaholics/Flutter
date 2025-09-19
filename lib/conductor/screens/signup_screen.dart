import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'start_shift_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isLoading = false;
  String _message = "";

  Future<void> _signup() async {
    final id = _idController.text.trim();
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();

    if (id.isEmpty || name.isEmpty || phone.isEmpty) {
      setState(() => _message = "Fill all fields.");
      return;
    }

    setState(() {
      _isLoading = true;
      _message = "";
    });

    final res = await AuthService.signup(id, name, phone);

    setState(() => _isLoading = false);

    if (res['success'] == true) {
      final password = (res['password'] ?? '').toString();
      final token = (res['token'] ?? '').toString();

      // show dialog with the generated password in bold (not editable)
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Signup successful"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Your generated password is:"),
              const SizedBox(height: 8),
              SelectableText(
                password.isNotEmpty ? password : "(not returned by server)",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 12),
              const Text(
                "Please note it down. You can use it to login.",
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          actions: [
            if (token.isNotEmpty)
              TextButton(
                onPressed: () async {
                  // if backend returned a token, we can store it and go directly to StartShiftScreen
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('auth_token', token);
                  await prefs.setString('conductor_id', id);
                  if (!mounted) return;
                  Navigator.of(context).pop(); // close dialog
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const StartShiftScreen()));
                },
                child: const Text("Start shift (auto login)"),
              ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // close dialog
                // navigate to login with prefilled id & password
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LoginScreen(prefillId: id, prefillPassword: password),
                  ),
                );
              },
              child: const Text("Go to Login"),
            ),
          ],
        ),
      );
    } else {
      setState(() => _message = "Signup failed: ${res['error'] ?? 'unknown error'}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Conductor Signup")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _idController,
                decoration: const InputDecoration(labelText: "Conductor ID"),
              ),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "Phone Number"),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(onPressed: _signup, child: const Text("Signup")),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                },
                child: const Text(
                  "Already have an account? Login",
                  style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue),
                ),
              ),
              const SizedBox(height: 12),
              if (_message.isNotEmpty)
                Text(
                  _message,
                  style: const TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}