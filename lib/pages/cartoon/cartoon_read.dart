import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class CartoonRead extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return EasyRefresh(
          header: CustomHeader(
              extent: 80.0,
              triggerDistance: 90.0,
              headerBuilder: (context,
                  loadState,
                  pulledExtent,
                  loadTriggerPullDistance,
                  loadIndicatorExtent,
                  axisDirection,
                  float,
                  completeDuration,
                  enableInfiniteLoad,
                  success,
                  noMore) {
                return Stack(
                  children: <Widget>[
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        width: 30.0,
                        height: 30.0,
                        child: CupertinoActivityIndicator(),
                      ),
                    ),
                  ],
                );
              }),
          footer: CustomFooter(
              enableInfiniteLoad: false,
              extent: 80.0,
              triggerDistance: 90.0,
              footerBuilder: (context,
                  loadState,
                  pulledExtent,
                  loadTriggerPullDistance,
                  loadIndicatorExtent,
                  axisDirection,
                  float,
                  completeDuration,
                  enableInfiniteLoad,
                  success,
                  noMore) {
                return Stack(
                  children: <Widget>[
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        width: 30.0,
                        height: 30.0,
                        child: CupertinoActivityIndicator(),
                      ),
                    ),
                  ],
                );
              }),
          onRefresh: () {
            return null;
          },
          onLoad: () {
            return null;
          },
          child: Column(
            children: <Widget>[],
          ),
        );
      },
    );
  }
}
