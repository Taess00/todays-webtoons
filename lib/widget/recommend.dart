import 'package:flutter/material.dart';

class recommendscreen extends StatelessWidget {
  const recommendscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black,
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        title: const Text(
          "좋아하는 웹툰들",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
