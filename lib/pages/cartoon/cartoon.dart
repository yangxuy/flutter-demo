import 'package:flutter/material.dart';
import 'package:yx_demo/bloc/bloc.dart';
import 'package:yx_demo/pages/animation/menu_animation.dart';

import 'cartoon_bloc.dart';
import 'cartoon_menu.dart';

class Cartoon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CartoonBloc bloc = CartoonBloc();
    return Scaffold(
      body: MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: BlocProvider(
          bloc: bloc,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Listener(
                onPointerDown: bloc.onPointerDown,
                onPointerUp: bloc.onPointerUp,
                child: IndexedStack(
                  index: 1,
                  sizing: StackFit.expand,
                  children: <Widget>[
                    Container(),
                    Container(
                      color: Colors.transparent,
                    ),
                    Container(),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: CartoonMenuTop(),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: CartoonMenuBottom(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
