import 'package:demo2/base_ext/model_ext.dart';
import 'package:demo2/page_config/base_model_logic.dart';
import 'package:demo2/route_config/page_overlay/index.dart';
import 'package:flutter/material.dart';

class Item {
  Item({
    this.id,
    this.expandedValue,
    this.headerValue,
  });

  int id;
  String expandedValue;
  String headerValue;
}

class HomeModelLogic extends BaseModelLogic with SingleTickerProviderModelMixin {
  static List<Item> _data = generateItems(8);

  showOverLay() {
    ShowOverlayPage.showPopMenuWithAnimation(this);
  }

  static List<Item> generateItems(int numberOfItems) {
    return List.generate(numberOfItems, (int index) {
      return Item(
        id: index,
        headerValue: 'Panel $index',
        expandedValue: 'This is item number $index',
      );
    });
  }

  Widget buildPanel() {
    return ExpansionPanelList.radio(
      initialOpenPanelValue: 2,
      children: _data.map<ExpansionPanelRadio>((Item item) {
        return ExpansionPanelRadio(
          value: item.id,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(item.headerValue),
            );
          },
          body: ListTile(
            title: Text(item.expandedValue),
            subtitle: Text('To delete this panel, tap the trash can icon'),
            trailing: Icon(Icons.delete),
            onTap: () {
              handlerDelItem(item);
            },
          ),
        );
      }).toList(),
    );
  }

  handlerDelItem(item) {
    _data.removeWhere((currentItem) => item == currentItem);
    notify();
  }
}
