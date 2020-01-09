
import 'package:flutter/material.dart';
import 'package:flutter_draw_method/pages/method/model/call_draw_item.dart';

import 'helper/methoddraw_helper.dart';

class DrawDataProvider extends ChangeNotifier {

  MethodDrawHelper _drawHelper = MethodDrawHelper();

  MethodDrawHelper get drawHelper => _drawHelper;

  addCall(CallDrawItem callDrawItem) {
    if (callDrawItem == null) {
      return;
    }
    _drawHelper.addCall(callDrawItem);
    notifyListeners();
  }

  clearData() {
    _drawHelper.clear();
    notifyListeners();
  }


}