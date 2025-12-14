import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'main.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 4000), () {});
    if (mounted) {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (context) => const MyHomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
                  'JVH',
                  style: TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.activeBlue,
                  ),
                )
                .animate()
                .fadeIn(duration: 900.ms, curve: Curves.easeOut)
                .slide(
                  begin: const Offset(0, 1),
                  duration: 600.ms,
                  curve: Curves.decelerate,
                ),
            const SizedBox(height: 10),
            const Text(
                  'Tu inventario, a tu manera.',
                  style: TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    color: CupertinoColors.secondaryLabel,
                  ),
                )
                .animate()
                .fadeIn(delay: 600.ms, duration: 900.ms, curve: Curves.easeOut)
                .slide(
                  begin: const Offset(0, -1),
                  duration: 600.ms,
                  curve: Curves.decelerate,
                ),
          ],
        ),
      ),
    );
  }
}
