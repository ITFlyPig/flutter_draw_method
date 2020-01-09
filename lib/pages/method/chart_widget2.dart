import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_draw_method/pages/method/draw_data_provider.dart';
import 'package:flutter_draw_method/pages/method/draw_widget.dart';
import 'package:flutter_draw_method/pages/method/helper/item_method.dart';
import 'package:provider/provider.dart';

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
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }


  @override
  Widget build(BuildContext context) {
    DrawDataProvider dataProvider = Provider.of<DrawDataProvider>(context);
    MethodDrawHelper methodDrawHelper = dataProvider.drawHelper;
    return Container(
      child: ListView.builder(itemBuilder: (context, index){
        return MethodWidget(methodDrawHelper.getItem(index));
      },
        itemCount: methodDrawHelper.getItemSize(),
        controller: _scrollController,
      ),

    );

  }
}
