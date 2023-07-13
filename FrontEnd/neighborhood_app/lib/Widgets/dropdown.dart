import 'package:flutter/material.dart';

class DropdownWidget extends StatefulWidget {
  final String label;
  final List<String> items;
  final ValueChanged<String> onChanged;
  final String? selectedItem;

  const DropdownWidget({
    Key? key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.selectedItem,
  }) : super(key: key);

  @override
  _DropdownWidgetState createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  late String? _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.selectedItem;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedItem,
            decoration: InputDecoration(
              filled: true,
              labelText: widget.label,
              suffix: GestureDetector(
                child: const Icon(Icons.close),
                onTap: () {
                  _clearSelection();
                },
              ),
            ),
            items: widget.items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedItem = value;
                widget.onChanged(value!);
              });
            },
          ),
        ],
      ),
    );
  }

  void _clearSelection() {
    setState(() {
      _selectedItem = null;
      widget.onChanged('');
    });
  }
}
