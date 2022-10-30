import 'package:flutter/cupertino.dart';
import 'package:flutter_ios_calculator/logic/calculator_engine.dart';
import 'package:flutter_ios_calculator/ui/basic/component/display.dart';
import 'package:flutter_ios_calculator/ui/basic/component/keypad.dart';
import 'package:flutter_ios_calculator/ui/basic/model/basic_view_model.dart';
import 'package:provider/provider.dart';

class BasicView extends StatelessWidget {
  static const sidePadding = 16.0;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BasicViewModel>(
      create: (context) => BasicViewModel(CalculatorEngine()),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: sidePadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Display(),
              BasicKeyPad(),
            ],
          ),
        ),
      ),
    );
  }
}
