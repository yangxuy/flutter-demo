import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yx_demo/main_mc.dart';
import 'package:yx_demo/page_config/base_model_logic.dart';
import 'main_data.dart';

class MainModelLogic extends BaseModelLogic {
  List<HomeModel> mainMenu = List();
  int column = 4;
  BorderSide borderSide = BorderSide(color: Color(0xff969696), width: 1);

  double get size {
    return (MediaQuery.of(context).size.width - 20) / column;
  }

  @override
  init(arg) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    mainMenu.addAll(
      group.map(
        (item) => HomeModel(
          title: item['title'],
          menus: (item['children'] as List)
              .map<Menu>(
                (v) =>
                    Menu(name: v['name'], id: v['id'], groupId: v['groupId']),
              )
              .toList(),
        ),
      ),
    );
  }

  handlerMenuItemTap(int id) {
    switch (id) {
      case 0:
        Navigator.of(context).pushNamed('/down',
            arguments: "https://flutterchina.club/get-started/install/");
        break;
      case 1:
        Navigator.of(context).pushNamed('/down',
            arguments: "https://flutterchina.club/get-started/test-drive/");
        break;
      case 2:
        Navigator.of(context).pushNamed('/int');
        break;
      case 3:
        handlerChangeTheme();
        break;
      case 4:
        Navigator.of(context).pushNamed('/animation');
        break;
      case 12:
        Navigator.of(context).pushNamed('/carousel');
        break;
      case 16:
        Navigator.of(context).pushNamed('/canvas');
        break;
      case 17:
        Navigator.of(context).pushNamed('/novel');
        break;
      case 18:
        Navigator.of(context).pushNamed('/cartoon');
        break;
      case 19:
        Navigator.of(context).pushNamed('/systemChrome');
        break;
      case 20:
        Navigator.of(context).pushNamed('/pageReveal');
        break;
      case 21:
        Navigator.of(context).pushNamed('/scrollPage');
        break;
    }
  }

  handlerChangeTheme() {
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text('修改主题'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              FlatButton(
                child: Text('主题1'),
                onPressed: () {
                  read<MainMC>().setTheme(0);
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('主题2'),
                onPressed: () {
                  read<MainMC>().setTheme(1);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget builderItemList(HomeModel item) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.only(
              topStart: Radius.circular(15), topEnd: Radius.circular(15)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black54,
                offset: Offset(0.0, 0.0),
                blurRadius: 1.0),
            BoxShadow(
                color: Colors.black54,
                offset: Offset(-1.0, 0.0),
                blurRadius: 1.0)
          ]),
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            padding: EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(15), topEnd: Radius.circular(15)),
              color: Colors.blue,
            ),
            child: Text(
              item.title,
              style: TextStyle(color: Colors.white),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Wrap(
              children: item.menus.map((v) => builderItem(v)).toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget builderItem(Menu item) {
    bool r = item.groupId % column == column - 1;
    return InkWell(
      onTap: () {
        handlerMenuItemTap(item.id);
      },
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            bottom: borderSide,
            right: r ? BorderSide(width: 0) : borderSide,
          ),
        ),
        child: Text(item.name),
      ),
    );
  }
}
