import 'package:flutter/material.dart';

class NovelBg extends StatelessWidget {
  final String urlBg;

  NovelBg(this.urlBg);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      top: 0,
      right: 0,
      bottom: 0,
      child: Image.asset(
        urlBg,
        fit: BoxFit.cover,
      ),
    );
  }
}
