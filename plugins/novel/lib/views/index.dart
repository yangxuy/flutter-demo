import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/section.dart';

class BaseNovel extends StatelessWidget {
  final isShowMenu;
  final Section section;

  BaseNovel({this.section, this.isShowMenu = true});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            color: Colors.greenAccent,
          ),
        ],
      ),
    );
  }
}
