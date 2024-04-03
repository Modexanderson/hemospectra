import 'package:flutter/material.dart';
import 'package:hemospectra/widgets/custom_button.dart';

import '../screens.dart';

class TestResultScreen extends StatelessWidget {
  const TestResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Test Result',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(children: [
          Expanded(
            child: ListView(
              children: const [
                SizedBox(height: 16.0),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Screens(),
                ),
              );

              // Implement edit profile functionality
            },
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              fixedSize: MaterialStateProperty.all(const Size.fromWidth(300)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
            child: const Text('Done'),
          ),
        ]),
      ),
    );
  }
}
