import 'package:flutter/material.dart';
import 'package:yx_demo/bloc/bloc.dart';

import 'cartoon_bloc.dart';

class CartoonMenuTop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CartoonBloc bloc = BlocProvider.of<CartoonBloc>(context);
    return SlideTransition(
      position: bloc.rectTop,
      child: Container(
        height: 70,
        color: Colors.blue,
      ),
    );
  }
}

class CartoonMenuBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CartoonBloc bloc = BlocProvider.of<CartoonBloc>(context);
    return SlideTransition(
      position: bloc.rectBottom,
      child: Container(
        height: 70,
        color: Colors.black,
      ),
    );
  }
}
