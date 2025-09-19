import 'package:flutter/material.dart';
import 'main.dart'; // for MainNavigation

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnim;

  @override
  void initState() {
    super.initState();

    // 🎬 Duration of text animation = 20s
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    // 👇 TweenSequence lets us chain fade in → hold → fade out
    _opacityAnim = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 15, // fade in
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(1.0),
        weight: 60, // stay visible
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 25, // fade out
      ),
    ]).animate(_controller);

    // Start animation only after 15s delay
    Future.delayed(const Duration(seconds: 5), () {
      _controller.forward();
    });

    // Navigate after 15s wait + 20s animation = 35s total
    Future.delayed(const Duration(seconds: 15), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainNavigation()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 238, 238), // Netflix-style dark background
      body: Center(
        child: FadeTransition(
          opacity: _opacityAnim,
          child: const Text(
            'Safar Saathi',
            style: TextStyle(
              fontFamily: 'prestige',
              fontSize: 60,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 89, 54, 244), // Netflix-like color
              letterSpacing: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}