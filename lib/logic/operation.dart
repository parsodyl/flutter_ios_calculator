enum _OperationType {
  division,
  multiplication,
  subtraction,
  addition,
}

class Operation {
  final _OperationType _type;

  const Operation._(this._type);

  static const division = Operation._(_OperationType.division);
  static const multiplication = Operation._(_OperationType.multiplication);
  static const subtraction = Operation._(_OperationType.subtraction);
  static const addition = Operation._(_OperationType.addition);

  double apply(double leftOp, double rightOp) {
    assert(leftOp != null && rightOp != null);
    var result = 0.0;
    switch (_type) {
      case _OperationType.division:
        result = leftOp / rightOp;
        break;
      case _OperationType.multiplication:
        result = leftOp * rightOp;
        break;
      case _OperationType.subtraction:
        result = leftOp - rightOp;
        break;
      case _OperationType.addition:
        result = leftOp + rightOp;
        break;
    }
    return result;
  }

  bool get hasPriority =>
      _type == _OperationType.multiplication ||
      _type == _OperationType.division;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Operation &&
          runtimeType == other.runtimeType &&
          _type == other._type;

  @override
  int get hashCode => _type.hashCode;
}
