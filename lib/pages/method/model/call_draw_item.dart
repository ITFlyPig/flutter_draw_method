import 'dart:html';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_draw_method/pages/method/helper/color_pool.dart';
import 'package:flutter_draw_method/pages/method/helper/methoddraw_helper.dart';
import 'package:flutter_draw_method/res/colors.dart';

class CallDrawItem {
  static double textH = 0;
  static double fontSize = 1;
  String classC;
  String className;
  int endTIme;
  String methodName;
  String signature;
  int startTime;
  int totalTime;
  List<CallDrawItem> childs;
  CallDrawItem parent;

  double w = 0;
  double h = 0;
  double top = 0;
  double left = 0;
  Color color;

  CallDrawItem({this.classC,
    this.className,
    this.endTIme,
    this.methodName,
    this.signature,
    this.startTime,
    this.totalTime});

  CallDrawItem.fromJson(Map<String, dynamic> json, CallDrawItem parent) {
    classC = json['classC'];
    className = json['className'];
    endTIme = json['endTIme'];
    methodName = json['methodName'];
    signature = json['signature'];
    startTime = json['startTime'];
    totalTime = json['totalTime'];
    this.parent = parent;
    if (json['childs'] != null) {
      childs = List();
      json['childs'].forEach((v) {
        childs.add(CallDrawItem.fromJson(v, this));
      });
    }
    color = ColorPool.randomColor();
  }

  performDraw(Canvas canvas, double top, Paint paint) {
    if (canvas == null || top == null) {
      return;
    }
    if (w == null || w == 0.0 || h == null || h == 0.0) {
      measure();
    }
    this.top = top;
    draw(canvas, paint, 0, childs == null ? 0 : childs.length);
  }

  draw(Canvas canvas, Paint paint, int index, int size) {
    //绘制自己
    paint.color = this.color;
    canvas.drawRect(Rect.fromLTWH(left, top, w,
        index == 0 && size > 0 ? h - MethodDrawHelper.TOP_PADDING : h), paint);

    String drawText = (className ?? "") + '#' + (methodName ?? "") +
        ('(' + (totalTime ?? 0).toString() + ")");
    if (textH == 0) {
      Size size = measureTextSize(drawText, fontSize);
      textH = size.height;
    }

    //防止文字重叠
    double textTop = top;
    if (parent != null) {
      if ((parent.top - textTop).abs() < textH) {
        textTop += textH;
      }
    }

    //绘制文字
    _drawText(
        canvas,
        Offset(left + w, textTop),
        drawText,
        fontSize,
        color,
        double.infinity,
        paint);

    //迭代绘制child
    int childSize = childs == null ? 0 : childs.length;

    double leftTotal = left;
    double topTotal = top;
    for (int i = 0; i < childSize; i++) {
      CallDrawItem item = childs[i];
      item.top = topTotal;
      if (i == 0) {
        item.top += MethodDrawHelper.TOP_PADDING;
      }
      item.left = leftTotal;
      item.draw(canvas, paint, i, childSize);
      leftTotal += item.w;
      topTotal += item.h;
    }
  }

  ///绘制文字
  _drawText(Canvas canvas,
      Offset top,
      String drawText,
      double fontSize,
      Color color,
      double width, Paint paint) {
    TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: drawText,
          style: TextStyle(fontSize: fontSize, color: color),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.left)
      ..layout(maxWidth: width);
    //绘制文字的背景
    _drawTextBg(
        top.dx, top.dy, textPainter.width, textPainter.height, canvas, paint);
    //绘制文字
    textPainter.paint(canvas, top);
  }

  ///绘制文字的背景
  _drawTextBg(double left, double top, double width, double height,
      Canvas canvas, Paint paint) {
    paint.color = Colours.trans_white;
    canvas.drawRect(Rect.fromLTWH(left, top, width, height), paint);
  }

  ///计算文字的尺寸
  Size measureTextSize(String drawText, double fontSize,) {
    TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: drawText,
          style: TextStyle(fontSize: fontSize, color: color),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.left)
      ..layout(minWidth: double.infinity, maxWidth: double.infinity);
    return textPainter.size;
  }


  ///测量出宽和高
  measure() {
    if (w > 0 && h > 0) {
      return;
    }
    if (childs == null || childs.isEmpty) {
      w = totalTime == 0
          ? MethodDrawHelper.ZERO_TIME_METHOD_W
          : (MethodDrawHelper.ZERO_TIME_METHOD_W +
          totalTime * MethodDrawHelper.TIME_TO_DISTANCE);
      h = MethodDrawHelper.METHOD_H;
    } else {
      int len = childs.length;
      double totalW = 0;
      double totalH = 0;
      for (int i = 0; i < len; i++) {
        CallDrawItem child = childs[i];
        child.measure();
        totalW += child.w;
        totalH += child.h;
        if (i == 0) {
          totalH += MethodDrawHelper.TOP_PADDING;
        }
      }
      if (totalTime > 0) {
        double timeW = totalTime * MethodDrawHelper.TIME_TO_DISTANCE +
            MethodDrawHelper.ZERO_TIME_METHOD_W;
        if (timeW > totalW) {
          totalW = timeW;
        }
      }
      w = totalW + MethodDrawHelper.RIGHT_PADDING;
      h = totalH;
    }
  }
}
