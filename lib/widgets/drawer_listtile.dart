import 'package:flutter/material.dart';

class DrawerListTile extends StatelessWidget {
  final Widget leading;
  final String title;
  final Function onTap;
  const DrawerListTile(
      {required this.onTap,
      required this.leading,
      required this.title,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        iconColor: Colors.white,
        leading: leading,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        onTap: () {
          onTap();
        });
  }
}
