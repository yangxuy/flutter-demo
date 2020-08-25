import 'package:flutter/material.dart';
import 'package:yx_demo/bloc/bloc.dart';
import 'novel_bloc.dart';
import 'type.dart';

class NovelMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NovelBloc bloc = BlocProvider.of<NovelBloc>(context);
    return StreamBuilder(
      stream: bloc.sectionStream,
      builder: (BuildContext context, AsyncSnapshot<Section> snapshot) {
        return Stack(
          children: <Widget>[
            GestureDetector(
              onTap: (){

              },
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SlideTransition(
                position: bloc.animationPageMenu.rectTop,
                child: Container(
                  height: 60,
                  color: Colors.green,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SlideTransition(
                position: bloc.animationPageMenu.rectBottom,
                child: Container(
                  height: 60,
                  color: Colors.green,
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
