import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';

class AppTextBox extends StatefulWidget {
  const AppTextBox({
    super.key,
    this.title,
    required this.textEditingController,
    required this.hintText,
    required this.icon,
  });
  final String? title;
  final TextEditingController textEditingController;
  final String hintText;
  final IconData icon;

  @override
  State<AppTextBox> createState() => _AppTextBoxState();
}

class _AppTextBoxState extends State<AppTextBox> {
  @override
  Widget build(BuildContext context) {
    return widget.title != null
        ? fluent.InfoLabel(
            label: widget.title!,
            labelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w500),
            child: fluent.TextBox(
              prefix: fluent.Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Icon(
                  widget.icon,
                  color: Colors.black54,
                  size: 16,
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              controller: widget.textEditingController,
              placeholder: widget.hintText,
              style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.black54),
              expands: false,
            ),
          )
        : fluent.TextBox(
            prefix: fluent.Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Icon(
                widget.icon,
                color: Colors.black54,
                size: 16,
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            controller: widget.textEditingController,
            placeholder: widget.hintText,
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.black54),
            expands: false,
          );
  }
}
