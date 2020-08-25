import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:novel/novel.dart';
import 'package:yx_demo/http/mock_api.dart';
import 'package:yx_demo/page_config/base_page.dart';
import 'package:yx_demo/screen/screen.dart';

import 'drag_novel.dart' hide PageReveal;
import 'novel_mc.dart' ;
import 'page_drag.dart';
import 'read_reveal.dart';
import 'reader_utils.dart';

class Novel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage<NovelMC>(
      create: (_) => NovelMC()..attach(context),
      builder: (_, NovelMC mc, __) {
        if (mc.section == null) {
          return Scaffold();
        }
        return Material(
          child: SafeArea(
            top: true,
            child: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.dark,
              child: handlerBuildType(mc),
            ),
          ),
        );
      },
    );
  }

  Widget handlerBuildBg() {
    return Positioned(
        left: 0,
        top: 0,
        right: 0,
        bottom: 0,
        child: Image.asset('assets/images/read_bg.png', fit: BoxFit.cover));
  }

  handlerBuildType(NovelMC mc) {
    switch (mc.type) {
      case 0:
        return PageView.builder(
          physics: BouncingScrollPhysics(),
          controller: mc.pageController,
          itemCount: mc.section?.pageOffsets?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            return handlerBuildItem(mc, index);
          },
          onPageChanged: mc.onPageChanged,
        );
      case 1:
        return Stack(
          fit: StackFit.expand,
          children: <Widget>[
            handlerBuildItem(mc, mc.nextIndex),
            PageReveal(
              child: handlerBuildItem(mc, mc.currentIndex),
            ),
            PageDrag()
          ],
        );
    }
  }

  handlerBuildItem(NovelMC mc, int index) {
    var content = mc.section.stringAtPageIndex(index);

    if (content.startsWith('\n')) {
      content = content.substring(1);
    }
    double top = mc.topSafeHeight + ReaderUtils.topOffset;
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        handlerBuildBg(),
        Container(
          padding: EdgeInsets.fromLTRB(
              15, 10 + mc.topSafeHeight, 15, 10 + Screen.bottomSafeHeight),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(mc.section.title,
                  style: TextStyle(
                      fontSize: mc.fixedFontSize(14), color: mc.golden)),
              Expanded(child: Container()),
              Row(
                children: <Widget>[
                  SizedBox(width: 10),
                  Text('10:10',
                      style: TextStyle(
                          fontSize: mc.fixedFontSize(11), color: mc.golden)),
                  Expanded(child: Container()),
                  Text('第${index + 1}页',
                      style: TextStyle(
                          fontSize: mc.fixedFontSize(11), color: mc.golden)),
                ],
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(
              15,
              mc.controller.status == AnimationStatus.completed
                  ? top
                  : top + mc.topSafeHeight,
              10,
              Screen.bottomSafeHeight + ReaderUtils.bottomOffset),
          child: Text.rich(
            TextSpan(children: [
              TextSpan(
                  text: content,
                  style: TextStyle(fontSize: mc.fixedFontSize(mc.fontSize)))
            ]),
            textAlign: TextAlign.justify,
          ),
        )
      ],
    );
  }
}
