import 'package:flutter/material.dart';

class ResultLoadingScreen extends StatelessWidget {
  const ResultLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(
              height: 20,
            ),
            Text(
              'Hang Tight!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Our super-powered algorithms are analyzing your results at lightning speed',
            ),
          ],
        ),
      ),
    );
  }
}
