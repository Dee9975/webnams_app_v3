import 'package:flutter/material.dart';

const Color _kKeyUmbraOpacity = Color(0x33000000); // alpha = 0.2
const Color _kKeyPenumbraOpacity = Color(0x24000000); // alpha = 0.14
const Color _kAmbientShadowOpacity = Color(0x1F000000); // alpha = 0.12

class InfoBox extends StatelessWidget {
  final Widget text;
  final VoidCallback onPressed;
  InfoBox({@required this.text, @required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      child: GestureDetector(
        onTap: () => onPressed(),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    offset: Offset(0.0, 2.0),
                    blurRadius: 1.0,
                    spreadRadius: -1.0,
                    color: _kKeyUmbraOpacity),
                BoxShadow(
                    offset: Offset(0.0, 1.0),
                    blurRadius: 1.0,
                    spreadRadius: 0.0,
                    color: _kKeyPenumbraOpacity),
                BoxShadow(
                    offset: Offset(0.0, 1.0),
                    blurRadius: 3.0,
                    spreadRadius: 0.0,
                    color: _kAmbientShadowOpacity),
              ]),
          child: Padding(
            padding: EdgeInsets.only(left: 16.0, top: 9.0, bottom: 9.0),
            child: text,
          ),
        ),
      ),
    );
  }
}
