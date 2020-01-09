import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_draw_method/pages/method/helper/methoddraw_helper.dart';
import 'package:flutter_draw_method/res/colors.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/html.dart';

import 'chart_widget2.dart';
import 'draw_data_provider.dart';
import 'model/method_resp.dart';

class MethodPage extends StatefulWidget {
  @override
  _MethodPageState createState() => _MethodPageState();
}

class _MethodPageState extends State<MethodPage> {
  HtmlWebSocketChannel _channel;
  String _message;
  SocketStatus _socketStatus = SocketStatus.WAIT;
  String _errorMsg;
  DrawDataProvider _dataProvider;

  @override
  Widget build(BuildContext context) {
    print('_MethodPageState build');
    return SafeArea(
      child: Material(
        child: Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.lightBlue,
            child: Center(
              child: Column(
                children: <Widget>[_socketWidget(), _chartWidget()],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _chartWidget() {
    return Expanded(
      child: Container(
        child: RepaintBoundary(
          child: ChangeNotifierProvider.value(
            value: _dataProvider,
            child: ChartWidget2(),
          ),
        ),
      ),
      flex: 1,
    );
  }

  @override
  void initState() {
    super.initState();
    _dataProvider = DrawDataProvider();

//    MethodResp resp4 = MethodResp.fromJson(json.decode(Uri.decodeComponent(testJson2)));
//    _dataProvider.drawHelper.addCall(resp4.methodCall);

    _channel = HtmlWebSocketChannel.connect(
        "ws://172.16.128.58:8080/websocket/" + 'o');
    _channel.stream.listen((data) {
      print('websocket收到的消息：' + data.toString());
      if (data == null) {
        return;
      }
      Map<String, dynamic> _map = json.decode(data.toString());
      MethodResp resp = MethodResp.fromJson(_map);
      _dataProvider.addCall(resp?.methodCall);
      setState(() {
        _socketStatus = SocketStatus.SUCCESS;
      });
    }, onError: (e) {
      print('onError');
      setState(() {
        _errorMsg = e;
        _socketStatus = SocketStatus.ERROR;
      });
    }, onDone: () {
      print('onDone');
      setState(() {
        _socketStatus = SocketStatus.CLOSE;
      });
    }, cancelOnError: true);
  }

  @override
  void dispose() {}

  Widget _socketWidget() {
    return Container(
      color: Colours.socket_status_bg,
      child: Center(
        child: Text(
          'Socket连接状态：' + _socketTip(_socketStatus),
          style: TextStyle(fontSize: 13),
        ),
      ),
    );
  }

  String _socketTip(SocketStatus socketStatus) {
    String tip = '';
    if (socketStatus == SocketStatus.WAIT) {
      tip = '等待连接';
    } else if (socketStatus == SocketStatus.ERROR) {
      tip = '连接错误:' + (_errorMsg ?? '');
    } else if (socketStatus == SocketStatus.SUCCESS) {
      tip = '连接成功';
    } else if (socketStatus == SocketStatus.CLOSE) {
      tip = '连接关闭';
    }
    return tip;
  }
}

//socket连接状态
enum SocketStatus {
  WAIT, //等待连接
  SUCCESS, //连接成功
  ERROR, //连接失败
  CLOSE //关闭
}
