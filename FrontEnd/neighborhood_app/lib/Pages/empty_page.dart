import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class EMptyPage extends StatefulWidget {
  const EMptyPage({super.key});

  @override
  State<EMptyPage> createState() => _EMptyPageState();
}

class _EMptyPageState extends State<EMptyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: const Color.fromARGB(255, 104, 26, 26),
        title: const Text("Empty Page"),
      ),
    );
  }
}
