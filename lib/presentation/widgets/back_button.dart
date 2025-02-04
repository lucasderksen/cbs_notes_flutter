import 'package:flutter/material.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 8, 0, 8),
      child: IconButton.filled(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(const Color(0xFF3D3D3D)),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        icon: const Icon(Icons.chevron_left),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}
