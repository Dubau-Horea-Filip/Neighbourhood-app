import 'package:flutter/material.dart';

class TextBox extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const TextBox(this.controller, this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            filled: true,
            labelText: label,
            suffix: GestureDetector(
              child: const Icon(Icons.close),
              onTap: () {
                controller.clear();
              },
            )),
      ),
    );
  }
}