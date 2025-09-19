import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/status_service.dart';
import 'status_screen.dart';
import 'login_screen.dart';

class StartShiftScreen extends StatefulWidget {
  const StartShiftScreen({Key? key}) : super(key: key);

  @override
  _StartShiftScreenState createState() => _StartShiftScreenState();
}

class _StartShiftScreenState extends State<StartShiftScreen> {
  final _busController = TextEditingController();
  bool _isLoading = false;
  String _message = "";
  String _conductorId = "";

  @override
  void initState() {
    super.initState();
    _loadConductor();
  }

  Future<void> _loadConductor() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _conductorId = prefs.getString('conductor_id') ?? '');
  }

  Future<void> _startShift() async {
    final busNo = _busController.text.trim();
    if (busNo.isEmpty) {
      setState(() => _message = "Enter bus number.");
      return;
    }

    setState(() {
      _isLoading = true;
      _message = "";
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    if (token.isEmpty) {
      setState(() {
        _isLoading = false;
        _message = "Not authenticated. Please login.";
      });
      return;
    }

    final res = await StatusService.startShift(token, busNo);

    setState(() => _isLoading = false);

    if (res['success'] == true) {
      // navigate to status screen
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const StatusScreen()));
    } else {
      setState(() => _message = "Start shift failed: ${res['error'] ?? 'unknown error'}");
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('conductor_id');
    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Start Shift"),
        actions: [
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout), tooltip: 'Logout'),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text("Conductor: $_conductorId"),
                const SizedBox(height: 12),
                TextField(
                  controller: _busController,
                  decoration: const InputDecoration(labelText: "Bus Number (e.g. TS01AB0001)"),
                ),
                const SizedBox(height: 20),
                _isLoading ? const CircularProgressIndicator() : ElevatedButton(onPressed: _startShift, child: const Text("Start Shift")),
                const SizedBox(height: 12),
                if (_message.isNotEmpty) Text(_message, style: const TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}