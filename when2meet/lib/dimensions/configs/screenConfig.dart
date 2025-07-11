import 'dart:ui';

class ScreenConfig {
  static final ScreenConfig instance = ScreenConfig._internal();
  static const Map<String, double> screenRatio = {"width": 9, "height": 19.5};

  double screenWidth = 0;
  double screenHeight = 0;
  double widthGap = 0;
  double heightGap = 0;
  double w = 0;
  double h = 0;

  ScreenConfig._internal();

  //set all screen-related variables
  void updateScreenVariables(Size size) {
    if (screenRatio["width"]! / screenRatio["height"]! <
        size.longestSide / size.shortestSide) {
      screenHeight = size.shortestSide;
      screenWidth =
          screenHeight * screenRatio["width"]! / screenRatio["height"]!;
      heightGap = 0;
      widthGap = (size.longestSide - screenWidth) / 2;
    } else if (screenRatio["width"]! / screenRatio["height"]! >
        size.longestSide / size.shortestSide) {
      screenWidth = size.longestSide;
      screenHeight =
          size.longestSide * screenRatio["height"]! / screenRatio["width"]!;
      heightGap = (size.shortestSide - screenHeight) / 2;
      widthGap = 0;
    } else {
      screenWidth = size.longestSide;
      screenHeight = size.shortestSide;
      heightGap = 0;
      widthGap = 0;
    }

    w = size.longestSide;
    h = size.shortestSide;
  }
}
