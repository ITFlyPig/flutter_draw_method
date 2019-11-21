
import 'call_draw_item.dart';

class MethodResp {
  CallDrawItem methodCall;

  MethodResp({this.methodCall});

  MethodResp.fromJson(Map<String, dynamic> json) {
    methodCall = json['methodCall'] != null
        ? CallDrawItem.fromJson(json['methodCall'], null)
        : null;
  }
}