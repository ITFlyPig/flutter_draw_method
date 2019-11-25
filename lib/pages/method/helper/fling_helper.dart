import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/scheduler.dart';

///实现fling效果
typedef FlingUpdate = void Function(double pos, double dx);
typedef OnDone = void Function();

class FlingHelper {
  FrictionSimulation _frictionSimulation;
  FlingUpdate _flingUpdate;
  OnDone _onDone;
  double _lastPosition = 0;
  bool _isStop = false;
  Ticker _ticker;


  addUpdateListener(FlingUpdate flingUpdate,OnDone onDone ) {
    _flingUpdate = flingUpdate;
    _onDone = onDone;

  }

  onFrame(double time) {
    if(_isStop) {
      return;
    }
    if(_frictionSimulation.isDone(time)) {
      stop();
      _onDone?.call();

    } else {
      double newPosition = _frictionSimulation.x(time);
      double dy = newPosition - _lastPosition;
      _flingUpdate?.call(newPosition, dy);
      _lastPosition = newPosition;
    }
  }

  stop() {
    _isStop = true;
    if(_ticker != null) {
      _ticker.stop();
    }
  }

  startFling(
      double drag, //阻力系数
      double position, //当前位置
      double velocity, //开始速度
      double min, //最小位置
      double max //最大位置
      ) {
    _isStop = false;
    if(_ticker == null) {
      ///每一帧渲染的时候回调
     _ticker = Ticker((elapsed){

       final double elapsedInSeconds = elapsed.inMicroseconds.toDouble() / Duration.microsecondsPerSecond;
       onFrame(elapsedInSeconds);
     });
    }
   if(!_ticker.isTicking ) {
     _ticker.start();
   }

    _frictionSimulation = FrictionSimulation(drag, position, velocity);
  }



}
