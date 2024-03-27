import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  String title;
  String subtitle;
  CustomListTile({required this.title, required this.subtitle, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 12.0), // Increased vertical padding
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 24.0, vertical: 5), // Increased horizontal padding
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.grey, // Grey color for title
          ),
        ),
        subtitle: Container(
          color: Colors.white, // White background color for subtitle
          padding: const EdgeInsets.all(8),
          child: Text(
            subtitle,
            style: const TextStyle(
              color: Colors.black, // Black color for subtitle
            ),
          ),
        ),
        tileColor: Theme.of(context)
            .secondaryHeaderColor, // Blue accent color for the entire ListTile
      ),
    );
  }
}
