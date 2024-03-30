import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String hintText;
  final Function()? onPressed;

  const CustomDropdown({
    required this.hintText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                hintText,
                style: TextStyle(
                  color: onPressed != null ? Colors.black : Colors.grey,
                ),
              ),
            ),
            Icon(CupertinoIcons.chevron_down),
          ],
        ),
      ),
    );
  }
}
