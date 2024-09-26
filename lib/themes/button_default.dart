import 'package:flutter/material.dart';

class ButtonDefault {
  static ButtonStyle buttonStyleCancel() {
    return const ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(
        Colors.white,
      ),
      foregroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 38, 103, 255)),
      textStyle: WidgetStatePropertyAll(
        TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
      padding: WidgetStatePropertyAll(
        EdgeInsets.only(top: 12, bottom: 12),
      ),
    );
  }
  static ButtonStyle buttonStyle() {
    return const ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(
        Color.fromARGB(255, 38, 103, 255),
      ),
      foregroundColor: WidgetStatePropertyAll(Colors.white),
      textStyle: WidgetStatePropertyAll(
        TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
      padding: WidgetStatePropertyAll(
        EdgeInsets.only(top: 12, bottom: 12),
      ),
    );
  }
}
