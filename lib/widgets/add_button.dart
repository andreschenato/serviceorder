import 'package:flutter/material.dart';

class AddButton {
  static ElevatedButton botao({
    required VoidCallback action,
  }) {
    return ElevatedButton(
      style: ButtonStyle(
        minimumSize: const WidgetStatePropertyAll(Size.square(40)),
        overlayColor: 
           const WidgetStatePropertyAll(Color.fromARGB(255, 124, 161, 246)),
        backgroundColor:
           const WidgetStatePropertyAll(Color.fromARGB(255, 38, 103, 255)),
        foregroundColor: const WidgetStatePropertyAll(Colors.white),
        padding: const WidgetStatePropertyAll(EdgeInsets.all(5)),
        shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      ),
      onPressed: action,
      child: const Icon(
        Icons.add_rounded,
        size: 40,
      ),
    );
  }
}
