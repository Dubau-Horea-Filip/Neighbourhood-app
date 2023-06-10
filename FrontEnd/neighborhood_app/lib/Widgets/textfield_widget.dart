import 'package:flutter/material.dart';

class TextFieldWidgetController extends StatefulWidget {
  final int maxLines;
  final String label;
  final bool isVisible;
  final TextEditingController controller;

  const TextFieldWidgetController({
    Key? key,
    this.maxLines = 1,
    required this.label,
    required this.controller,
    required this.isVisible,
    
  }) : super(key: key);

  @override
  _TextFieldWidgetControllerState createState() =>
      _TextFieldWidgetControllerState();
}

class _TextFieldWidgetControllerState extends State<TextFieldWidgetController> {
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   widget.label,
          //   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          // ),
          const SizedBox(height: 8),
          TextField(
            controller: widget.controller,
            obscureText: !widget.isVisible,
            enableSuggestions: false,
            autocorrect: false,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                labelText: widget.label,
                suffix: GestureDetector(
                  child: const Icon(Icons.close),
                  onTap: () {
                    widget.controller.clear();
                  },
                )),
            maxLines: widget.maxLines,
          ),
        ],
      );
}
