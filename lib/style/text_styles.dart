import 'dart:io';

import 'package:flutter/rendering.dart';

class TS {
  final TextStyle display;
  final TextStyle button;

  TS._()
      : display = _buildDisplayStyle(Platform.isIOS),
        button = _buildButtonStyle(Platform.isIOS);

  static TS _base;

  static TS get base {
    if (_base == null) {
      _base = TS._();
    }
    return _base;
  }
}

TextStyle _buildDisplayStyle(bool isIOS) => TextStyle(
      inherit: false,
      fontFamily: isIOS ? 'SF Pro Display' : null,
    );

TextStyle _buildButtonStyle(bool isIOS) => TextStyle(
      inherit: false,
      fontFamily: isIOS ? 'SF Pro Display' : null,
      letterSpacing: 0.41,
    );
