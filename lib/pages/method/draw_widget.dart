import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_draw_method/pages/method/model/method_resp.dart';

import 'helper/methoddraw_helper.dart';

class DrawWidget extends SingleChildRenderObjectWidget {
  final ScrollDy scrollDy;

  const DrawWidget(this.scrollDy,{
    Key key,
    Widget child,
  }) :super(key: key, child: child);

  @override
  DrawRenderObject createRenderObject(BuildContext context) {
    print('createRenderObject');
    return DrawRenderObject(scrollDy);
  }

  @override
  void updateRenderObject(BuildContext context, DrawRenderObject renderObject) {
    print('updateRenderObject');
    renderObject.scrollDy = scrollDy;
  }



}

class DrawRenderObject extends RenderProxyBox {
  MethodDrawHelper _drawHelper;
  Paint _paint;
  ScrollDy scrollDy;


  DrawRenderObject(this.scrollDy) {
    print('DrawRenderObject');
    _paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;
    _drawHelper = MethodDrawHelper();
    for (int i = 0; i < 100; i++) {
      MethodResp resp4 = MethodResp.fromJson(json.decode(testJson));
      _drawHelper.addCall(resp4.methodCall);
    }

  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    scrollDy?.addListener(markRePaint);
  }

  @override
  void detach() {
    super.detach();
    scrollDy?.removeListener(markRePaint);
  }

  void markRePaint() {
    markNeedsPaint();
  }


  @override
  void performResize() {
    size = constraints.biggest;
  }


  @override
  void paint(PaintingContext context, Offset offset) {
    draw(context.canvas, size);

  }

  draw(Canvas canvas, Size size){
    _drawHelper.screenH = size.height;
    _drawHelper.screenW = size.width;
    _drawHelper.scroll(scrollDy.dy);
    _drawHelper.draw(canvas, _paint);
  }

}


class ScrollDy extends ChangeNotifier {
  double _dy = 0.0;

  set dy(double value) {
    _dy = value;
    notifyListeners();
  }

  double get dy => _dy;


}


