import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_draw_method/pages/method/draw_widget.dart';

import 'helper/fling_helper.dart';
import 'helper/methoddraw_helper.dart';
import 'model/method_resp.dart';

class ChartWidget extends StatefulWidget {
  @override
  _ChartWidgetState createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget>
    with SingleTickerProviderStateMixin {
  MethodDrawHelper _drawHelper;
  FlingHelper _flingHelper;
  ScrollDy _scrollDy;
  Map<Type, GestureRecognizerFactory> _gestureRecognizers;

  AnimationController _animationController;
  double _lastPos = 0;
  @override
  void initState() {
    super.initState();
    _scrollDy = ScrollDy();
    _drawHelper = MethodDrawHelper();
    for (int i = 0; i < 100; i++) {
      MethodResp resp4 = MethodResp.fromJson(json.decode(testJson));
      _drawHelper.addCall(resp4.methodCall);
    }

    _flingHelper = FlingHelper();
    _flingHelper.addUpdateListener((pos, dy) {
      _scrollDy.dy = dy;
    }, () {});

    _gestureRecognizers = <Type, GestureRecognizerFactory>{
      VerticalDragGestureRecognizer: GestureRecognizerFactoryWithHandlers<VerticalDragGestureRecognizer>(
            () => VerticalDragGestureRecognizer(),
            (VerticalDragGestureRecognizer instance) {
          instance
            ..onDown = _handleDragDown
            ..onStart = _handleDragStart
            ..onUpdate = _handleDragUpdate
            ..onEnd = _handleDragEnd
            ..onCancel = _handleDragCancel
            ..minFlingDistance = 20
            ..minFlingVelocity = 100
            ..maxFlingVelocity = 1000
            ..dragStartBehavior = DragStartBehavior.down;
        },
      ),
    };

    _animationController = AnimationController(vsync: this, lowerBound: 0, upperBound: 300, duration: Duration(seconds: 1));
    _animationController.addListener((){
      _scrollDy.dy = _lastPos - _animationController.value;
      _lastPos = _animationController.value;

    });
  }

  _handleDragDown(DragDownDetails details){
    _flingHelper.stop();
  }

  _handleDragStart(DragStartDetails details){

  }

  _handleDragUpdate(DragUpdateDetails details){
    _scrollDy.dy = details.delta.dy * 2;

  }

  _handleDragEnd(DragEndDetails details){
//    _flingHelper.startFling(
//        0.135, 0, details.velocity.pixelsPerSecond.dy, null, null);
    _animationController.reset();
    _animationController.forward();
  }

  _handleDragCancel(){

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('ChartWidget  build');
    return RawGestureDetector(
      gestures: _gestureRecognizers,
      child: Container(
        color: Colors.amber[50],
        width: double.infinity,
        height: 500,
        child: ClipRect(
          child: RepaintBoundary(
            child: DrawWidget(_scrollDy),
          ),
        ),
      ),
    );
  }
}

class ChartPainter extends CustomPainter {
  MethodDrawHelper _drawHelper;
  Paint _paint;
  double _dy;

  ChartPainter(this._drawHelper, this._dy) {
    _paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    _drawHelper.screenH = size.height;
    _drawHelper.screenW = size.width;
    _drawHelper.scroll(_dy);
    _drawHelper.draw(canvas, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
