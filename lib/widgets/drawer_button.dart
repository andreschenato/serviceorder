import 'package:flutter/material.dart';

class CustomButton {
  static ElevatedButton botao({
    String txt = "",
    IconData? icon,
    VoidCallback? action,
  }) {
    return ElevatedButton(
      style: const ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.transparent),
          shadowColor: WidgetStatePropertyAll(Colors.transparent),
          overlayColor: WidgetStatePropertyAll(Color.fromARGB(50, 59, 40, 204)),
          foregroundColor: WidgetStatePropertyAll(Colors.black)),
      onPressed: action,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 28,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            txt,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
