import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_draw_method/pages/method/draw_widget.dart';
import 'package:flutter_draw_method/pages/method/helper/item_method.dart';

import 'helper/fling_helper.dart';
import 'helper/methoddraw_helper.dart';
import 'model/method_resp.dart';

///
///
/// 这里使用ListView实现，区别于完全自己手写实现
///
class ChartWidget2 extends StatefulWidget {
  @override
  _ChartWidgetState2 createState() => _ChartWidgetState2();
}

class _ChartWidgetState2 extends State<ChartWidget2> {
  MethodDrawHelper _drawHelper;

  @override
  void initState() {
    super.initState();
    _drawHelper = MethodDrawHelper();
    for (int i = 0; i < 100; i++) {
      MethodResp resp4 = MethodResp.fromJson(json.decode(testJson));
      _drawHelper.addCall(resp4.methodCall);
    }

  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(itemBuilder: (context, index){
        return MethodWidget(_drawHelper.getItem(index));
      },
        itemCount: _drawHelper.getItemSize(),
      ),

    );

  }
}
