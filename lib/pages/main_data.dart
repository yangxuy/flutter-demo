class HomeModel {
  String title;
  List<Menu> menus;

  HomeModel({this.title, this.menus});
}

class Menu {
  final String name;
  final int groupId; //用于布局
  final int id; // 点击id
  final String path; // 点击id

  Menu({this.name, this.id, this.groupId, this.path});
}

List group = [
  {
    "title": "线上项目",
    "children": [
      {"name": "Dcoin", "groupId": 0, "id": 9, 'path': '/dcoin'},
      {"name": "库来电", "groupId": 0, "id": 9, 'path': '/telegram'},
    ]
  },
  {
    "title": "demos",
    "children": [
      {"name": "canvas", "groupId": 6, "id": 16},
      {"name": "小说", "groupId": 7, "id": 17, 'path': '/novel'},
      {"name": "漫画", "groupId": 8, "id": 18},
      {"name": "k线", "groupId": 8, "id": 18, 'path': '/kline'},
    ]
  }
];
