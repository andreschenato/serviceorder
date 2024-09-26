import 'package:flutter/material.dart';

class CustomButton {
  static ListTile botao({
    String txt = "",
    IconData? icon,
    VoidCallback? action,
    bool selectedItem = false,
  }) {
    return ListTile(
      selected: selectedItem,
      selectedColor: const Color.fromARGB(255, 59, 40, 204),
      onTap: action,
      iconColor: Colors.black,
      title: Row(
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
