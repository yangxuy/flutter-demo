import 'package:flutter/material.dart';
import 'package:yx_demo/bloc/bloc.dart';

import 'novel_menu.dart';
import 'novel_action.dart';
import 'novel_bg.dart';
import 'novel_bloc.dart';
import 'novel_read.dart';
import 'novel_type.dart';

class Novel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NovelBloc bloc = NovelBloc();
    bloc.setContent(context);
    return Scaffold(
      body: SafeArea(
        top: false,
        child: BlocProvider(
          bloc: bloc,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              NovelBg(bloc.urlBg),
              NovelRead<NextContent>(),
              NovelType(child: NovelRead<CurrentContent>()),
              NovelAction(),
              NovelMenu()
            ],
          ),
        ),
      ),
    );
  }
}
