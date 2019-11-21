import 'dart:convert';

import 'package:flutter/material.dart';

import 'helper/methoddraw_helper.dart';
import 'model/method_resp.dart';


class ChartWidget extends StatefulWidget {
  @override
  _ChartWidgetState createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  MethodDrawHelper _drawHelper;
  double _dy = 0;

  @override
  void initState() {
    super.initState();
    _drawHelper = MethodDrawHelper();
    for(int i = 0; i < 100; i++) {
      MethodResp resp4 = MethodResp.fromJson(json.decode(testJson));
      _drawHelper.addCall(resp4.methodCall);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        color: Colors.amber[50],
        width: double.infinity,
        height: 500,
        child: CustomPaint(
          painter: ChartPainter(_drawHelper, _dy),
        ),
      ),
      onVerticalDragUpdate: (detail){
         setState(() {
           _dy = detail.delta.dy;
         });
         print('滑动的距离：' + _dy.toString());
      },
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
