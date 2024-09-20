import 'package:flutter/material.dart';

class FormFieldDefault {
  static InputDecoration textFieldStyle({
    String labelTxt = "",
    String hintTxt = "",
  }) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      labelText: labelTxt,
      hintText: hintTxt,
      labelStyle: const TextStyle(
        color: Color.fromARGB(255, 77, 77, 77),
        fontWeight: FontWeight.normal
      ),
      hintStyle: const TextStyle(
        color: Color.fromARGB(255, 77, 77, 77),
        fontWeight: FontWeight.normal
      ),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(4),
        ),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: const Color.fromARGB(255, 230, 230, 230),
    );
  }
}
