import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/status_service.dart';
import 'login_screen.dart';
import 'start_shift_screen.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({Key? key}) : super(key: key);

  @override
  _StatusScreenState createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  String _token = "";
  String _currentStatus = "";
  bool _isLoading = false;
  String _message = "";

  final Map<String, IconData> _statusIcons = {
    'vacant': Icons.event_seat,
    'limited_seats': Icons.airline_seat_recline_normal,
    'no_seats_left': Icons.event_seat_rounded,
    'no_space_to_stand': Icons.directions_walk,
  };

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString('auth_token') ?? '';
    });
  }

  Future<void> _setStatus(String status) async {
    if (_token.isEmpty) {
      setState(() => _message = "Not authenticated.");
      return;
    }

    setState(() {
      _isLoading = true;
      _message = "";
    });

    final res = await StatusService.updateStatus(_token, status);

    setState(() => _isLoading = false);

    if (res['success'] == true) {
      setState(() {
        _currentStatus = status;
        _message = "Status updated: $status";
      });
    } else {
      setState(() => _message = "Failed to update status: ${res['error'] ?? 'unknown'}");
    }
  }

  Future<void> _endShift() async {
    if (_token.isEmpty) {
      setState(() => _message = "Not authenticated.");
      return;
    }

    setState(() {
      _isLoading = true;
      _message = "";
    });

    final res = await StatusService.endShift(_token);

    setState(() => _isLoading = false);

    if (res['success'] == true) {
      // clear token and go to login
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('conductor_id');

      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    } else {
      setState(() => _message = "Failed to end shift: ${res['error'] ?? 'unknown'}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusButtons = _statusIcons.entries.map((e) {
      final key = e.key;
      final icon = e.value;
      final selected = _currentStatus == key;
      return Column(
        children: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: selected ? Colors.green : null,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
            ),
            onPressed: () => _setStatus(key),
            icon: Icon(icon),
            label: Text(key.replaceAll('_', ' ').toUpperCase()),
          ),
          const SizedBox(height: 8),
        ],
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Status"),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const StartShiftScreen()));
            },
            tooltip: 'Back to Start Shift',
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text("Set bus occupancy status:", style: TextStyle(fontSize: 18)),
              const SizedBox(height: 12),
              ...statusButtons,
              const SizedBox(height: 20),
              _isLoading ? const CircularProgressIndicator() : ElevatedButton(
                onPressed: _endShift,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("End Shift"),
              ),
              const SizedBox(height: 12),
              if (_message.isNotEmpty) Text(_message, style: const TextStyle(color: Colors.black)),
            ],
          ),
        ),
      ),
    );
  }
}