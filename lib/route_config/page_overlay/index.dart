import 'package:demo2/pages/home/home_model_logic.dart';
import 'package:flutter/material.dart';

OverlayEntry overlayEntry;
AnimationController controller;

class ShowOverlayPage {
  static showPopMenu(BuildContext context) {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
      return;
    }
    overlayEntry = new OverlayEntry(builder: (context) {
      return new Positioned(
        top: kToolbarHeight,
        right: 0,
        width: 180,
        height: 320,
        child: new SafeArea(
          child: new Material(
            child: new Container(
              color: Colors.black,
              child: new Column(
                children: <Widget>[
                  Expanded(
                    child: new ListTile(
                      leading: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      title: new Text(
                        "发起群聊",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    child: new ListTile(
                      leading: Icon(Icons.add, color: Colors.white),
                      title: new Text("添加朋友", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  Expanded(
                    child: new ListTile(
                      leading: Icon(Icons.add, color: Colors.white),
                      title: new Text("扫一扫", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  Expanded(
                    child: new ListTile(
                      leading: Icon(Icons.add, color: Colors.white),
                      title: new Text("首付款", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  Expanded(
                    child: new ListTile(
                      leading: Icon(Icons.add, color: Colors.white),
                      title: new Text("帮助与反馈", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
    Overlay.of(context).insert(overlayEntry);
  }

  static showPopMenuWithAnimation(HomeModelLogic it) {
    Duration duration = Duration(milliseconds: 400);
    if (overlayEntry == null) {
      controller = AnimationController(vsync: it, duration: duration);
      Animation<RelativeRect> rect = controller.drive(
        RelativeRectTween(
          begin: RelativeRect.fromLTRB(
              180, kToolbarHeight, 0, MediaQuery.of(it.context).size.height - kToolbarHeight),
          end: RelativeRect.fromLTRB(180, kToolbarHeight, 0, 320),
        ),
      );
      overlayEntry = new OverlayEntry(builder: (context) {
        return PositionedTransition(
          rect: rect,
          child: new SafeArea(
            child: new Material(
              child: new Container(
                color: Colors.black,
                child: new Column(
                  children: <Widget>[
                    Expanded(
                      child: new ListTile(
                        leading: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        title: new Text(
                          "发起群聊",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Expanded(
                      child: new ListTile(
                        leading: Icon(Icons.add, color: Colors.white),
                        title: new Text("添加朋友", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    Expanded(
                      child: new ListTile(
                        leading: Icon(Icons.add, color: Colors.white),
                        title: new Text("扫一扫", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    Expanded(
                      child: new ListTile(
                        leading: Icon(Icons.add, color: Colors.white),
                        title: new Text("首付款", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    Expanded(
                      child: new ListTile(
                        leading: Icon(Icons.add, color: Colors.white),
                        title: new Text("帮助与反馈", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
    }
    if (overlayEntry != null) {
      if (controller.status == AnimationStatus.dismissed) {
        controller.forward();
        Overlay.of(it.context).insert(overlayEntry);
      }
      if (controller.status == AnimationStatus.completed) {
        controller.reverse();
        Future.delayed(duration, () {
          overlayEntry.remove();
          controller.dispose();
          overlayEntry = null;
          controller = null;
        });
      }
    }
  }
}
