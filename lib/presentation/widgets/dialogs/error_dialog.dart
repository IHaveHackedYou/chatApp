import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ErrorDialog extends StatelessWidget {
  final String errorTitle;
  final String errorMessage;
  final VoidCallback onPressed;
  const ErrorDialog(this.errorTitle, this.errorMessage, this.onPressed, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // The background color
      backgroundColor: Colors.white,
      title: Text(errorTitle),
      content: Text(errorMessage),
      actions: [
        ElevatedButton(
            onPressed: onPressed,
            child: Text("Ok"))
      ],
    );
  }
}
