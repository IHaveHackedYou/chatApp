import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ConfirmationDialog extends StatelessWidget {
  final String _confirmationMessage;
  String? _redirectRoute = null;

  ConfirmationDialog(this._confirmationMessage, this._redirectRoute, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // The background color
      backgroundColor: Colors.white,
      title: Text(_confirmationMessage),
      actions: [
        ElevatedButton(
            onPressed: () {
              if(String == null) {
                Navigator.of(context, rootNavigator: true).pop();
              }else{
                Navigator.of(context).pushNamed(_redirectRoute!);
              }
            },
            child: Text("Ok"))
      ],
    );
  }
}
