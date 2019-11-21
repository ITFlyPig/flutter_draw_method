import 'package:flutter/material.dart';
import 'package:flutter_draw_method/pages/method/model/call_draw_item.dart';

///
/// 方法绘制的帮助类
/// 1、当正在显示 + 未显示的数据 + 已显示的数据 >= _maxSize时，丢弃添加的数据
/// 2、当已显示的数据 > 100时，删除从后向前删除_delStep个已显示的数据
///

String testJson = '{"methodCall":{"childs":[{"classC":"com.talk51.afast.application.AfastApplication","className":"AfastApplication","endTIme":1574221330214,"methodName":"getApplication","signature":"com.talk51.afast.application.AfastApplication.getApplication()","startTime":1574221330214,"totalTime":0},{"classC":"com.talk51.afast.application.AfastApplication","className":"AfastApplication","endTIme":1574221330217,"methodName":"getApplication","signature":"com.talk51.afast.application.AfastApplication.getApplication()","startTime":1574221330217,"totalTime":0}],"classC":"com.talk51.kid.core.app.MainApplication","className":"MainApplication","endTIme":1574221330217,"methodName":"initBugly","signature":"com.talk51.kid.core.app.MainApplication.initBugly()","startTime":1574221330214,"totalTime":3}}';

class MethodDrawHelper {
  static const double TIME_TO_DISTANCE = 10; //时间到距离的映射
  static const double METHOD_H = 20; //叶子节点默认一个方法的高度
  static const double ZERO_TIME_METHOD_W = 3; //时间为0的方法块的对应的宽，那么有时间的叶子节点的方法块的宽度就应该是：时间 * _TIME_TO_DISTANCE + _ZERO_TIME_METHOD_W

  List<CallDrawItem> _items;
  int _maxSize = 1000;
  int _delStep = 50;
  int _showTopIndex = 0; //顶部显示的索引
  int _showBottomIndex; //底部显示的索引
  double _screenW;
  double _screenH;
  double _innerTop;

  MethodDrawHelper() {
    _items = List();
  }

  set screenH(double value) {
    _screenH = value;
  }

  set screenW(double value) {
    _screenW = value;
  }

  /// 添加一个记录
  addCall(CallDrawItem callDrawItem) {
    if (_items.length >= _maxSize || callDrawItem == null) {
      return;
    }
    _items.add(callDrawItem);

  }

  ///删除特定范围的数据
  remove(int start, int end) {
    if (start >= 0 && start <= end && end < _items.length) {
      _items.removeRange(start, end);
    }
  }

  ///dy > 0:向上  dy < 0:向下
  scroll(double dy) {
    CallDrawItem callDrawItem = _items[_showTopIndex];
    callDrawItem.measure();
    double willTop = callDrawItem.top +  dy;

    if(willTop < 0 && willTop.abs() > callDrawItem.h && _showTopIndex + 1 < _items.length) {//往上滑动
        _showTopIndex++;
        CallDrawItem next = _items[_showTopIndex];
        next.measure();
        next.top = willTop + callDrawItem.h;
    } else if(willTop > 0 && _showTopIndex - 1 >= 0) {//往下滑动
        _showTopIndex--;
        CallDrawItem pre = _items[_showTopIndex];
        pre.measure();
        pre.top = willTop.abs() - pre.h;
    } else {
      callDrawItem.top = willTop;
    }

  }

  int getDrawSize() {
    return _items.length;
  }

  ///开始绘制代码块
  draw(Canvas canvas, Paint paint) {
    if (canvas == null || paint == null) {
      return;
    }
    if (_showTopIndex >= 0 && _showTopIndex < _items.length) {
      int index = _showTopIndex;
      double nextTop = 0;
      CallDrawItem next = _items[index];
      nextTop = next.top;
      while (_isVisible(next.top)) {
        next.performDraw(canvas, nextTop, paint);
        index++;
        if (index >= _items.length) {
          break;
        }

        //计算下一个需要绘制的代码块的头部位置
        nextTop += next.h;
        //下一个需要绘制的代码块
        next = _items[index];
        //设置头部位置
        next.top = nextTop;
      }
      _showBottomIndex = index - 1;
    }
  }

  bool _isVisible(double top) {
    return top <= _screenH;
  }
}
