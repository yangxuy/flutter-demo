import 'package:flutter/material.dart';
import 'route_config/page_route/generate_route.dart';

void main() => runApp(MyApp());

GlobalKey materialAppkey = GlobalKey();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: onGenerateRoute,
      key: materialAppkey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.white
      ),
    );
  }
}

class Text extends StatefulWidget {
  @override
  _TextState createState() => _TextState();
}

class _TextState extends State<Text> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => throw UnimplementedError();
}
