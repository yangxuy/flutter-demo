class HomeModel {
  String title;
  List<Menu> menus;

  HomeModel({this.title, this.menus});
}

class Menu {
  final String name;
  final int groupId; //用于布局
  final int id; // 点击id

  Menu({this.name, this.id, this.groupId});
}

List group = [
  {
    "title": "开发指南",
    "children": [
      {"name": "安装", "groupId": 0, "id": 0},
      {"name": "快速上手", "groupId": 1, "id": 1},
      {"name": "国际化", "groupId": 2, "id": 2},
      {"name": "自定义主题", "groupId": 3, "id": 3},
      {"name": "动画", "groupId": 4, "id": 4},
      {"name": "状态栏", "groupId": 5, "id": 19},
    ]
  },
  {
    "title": "组件",
    "children": [
      {"name": "布局", "groupId": 0, "id": 5},
      {"name": "容器", "groupId": 1, "id": 6},
      {"name": "字体", "groupId": 2, "id": 7},
      {"name": "Icon", "groupId": 2, "id": 8},
    ]
  },
  {
    "title": "导航",
    "children": [
      {"name": "base", "groupId": 0, "id": 9}
    ]
  },
  {
    "title": "other",
    "children": [
      {"name": "Dialog", "groupId": 0, "id": 10},
      {"name": "卡片", "groupId": 1, "id": 11},
      {"name": "轮播", "groupId": 2, "id": 12},
      {"name": "折叠", "groupId": 3, "id": 13},
      {"name": "刷新", "groupId": 4, "id": 14},
      {"name": "抽屉", "groupId": 5, "id": 15},
      {"name": "canvas", "groupId": 6, "id": 16},
      {"name": "小说", "groupId": 7, "id": 17},
      {"name": "漫画", "groupId": 8, "id": 18},
      {"name": "Reveal", "groupId": 9, "id": 20},
      {"name": "滚动测试", "groupId": 10, "id": 21},
    ]
  }
];
