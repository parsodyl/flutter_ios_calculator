import 'package:flutter_ios_calculator/logic/operation.dart';

class BasicOperator {
  final String symbol;

  const BasicOperator._(this.symbol);

  static const plus = BasicOperator._('+');
  static const minus = BasicOperator._('−');
  static const times = BasicOperator._('×');
  static const obelus = BasicOperator._('÷');

  factory BasicOperator.fromOperation(Operation operation) {
    if (operation == Operation.addition) {
      return BasicOperator.plus;
    }
    if (operation == Operation.subtraction) {
      return BasicOperator.minus;
    }
    if (operation == Operation.multiplication) {
      return BasicOperator.times;
    }
    if (operation == Operation.division) {
      return BasicOperator.obelus;
    }
    return null;
  }

  Operation toOperation() {
    switch (symbol) {
      case '+':
        return Operation.addition;
      case '−':
        return Operation.subtraction;
      case '×':
        return Operation.multiplication;
      case '÷':
        return Operation.division;
    }
    return null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BasicOperator &&
          runtimeType == other.runtimeType &&
          symbol == other.symbol;

  @override
  int get hashCode => symbol.hashCode;

  @override
  String toString() {
    return 'BasicOperator{symbol: $symbol}';
  }
}
