import 'package:flutter/cupertino.dart';
import 'package:flutter_ios_calculator/style/text_styles.dart';

class ButtonContent extends StatelessWidget {
  final String symbol;
  final Color txtColor;
  final double fontSize;
  final double heightPercentage;
  final FontWeight fontWeight;

  const ButtonContent({
    this.symbol = '',
    this.txtColor = CupertinoColors.white,
    this.fontSize = 42.0,
    this.heightPercentage,
    this.fontWeight = FontWeight.w400,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = TS.base.button;
    final style = baseStyle.copyWith(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: txtColor,
      height: heightPercentage,
    );
    return FittedBox(
      fit: BoxFit.fitHeight,
      alignment: Alignment.center,
      child: Text(
        symbol,
        style: style,
        softWrap: true,
        textAlign: TextAlign.center,
        maxLines: 1,
      ),
    );
  }
}
