import 'package:flutter/services.dart';
import 'package:yx_demo/page_config/base_page.dart';
import 'package:yx_demo/pages/main_logic.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: BasePage(
          create: (_) => MainModelLogic()..attach(context),
          builder: (_, MainModelLogic mc, child) {
            return CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  pinned: true,
                  centerTitle: true,
                  title: Text('杨旭的个人demo'),
                  expandedHeight: 200,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      color: Colors.blue,
                      child: Row(
                        children: <Widget>[Text('个人作品')],
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        return mc.builderItemList(mc.mainMenu[index]);
                      },
                      childCount: mc.mainMenu.length,
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
