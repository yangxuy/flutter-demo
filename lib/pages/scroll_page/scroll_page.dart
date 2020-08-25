import 'package:flutter/material.dart';
import 'package:yx_demo/scroll_extent/scroll_ext.dart';

class ScrollPage extends StatefulWidget {
  @override
  _ScrollPageState createState() => _ScrollPageState();
}

class _ScrollPageState extends State<ScrollPage> {
  XScrollController scrollController;

  @override
  void initState() {
    scrollController = XScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ;
    return Scaffold(
      appBar: AppBar(
        title: Text('测试滚动'),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
          return [
            SliverAppBar(
              title: Text('测试'),
            )
          ];
        },
        body: SingleChildScrollView(
          child: Container(
            width: 1000,
            height: 1000,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
