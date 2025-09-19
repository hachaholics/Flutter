import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import 'signup_screen.dart';
import 'start_shift_screen.dart';

class LoginScreen extends StatefulWidget {
  final String? prefillId;
  final String? prefillPassword;

  const LoginScreen({Key? key, this.prefillId, this.prefillPassword}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String _message = "";

  @override
  void initState() {
    super.initState();
    if (widget.prefillId != null) _idController.text = widget.prefillId!;
    if (widget.prefillPassword != null) _passwordController.text = widget.prefillPassword!;
  }

  Future<void> _login() async {
    final id = _idController.text.trim();
    final pass = _passwordController.text.trim();
    if (id.isEmpty || pass.isEmpty) {
      setState(() => _message = "Enter both Conductor ID and password.");
      return;
    }

    setState(() {
      _isLoading = true;
      _message = "";
    });

    final res = await AuthService.login(id, pass);

    setState(() => _isLoading = false);

    if (res['success'] == true) {
      final token = (res['token'] ?? '').toString();
      if (token.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setString('conductor_id', id);

        // go to start shift
        if (!mounted) return;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const StartShiftScreen()));
      } else {
        // login responded success but no token was returned
        setState(() => _message = "Login succeeded but server did not return a token. Check backend.");
      }
    } else {
      setState(() => _message = "Login failed: ${res['error'] ?? 'Invalid credentials'}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Conductor Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _idController,
                  decoration: const InputDecoration(labelText: "Conductor ID"),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: "Password"),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(onPressed: _login, child: const Text("Login")),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SignupScreen()));
                  },
                  child: const Text(
                    "New user? Signup here",
                    style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue),
                  ),
                ),
                const SizedBox(height: 10),
                if (_message.isNotEmpty)
                  Text(
                    _message,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}