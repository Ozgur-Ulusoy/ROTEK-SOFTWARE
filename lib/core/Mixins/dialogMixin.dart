import 'package:flutter/material.dart';

mixin CustomShowDialogMixin {
  void showCustomDialog({
    required BuildContext context,
    required String title,
    required String message,
    required String positiveButtonText,
  }) {
    showDialog(
      context: context,
      builder: (
        context,
      ) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text(positiveButtonText),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
