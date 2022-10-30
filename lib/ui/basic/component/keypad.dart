import 'package:flutter/cupertino.dart';
import 'package:flutter_ios_calculator/ui/basic/basic_view.dart';
import 'package:flutter_ios_calculator/ui/basic/model/basic_operator.dart';
import 'package:flutter_ios_calculator/ui/basic/model/basic_view_model.dart';
import 'package:flutter_ios_calculator/util/format_util.dart';
import 'package:flutter_ios_calculator/widget/applicative/key_row.dart';
import 'package:flutter_ios_calculator/widget/applicative/keys.dart';
import 'package:flutter_ios_calculator/widget/functional/layout_helper.dart';
import 'package:provider/provider.dart';
import 'package:touch_interceptor/touch_interceptor.dart';

class BasicKeyPad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final totalPadding = BasicView.sidePadding * 2;
    final totalWidth = MediaQuery.of(context).size.width - totalPadding;

    final buttonWidth = totalWidth * 0.22;
    final dividerWidth = (totalWidth - (buttonWidth * 4)) / 3;

    final divider = SizedBox(height: dividerWidth);

    Widget keypadRow1() {
      final btn1 = _CancelKey();
      final btn2 = _PlusMinusKey();
      final btn3 = _PercentageKey();
      final btn4 = const _OperatorKey(operator: BasicOperator.obelus);
      return KeyRow(children: <Widget>[btn1, btn2, btn3, btn4]);
    }

    Widget keypadRow2() {
      final btn1 = _buildNumberKey(7);
      final btn2 = _buildNumberKey(8);
      final btn3 = _buildNumberKey(9);
      final btn4 = const _OperatorKey(operator: BasicOperator.times);
      return KeyRow(children: <Widget>[btn1, btn2, btn3, btn4]);
    }

    Widget keypadRow3() {
      final btn1 = _buildNumberKey(4);
      final btn2 = _buildNumberKey(5);
      final btn3 = _buildNumberKey(6);
      final btn4 = const _OperatorKey(operator: BasicOperator.minus);
      return KeyRow(children: <Widget>[btn1, btn2, btn3, btn4]);
    }

    Widget keypadRow4() {
      final btn1 = _buildNumberKey(1);
      final btn2 = _buildNumberKey(2);
      final btn3 = _buildNumberKey(3);
      final btn4 = const _OperatorKey(operator: BasicOperator.plus);
      return KeyRow(children: <Widget>[btn1, btn2, btn3, btn4]);
    }

    Widget keypadRow5() {
      final btn1 = _buildZeroKey();
      final btn2 = _buildDecimalPointKey();
      final btn3 = const _EqualsKey();
      return KeyRow(children: <Widget>[btn1, btn2, btn3]);
    }

    return TouchInterceptor(
      child: LayoutHelper(
        buttonWidth: buttonWidth,
        dividerWidth: dividerWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            keypadRow1(),
            divider,
            keypadRow2(),
            divider,
            keypadRow3(),
            divider,
            keypadRow4(),
            divider,
            keypadRow5(),
            divider,
          ],
        ),
      ),
    );
  }

  static Widget _buildNumberKey(int number) {
    return _DigitKey(digit: '$number');
  }

  static Widget _buildZeroKey() {
    return const Expanded(
      child: const _DigitKey(digit: '0', isZero: true),
    );
  }

  Widget _buildDecimalPointKey() {
    return _DigitKey(digit: CalculatorFormatter().decimalSeparator);
  }
}

class _OperatorKey extends StatelessWidget {
  final BasicOperator operator;

  const _OperatorKey({
    Key key,
    this.operator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<BasicViewModel, bool>(
      selector: (context, model) => model.heldOperator == operator,
      builder: (context, isSelected, _) {
        return OrangeOrWhiteKey(
          symbol: operator.symbol,
          isHeld: isSelected,
          action: () => context.read<BasicViewModel>().pressOperator(operator),
        );
      },
    );
  }
}

class _DigitKey extends StatelessWidget {
  final String digit;
  final bool isZero;

  const _DigitKey({
    Key key,
    this.digit,
    this.isZero = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DarkGreyKey(
      symbol: digit,
      centerSymbol: !isZero,
      action: () => context.read<BasicViewModel>().pressDigit(digit),
    );
  }
}

class _EqualsKey extends StatelessWidget {
  const _EqualsKey({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrangeKey(
      symbol: '=',
      action: () => context.read<BasicViewModel>().pressEquals(),
    );
  }
}

class _CancelKey extends StatelessWidget {
  const _CancelKey({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<BasicViewModel, bool>(
      selector: (context, model) => model.isAllClearVisible,
      builder: (context, isAC, _) {
        return LightGreyKey(
          symbol: isAC ? 'AC' : 'C',
          action: () {
            final model = context.read<BasicViewModel>();
            return isAC ? model.pressAC() : model.pressC();
          },
        );
      },
    );
  }
}

class _PlusMinusKey extends StatelessWidget {
  const _PlusMinusKey({
    Key key,
  }) : super(key: key);

  static final _symbol = String.fromCharCode(0x207a) +
      String.fromCharCode(0x2044) +
      String.fromCharCode(0x208b);

  @override
  Widget build(BuildContext context) {
    return LightGreyKey(
      symbol: _symbol,
      action: () => context.read<BasicViewModel>().pressPlusMinus(),
    );
  }
}

class _PercentageKey extends StatelessWidget {
  const _PercentageKey({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LightGreyKey(
      symbol: '％',
      action: () => context.read<BasicViewModel>().pressPercentage(),
    );
  }
}
