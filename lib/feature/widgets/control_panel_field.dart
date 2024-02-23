import 'package:flutter/material.dart';
import 'package:rotak_arac/core/extensions/contextExtension.dart';

class ControlPanelFieldWidget extends StatelessWidget {
  String text;
  Color color;
  Color textColor;
  ControlPanelFieldWidget(
      {super.key,
      required this.text,
      required this.color,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width * 0.3,
      height: context.height * 0.05,
      color: color,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Row(
          children: [
            Center(
              child: Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
