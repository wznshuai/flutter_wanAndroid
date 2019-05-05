import 'package:flutter/material.dart';
import 'package:flutter_wan/baseState.dart';
import 'package:flutter_wan/model/bannerModel.dart';
import 'dart:ui' as ui;
import 'dart:async';

class BannerView extends StatefulWidget {
  BannerListModel datas;
  double defaultHeight;
  IndexedWidgetBuilder indexedWidgetBuilder;

  BannerView(this.datas, this.indexedWidgetBuilder, {this.defaultHeight = 0});

  @override
  _BannerViewState createState() => _BannerViewState();
}

class _BannerViewState extends BaseState<BannerView> {
  Timer timer;
  double defaultHeight;
  int realLength;
  static int maxLength = 10000;
  static int startIndex = maxLength ~/ 2;
  int currentIndex = 0;
  String title = "";
  PageController controller = PageController(initialPage: startIndex);

  void startTimer() {
    print("start timer");
    cancelTimer();
    if (null == timer || !timer.isActive) {
      timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
        controller.animateToPage(controller.page.toInt() + 1,
            duration: Duration(milliseconds: 300), curve: Curves.linear);
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("didChangeAppLifecycleState state is ${state}");
    switch (state) {
      case AppLifecycleState.paused:
        cancelTimer();
        break;
      case AppLifecycleState.resumed:
        startTimer();
        break;
      default:
        {}
    }
  }

  void cancelTimer() {
    if (null != timer) {
      timer.cancel();
      print("cancel timer");
    }
  }

  @override
  void didUpdateWidget(BannerView oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  int getCurrentIndex(int index) {
    return realLength == 0
        ? 0
        : ((index - startIndex + realLength) % realLength).abs();
  }

  @override
  void dispose() {
    super.dispose();
    cancelTimer();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.defaultHeight == 0) {
      defaultHeight = MediaQueryData.fromWindow(ui.window).size.height / 5;
    } else {
      defaultHeight = widget.defaultHeight;
    }
    realLength = widget.datas?.data?.length ?? 0;

    List<Widget> getWidgets() {
      List<Widget> widgets = [];
      widgets.add(Listener(
        onPointerDown: (PointerDownEvent down) {
          cancelTimer();
        },
        onPointerCancel: (PointerCancelEvent cancel) {
          startTimer();
        },
        onPointerUp: (PointerUpEvent up) {
          startTimer();
        },
        child: PageView.builder(
          controller: controller,
          itemBuilder: (BuildContext context, int index) {
            return widget.indexedWidgetBuilder(context, getCurrentIndex(index));
          },
          itemCount: widget.datas == null ? 0 : maxLength,
          onPageChanged: (int index) {
            currentIndex = getCurrentIndex(index);
            print("currentIndex is $currentIndex");
            title = this.widget.datas?.data[currentIndex].title ?? "";
            print('after currentIndex is ${currentIndex}');
            setState(() {});
            if (index == maxLength - 2 || index == 1) {
              controller.jumpToPage(startIndex + getCurrentIndex(index));
            }
          },
        ),
      ));
      if (realLength > 0) {
        widgets.add(Positioned(
          child: CustomPaint(
            painter: Dot(realLength, currentIndex ?? startIndex),
            size: Size(100, 10),
          ),
          bottom: 5,
          right: 10,
        ));
        widgets.add(Positioned(
          child: Container(
            color: Color.fromARGB(0xc0, 0xa, 0xa, 0xa),
            child: Text(title, style: TextStyle(color: Colors.white),),
            width: MediaQueryData.fromWindow(ui.window).size.width,
          ),
          bottom: 0,
          left: 0,
        ));
      }
      return widgets;
    }

    return Container(
      height: defaultHeight,
      child: Stack(
        children: getWidgets(),
      ),
    );
  }
}

class Dot extends CustomPainter {
  int count;
  int checkedIndex;
  double radius;
  double dis;
  Color defaultColor = Colors.black38;
  Color checkedColor = Colors.white;

  Dot(this.count, this.checkedIndex);

  @override
  void paint(Canvas canvas, Size size) {
    radius = size.height / 2;
//    canvas.drawColor(Colors.amberAccent, BlendMode.color);
    Paint paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..color = Colors.black38;
    dis = (size.width - 2 * radius * count) / (count - 1);
    for (var i = 0; i < count; i++) {
      i == checkedIndex
          ? paint.color = checkedColor
          : paint.color = defaultColor;
      canvas.drawCircle(
          Offset((i + 1) * radius + i * (radius + dis), size.height / 2),
          radius,
          paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
