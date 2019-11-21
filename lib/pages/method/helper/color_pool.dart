import 'dart:math';

import 'dart:ui';


class ColorPool {
  static List<Color> colors = [
    Color(0xffcf1322),
    Color(0xffad4e00),
    Color(0xff876800),
    Color(0xff3f6600),
    Color(0xff006d75),
    Color(0xff391085),
    Color(0xffeb2f96),
    Color(0xff722ed1),
    Color(0xff5a5a5a),
    Color(0xffffc53d),
    Color(0xffad6800),
    Color(0xff795548),
    Color(0xffff5722),
    Color(0xff43a047),
    Color(0xff0288d1),
    Color(0xffe57373),
    Color(0xffffab00),
    Color(0xff009688),
  ];

  ///随机的颜色
  static Color randomColor() {
    int min = 0;
    int max = colors.length - 1;
    int pos = Random().nextInt(max - min) + min;
    return colors[pos];
  }
}
