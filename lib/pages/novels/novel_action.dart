import 'package:flutter/material.dart';
import 'package:yx_demo/bloc/bloc.dart';

import 'novel_bloc.dart';
import 'type.dart';

class NovelAction extends StatelessWidget {
  Offset dragStart;
  SlideDirection slideDirection;
  bool canDragRightToLeft;
  bool canDragLeftToRight;

  @override
  Widget build(BuildContext context) {
    NovelBloc bloc = BlocProvider.of<NovelBloc>(context);
    return StreamBuilder(
      stream: bloc.sectionStream,
      builder: (BuildContext context, AsyncSnapshot<Section> snapshot) {
        return GestureDetector(
          onTapUp: bloc.onTapUp,
          onHorizontalDragStart: bloc.onDragStart,
          onHorizontalDragUpdate: bloc.onDragUpdate,
          onHorizontalDragEnd: bloc.onDragEnd,
        );
      },
    );
  }
}
