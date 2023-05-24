import 'package:flutter/material.dart';

class TextFieldWidgetController extends StatefulWidget {
  final int maxLines;
  final String label;

  final TextEditingController controller;

  const TextFieldWidgetController({
    Key? key,
    this.maxLines = 1,
    required this.label,
    required this.controller,
  }) : super(key: key);

  @override
  _TextFieldWidgetControllerState createState() =>
      _TextFieldWidgetControllerState();
}

class _TextFieldWidgetControllerState extends State<TextFieldWidgetController> {
  // @override
  // void initState() {
  //   super.initState();

  //   controller = TextEditingController(text: widget.label);
  // }

  // @override
  // void dispose() {
  //   controller.dispose();

  //   super.dispose();
  // }

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
