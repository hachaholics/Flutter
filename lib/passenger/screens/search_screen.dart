import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/custom_text_field.dart';
import 'map_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController startController = TextEditingController();
  final TextEditingController endController = TextEditingController();
  bool _loading = false;

  Future<void> _search() async {
    final start = startController.text.trim();
    final end = endController.text.trim();
    if (start.isEmpty || end.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter both start and end')),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      final route = await ApiService.findRoute(start, end);
      setState(() => _loading = false);
      if (route == null || route.fullRoute.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No route found')),
        );
        return;
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => MapScreen(route: route)),
      );
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Find Bus Route')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(controller: startController, label: 'Start Stop'),
            const SizedBox(height: 12),
            CustomTextField(controller: endController, label: 'End Stop'),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _search,
                child: _loading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Search Route'),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Tap Home to return to the main app',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),

      // 🔹 Home button at bottom
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(context); // goes back to main home
            },
            icon: const Icon(Icons.home),
            label: const Text("Home"),
          ),
        ),
      ),
    );
  }
}

