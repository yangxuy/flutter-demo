import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'CustomPageView.dart';

class Carousel extends StatefulWidget {
  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  List<String> _images = [
    'assets/images/1.jpg',
    'assets/images/2.jpg',
    'assets/images/3.jpg',
    'assets/images/4.jpg',
  ];
  Timer _timer; //定时器
  PageController _pageController = PageController(
    initialPage: 1,
    viewportFraction: 0.9,
  ); //索引从0开始，因为有增补，所以这里设为1
  int _currentIndex = 1;
  double pageOffset = 0;

  //设置定时器
  _setTimer() {
    _timer = Timer.periodic(Duration(seconds: 4), (_) {
      _pageController.animateToPage(_currentIndex + 1,
          duration: Duration(milliseconds: 400), curve: Curves.easeOut);
      _pageController.addListener(() {
        setState(() {
          pageOffset = _pageController.page;
        });
      });
    });
  }

  @override
  void initState() {
    if (_images.length > 0) {
      _setTimer();
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List addedImages = [];
    if (_images.length > 0) {
      addedImages
        ..add(_images[_images.length - 1])
        ..addAll(_images)
        ..add(_images[0]);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('轮播页面'),
      ),
      body: AspectRatio(
        aspectRatio: 2.5,
        child: Stack(
          children: <Widget>[
            NotificationListener(
              onNotification: (ScrollNotification notification) {
                if (notification.depth == 0 &&
                    notification is ScrollStartNotification) {
                  if (notification.dragDetails != null) {
                    _timer?.cancel();
                  }
                } else if (notification is ScrollEndNotification) {
                  _timer?.cancel();
                  _setTimer();
                }
                return false;
              },
              child: _images.length > 0
                  ? CustomPageView.builder(
                      physics: BouncingScrollPhysics(),
                      controller: _pageController,
                      onPageChanged: (page) {
                        int newIndex;
                        if (page == addedImages.length - 1) {
                          newIndex = 1;
                          _pageController.jumpToPage(newIndex);
                        } else if (page == 0) {
                          newIndex = addedImages.length - 2;
                          _pageController.jumpToPage(newIndex);
                        } else {
                          newIndex = page;
                        }
                        setState(() {
                          _currentIndex = newIndex;
                        });
                      },
                      itemCount: addedImages.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Image.asset(
                              addedImages[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    )
                  : Container(),
            ),
            Positioned(
              bottom: 15.0,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: _images
                    .asMap()
                    .map((i, v) => MapEntry(
                        i,
                        Container(
                          width: 6.0,
                          height: 6.0,
                          margin: EdgeInsets.only(left: 2.0, right: 2.0),
                          decoration: ShapeDecoration(
                              color: _currentIndex == i + 1
                                  ? Colors.red
                                  : Colors.white,
                              shape: CircleBorder()),
                        )))
                    .values
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ClipDemo extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromCenter(
        center: Offset(size.width / 2, size.height),
        width: size.width,
        height: size.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
