import 'package:flutter/material.dart';
import 'package:yx_demo/bloc/bloc.dart';

import 'novel_bg.dart';
import 'novel_bloc.dart';

class NovelRead<T> extends StatelessWidget {
  var oldRead;

  @override
  Widget build(BuildContext context) {
    NovelBloc bloc = BlocProvider.of<NovelBloc>(context);
    return StreamBuilder(
      stream: bloc.contentStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == null) {
          return Container();
        }

        if (snapshot.data is T) {
          oldRead = snapshot.data;
        }

        if (oldRead == null) {
          return Container();
        }

        return Stack(
          fit: StackFit.expand,
          children: <Widget>[
            NovelBg(bloc.urlBg),
            Container(
              padding: EdgeInsets.fromLTRB(
                bloc.leftOffset,
                bloc.topOffset,
                bloc.rightOffset,
                bloc.bottomOffset,
              ),
              child: Text.rich(
                TextSpan(children: [
                  TextSpan(
                    text: oldRead.content,
                    style: TextStyle(fontSize: bloc.fontScaleSize),
                  )
                ]),
                textAlign: TextAlign.justify,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: bloc.leftOffset,
                  right: bloc.rightOffset,
                  top: bloc.topOffset - bloc.fixedFontSize(14),
                  bottom: bloc.bottomOffset - bloc.fixedFontSize(11)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(bloc.section.title,
                      style: TextStyle(
                          fontSize: bloc.fixedFontSize(14),
                          color: bloc.golden)),
                  Expanded(child: Container()),
                  Row(
                    children: <Widget>[
                      SizedBox(width: 10),
                      Text('10:10',
                          style: TextStyle(
                              fontSize: bloc.fixedFontSize(11),
                              color: bloc.golden)),
                      Expanded(child: Container()),
                      Text('第${oldRead.page + 1}页',

                          style: TextStyle(
                              fontSize: bloc.fixedFontSize(11),
                              color: bloc.golden)),
                    ],
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
