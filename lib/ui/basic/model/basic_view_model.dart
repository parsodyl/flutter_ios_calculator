import 'package:flutter/foundation.dart';
import 'package:flutter_ios_calculator/logic/calculator_engine.dart';
import 'package:flutter_ios_calculator/ui/basic/model/basic_operator.dart';

class BasicViewModel extends ChangeNotifier {
  final CalculatorEngine engine;

  BasicViewModel(this.engine);

  BasicOperator get heldOperator => engine.isThereAnOperationHeld
      ? BasicOperator.fromOperation(engine.currentOperation)
      : null;

  bool get isAllClearVisible => engine.isClearAllEnabled;

  String get output => engine.output;

  void pressOperator(BasicOperator operator) {
    engine.insertOperation(operator.toOperation());
    notifyListeners();
  }

  void pressDigit(String digit) {
    engine.composeTerm(digit);
    notifyListeners();
  }

  void pressEquals() {
    engine.getResult();
    notifyListeners();
  }

  void pressAC() {
    engine.clearAll();
    notifyListeners();
  }

  void pressC() {
    engine.clear();
    notifyListeners();
  }

  void pressPlusMinus() {
    engine.swapSign();
    notifyListeners();
  }

  void pressPercentage() {
    engine.applyPercentage();
    notifyListeners();
  }

  void swipeToCancel() {
    engine.cancelDigit();
    notifyListeners();
  }

  @override
  void dispose() {
    engine.dispose();
    super.dispose();
  }
}
