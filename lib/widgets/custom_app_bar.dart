import 'package:flutter/material.dart';

class CustomAppBar {
  static AppBar appBar({
    required String txt,
  }) {
    return AppBar(
      centerTitle: true,
      title: Text(
        txt,
        style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
      ),
      backgroundColor: const Color.fromARGB(255, 59, 40, 204),
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }
}
