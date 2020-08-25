import 'package:flutter/material.dart';
import 'package:yx_demo/bloc/bloc.dart';
import 'type.dart';
import 'novel_bloc.dart';

class NovelType extends StatelessWidget {
  final Widget child;

  NovelType({@required this.child});

  @override
  Widget build(BuildContext context) {
    NovelBloc bloc = BlocProvider.of<NovelBloc>(context);
    return StreamBuilder(
      stream: bloc.percentStream,
      builder: (BuildContext context, AsyncSnapshot<SlideUpdate> snapshot) {
        if (snapshot.data == null) {
          return child;
        }

        bloc.handlerNextContent(snapshot.data);
        double screenW = bloc.contentWidth + bloc.rightOffset + bloc.leftOffset;

        return Transform(
          transform: Matrix4.translationValues(
              snapshot.data.direction == SlideDirection.leftToRight
                  ? snapshot.data.slidePercent * screenW
                  : -snapshot.data.slidePercent * screenW,
              0,
              0),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    offset: Offset(4, 4),
                    blurRadius: 4)
              ],
            ),
            child: child,
          ),
        );
      },
    );
  }
}
