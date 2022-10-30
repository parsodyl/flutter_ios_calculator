import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ios_calculator/style/colors.dart';
import 'package:flutter_ios_calculator/widget/functional/layout_helper.dart';
import 'package:flutter_ios_calculator/widget/generic/button_content.dart';
import 'package:flutter_ios_calculator/widget/generic/color_animation.dart';
import 'package:flutter_ios_calculator/widget/generic/decorated_circle.dart';

typedef KeyAction = void Function();

class LightGreyKey extends StatelessWidget {
  final String symbol;
  final KeyAction action;
  final bool bold;

  const LightGreyKey({
    @required this.symbol,
    this.bold = true,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final content = ButtonContent(
      symbol: symbol,
      txtColor: CupertinoColors.black,
      fontSize: 32,
      fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
    );
    return AnimateColorOnTap(
      onTap: () {
        SystemSound.play(SystemSoundType.click);
        action?.call();
      },
      baseColor: kLightGrey,
      builder: (context, colorValue) => DecoratedCircle(
        contentSize: LayoutHelper.of(context).buttonWidth,
        color: colorValue,
        child: content,
      ),
    );
  }
}

class DarkGreyKey extends StatelessWidget {
  final String symbol;
  final bool centerSymbol;
  final KeyAction action;

  const DarkGreyKey({
    @required this.symbol,
    this.centerSymbol = true,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final content = ButtonContent(
      symbol: symbol,
      fontSize: 34,
      heightPercentage: 1.3,
    );
    return AnimateColorOnTap(
      onTap: () {
        SystemSound.play(SystemSoundType.click);
        action?.call();
      },
      baseColor: kDarkGrey,
      builder: (context, colorValue) => DecoratedCircle(
        contentSize: LayoutHelper.of(context).buttonWidth,
        color: colorValue,
        centerChild: centerSymbol,
        child: content,
      ),
    );
  }
}

class OrangeKey extends StatelessWidget {
  final String symbol;
  final KeyAction action;

  const OrangeKey({
    @required this.symbol,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final content = ButtonContent(
      symbol: symbol,
      fontSize: 44,
      heightPercentage: 1,
    );
    return AnimateColorOnTap(
      onTap: () {
        SystemSound.play(SystemSoundType.click);
        action?.call();
      },
      baseColor: kVibrantOrange,
      builder: (context, colorValue) => DecoratedCircle(
        contentSize: LayoutHelper.of(context).buttonWidth,
        color: colorValue,
        child: content,
      ),
    );
  }
}

class OrangeOrWhiteKey extends StatelessWidget {
  final String symbol;
  final bool isHeld;
  final KeyAction action;

  const OrangeOrWhiteKey({
    @required this.symbol,
    this.isHeld = false,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final content = ButtonContent(
      symbol: symbol,
      txtColor: isHeld ? kVibrantOrange : CupertinoColors.white,
      fontSize: 44,
      heightPercentage: 0.98,
    );
    return ChangeColorOnTap(
      onTap: () {
        SystemSound.play(SystemSoundType.click);
        action?.call();
      },
      baseColor: isHeld ? CupertinoColors.white : kVibrantOrange,
      heldDownColor: kLightedOrange,
      builder: (context, colorValue) => DecoratedCircle(
        contentSize: LayoutHelper.of(context).buttonWidth,
        color: colorValue,
        child: content,
      ),
    );
  }
}
