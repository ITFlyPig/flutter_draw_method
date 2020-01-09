import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_draw_method/pages/method/model/call_draw_item.dart';

class MethodWidget extends SingleChildRenderObjectWidget {

  final CallDrawItem callDrawItem;


  MethodWidget(this.callDrawItem);

  @override
  MethodRenderObject createRenderObject(BuildContext context) {
    return MethodRenderObject(callDrawItem);
  }

  @override
  void updateRenderObject(BuildContext context, MethodRenderObject renderObject) {
    renderObject.callDrawItem = callDrawItem;
  }

}

class MethodRenderObject extends RenderProxyBox {
  CallDrawItem callDrawItem;
  Paint _paint;

  MethodRenderObject(this.callDrawItem) {
    _paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;
  }

  //据child计算自己的大小
  @override
  void performResize() {
    if(callDrawItem == null) {
      size = Size.zero;
    }
    if(callDrawItem.h == null || callDrawItem.h == 0.0 || callDrawItem.w == null || callDrawItem.w == 0.0) {
      callDrawItem.measure();//计算出需要绘制的图的大小
    }
    size = Size(constraints.minWidth, callDrawItem.h);//将自身的大小设置为将要绘制的图的大小
  }

  //绘制child
  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    callDrawItem?.draw(context.canvas, _paint, 0, callDrawItem.childs == null ? 0 : callDrawItem.childs.length);

  }

}