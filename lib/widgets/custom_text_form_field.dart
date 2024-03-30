import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final String? initialValue;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final AutovalidateMode autovalidateMode;

  const CustomTextFormField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.labelText,
    this.initialValue,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: labelText != null
          ? Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
              decoration: BoxDecoration(
                  color: Theme.of(context).secondaryHeaderColor,
                  borderRadius: BorderRadius.circular(5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    labelText!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey, // Grey color for title
                    ),
                  ),
                  TextFormField(
                    initialValue: initialValue,
                    controller: controller,
                    obscureText: obscureText,
                    keyboardType: keyboardType,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: InputBorder.none,
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(6.0),
                      hintText: hintText,
                      suffixIcon: suffixIcon,
                    ),
                    validator: validator,
                    autovalidateMode: autovalidateMode,
                  ),
                ],
              ))
          : TextFormField(
              initialValue: initialValue,
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).secondaryHeaderColor,
                focusedBorder: InputBorder.none,
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                contentPadding: const EdgeInsets.all(12.0),
                hintText: hintText,
                suffixIcon: suffixIcon,
              ),
              validator: validator,
              autovalidateMode: autovalidateMode,
            ),
    );
  }
}
