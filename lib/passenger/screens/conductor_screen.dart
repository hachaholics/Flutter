import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ConductorScreen extends StatelessWidget {
  const ConductorScreen({super.key});

  Future<void> _openConductor() async {
    final uri = Uri.parse('conductor://open');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      final store = Uri.parse('https://play.google.com/store/apps/details?id=com.yourcompany.conductor');
      if (await canLaunchUrl(store)) await launchUrl(store);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conductor')),
      body: Center(
        child: ElevatedButton(
          onPressed: _openConductor,
          child: const Text('Open Conductor App'),
        ),
      ),
    );
  }
}
