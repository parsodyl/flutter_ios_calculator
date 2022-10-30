import 'package:flutter_ios_calculator/logic/operation.dart';
import 'package:flutter_ios_calculator/util/format_util.dart';

typedef PreviewListener = void Function(String preview);

class Solver {
  final _masterSolver = MasterSolver();
  PreviewListener _listener;

  void addTerm(double term) {
    _masterSolver.addTerm(term);
    _updatePreview();
  }

  void addOperation(Operation operation) {
    _masterSolver.addOperation(operation);
    _updatePreview();
  }

  void changeSign() {
    _masterSolver.changeSign();
    _updatePreview();
  }

  void applyPercentage() {
    _masterSolver.applyPercentage();
    _updatePreview();
  }

  void getResult() {
    _masterSolver.result();
    _updatePreview();
  }

  void clear() {
    _masterSolver.clear();
    _updatePreview();
  }

  void listenForPreview(PreviewListener listener) {
    _listener = listener;
  }

  bool get hasPreviewListener => _listener != null;

  void _updatePreview() {
    if (_listener != null) {
      _listener(_format(_masterSolver.preview()));
    }
  }

  static String _format(double value) {
    return CalculatorFormatter().formatPreview(value);
  }
}

class MasterSolver {
  double firstTerm;
  Operation firstOperation;
  double secondTerm;
  Operation secondOperation;
  bool needsSlave = false;
  SlaveSolver slaveSolver;
  bool willRemoveSlave = false;
  double tempPercentage;
  double rate;
  bool resultRemembered = false;

  void addTerm(double term) {
    if (tempPercentage != null) {
      _removeTempPercentage();
    }
    if (resultRemembered) {
      firstTerm = term;
      return;
    }
    if (firstTerm == null) {
      firstTerm = term;
      return;
    }
    if (firstOperation == null) {
      firstTerm = term;
      return;
    }
    if (secondTerm == null) {
      secondTerm = term;
      return;
    }
    if (secondOperation == null) {
      secondTerm = term;
      return;
    }
    if (slaveSolver == null) {
      if (needsSlave) {
        slaveSolver = SlaveSolver(secondTerm, secondOperation);
        slaveSolver.addTerm(term);
      } else {
        _reduceMaster(term);
      }
      return;
    }
    if (!willRemoveSlave) {
      slaveSolver.addTerm(term);
    } else {
      _reduceSlave(term);
      _removeSlave();
    }
  }

  void addOperation(Operation op) {
    if (tempPercentage != null) {
      _removeTempPercentage();
    }
    if (resultRemembered) {
      resultRemembered = false;
      secondTerm = null;
      firstOperation = op;
      return;
    }
    if (firstTerm == null) {
      firstTerm = 0.0;
      firstOperation = op;
      return;
    }
    if (firstOperation == null) {
      firstOperation = op;
      return;
    }
    if (secondTerm == null) {
      firstOperation = op;
      return;
    }
    if (slaveSolver == null) {
      secondOperation = op;
      if (!firstOperation.hasPriority && secondOperation.hasPriority) {
        needsSlave = true;
      } else {
        needsSlave = false;
      }
      return;
    }
    if (op.hasPriority) {
      willRemoveSlave = false;
      slaveSolver.addOperation(op);
    } else {
      willRemoveSlave = true;
      secondOperation = op;
      slaveSolver.removeSpareOperation();
    }
  }

  void changeSign() {
    if (tempPercentage != null) {
      _removeTempPercentage();
    }
    if (resultRemembered) {
      firstTerm = -firstTerm;
      return;
    }
    if (firstTerm == null) {
      firstTerm = -0;
      return;
    }
    if (firstOperation == null) {
      firstTerm = -firstTerm;
      return;
    }
    if (secondTerm == null) {
      secondTerm = -0;
      return;
    }
    if (secondOperation == null) {
      secondTerm = -secondTerm;
      return;
    }
    if (slaveSolver == null) {
      if (needsSlave) {
        slaveSolver = SlaveSolver(secondTerm, secondOperation);
        slaveSolver.addTerm(-0);
      } else {
        addTerm(-0);
      }
      return;
    }
    if (!willRemoveSlave) {
      slaveSolver.changeSign();
    } else {
      addTerm(-0);
    }
  }

  void applyPercentage() {
    if (tempPercentage != null) {
      if (rate != null) {
        tempPercentage *= rate;
      } else {
        tempPercentage /= 100;
      }
      return;
    }
    if (resultRemembered) {
      firstTerm = firstTerm / 100;
      return;
    }
    if (firstTerm == null) {
      return;
    }
    if (firstOperation == null) {
      firstTerm = firstTerm / 100;
      return;
    }
    if (secondTerm == null) {
      tempPercentage = _calculatePercentage(firstTerm, firstOperation);
      return;
    }
    if (secondOperation == null) {
      secondTerm = _calculatePercentage(firstTerm, firstOperation, secondTerm);
      return;
    }
    if (slaveSolver == null) {
      if (needsSlave) {
        tempPercentage = _calculatePercentage(secondTerm, secondOperation);
      } else {
        if (secondOperation.hasPriority) {
          final reducedTerm = firstOperation.apply(firstTerm, secondTerm);
          tempPercentage = _calculatePercentage(reducedTerm, secondOperation);
          return;
        } else {
          rate = secondTerm / 100;
          final reducedTerm = firstOperation.apply(firstTerm, secondTerm);
          tempPercentage = reducedTerm * rate;
          return;
        }
      }
      return;
    }
    if (!willRemoveSlave) {
      slaveSolver.applyPercentage();
    } else {
      rate = slaveSolver.secondTerm / 100;
      final reducedTerm =
          firstOperation.apply(firstTerm, slaveSolver.preview(full: true));
      tempPercentage = reducedTerm * rate;
    }
  }

  double preview() {
    if (tempPercentage != null) {
      return tempPercentage;
    }
    if (resultRemembered) {
      return firstTerm;
    }
    if (firstOperation == null) {
      return firstTerm ?? 0;
    }
    if (secondTerm == null) {
      return firstTerm;
    }
    if (secondOperation == null) {
      return secondTerm;
    }
    if (slaveSolver == null) {
      if (needsSlave) {
        return secondTerm;
      } else {
        return firstOperation.apply(firstTerm, secondTerm);
      }
    }
    if (!willRemoveSlave) {
      return slaveSolver.preview();
    } else {
      return firstOperation.apply(firstTerm, slaveSolver.preview(full: true));
    }
  }

  double result() {
    if (firstOperation == null) {
      final result = firstTerm ?? 0;
      return _setAndReturnResult(result);
    }
    if (secondTerm == null) {
      secondTerm = tempPercentage != null ? tempPercentage : firstTerm;
      _removeTempPercentage();
      return firstOperation.apply(firstTerm, secondTerm);
    }
    if (secondOperation == null) {
      final result = firstOperation.apply(firstTerm, secondTerm);
      return _setAndReturnResult(result);
    }
    if (slaveSolver == null) {
      if (needsSlave) {
        slaveSolver = SlaveSolver(secondTerm, secondOperation);
        slaveSolver
            .addTerm(tempPercentage != null ? tempPercentage : secondTerm);
        _removeTempPercentage();
        final result = firstOperation.apply(firstTerm, slaveSolver.result());
        return _setAndReturnResult(result);
      } else {
        _reduceMaster();
        secondTerm = tempPercentage != null ? tempPercentage : firstTerm;
        _removeTempPercentage();
        final result = firstOperation.apply(firstTerm, secondTerm);
        return _setAndReturnResult(result);
      }
    }
    if (!willRemoveSlave) {
      final result = firstOperation.apply(firstTerm, slaveSolver.result());
      return _setAndReturnResult(result);
    } else {
      _reduceSlave();
      _removeSlave();
      secondTerm = tempPercentage != null ? tempPercentage : firstTerm;
      _removeTempPercentage();
      final result = firstOperation.apply(firstTerm, secondTerm);
      return _setAndReturnResult(result);
    }
  }

  void clear() {
    resultRemembered = false;
    _removeTempPercentage();
    _removeSlave();
    secondOperation = null;
    secondTerm = null;
    firstOperation = null;
    firstTerm = null;
  }

  void _reduceMaster([double newTerm]) {
    firstTerm = firstOperation.apply(firstTerm, secondTerm);
    firstOperation = secondOperation;
    secondTerm = newTerm ?? firstTerm;
    secondOperation = null;
  }

  void _reduceSlave([double newTerm]) {
    secondTerm = slaveSolver.result();
    firstTerm = firstOperation.apply(firstTerm, secondTerm);
    firstOperation = secondOperation;
    secondTerm = newTerm ?? firstTerm;
    secondOperation = null;
  }

  void _removeSlave() {
    slaveSolver = null;
    needsSlave = false;
    willRemoveSlave = false;
  }

  void _removeTempPercentage() {
    tempPercentage = null;
    rate = null;
  }

  double _setAndReturnResult(double result) {
    resultRemembered = true;
    firstTerm = result;
    if (slaveSolver != null) {
      firstOperation = slaveSolver.firstOperation;
      secondTerm = slaveSolver.secondTerm;
      _removeSlave();
    }
    secondOperation = null;
    return result;
  }
}

class SlaveSolver {
  double firstTerm;
  Operation firstOperation;
  double secondTerm;
  Operation secondOperation;
  double tempPercentage;

  SlaveSolver(this.firstTerm, this.firstOperation) {
    assert(firstTerm != null && firstOperation != null);
    assert(firstOperation.hasPriority);
  }

  void addTerm(double term) {
    if (tempPercentage != null) {
      tempPercentage = null;
    }
    if (secondTerm == null) {
      secondTerm = term;
      return;
    }
    if (secondOperation == null) {
      secondTerm = term;
      return;
    }
    _reduce(term);
  }

  void addOperation(Operation op) {
    assert(op.hasPriority);
    if (tempPercentage != null) {
      tempPercentage = null;
    }
    if (secondTerm == null) {
      firstOperation = op;
      return;
    }
    secondOperation = op;
  }

  void changeSign() {
    if (tempPercentage != null) {
      tempPercentage = null;
    }
    if (secondTerm == null) {
      secondTerm = -0;
      return;
    }
    if (secondOperation == null) {
      secondTerm = -secondTerm;
      return;
    }
    addTerm(-0);
  }

  void applyPercentage() {
    if (tempPercentage != null) {
      tempPercentage /= 100;
    }
    if (secondTerm == null) {
      tempPercentage = _calculatePercentage(firstTerm, firstOperation);
      return;
    }
    if (secondOperation == null) {
      secondTerm = _calculatePercentage(firstTerm, firstOperation, secondTerm);
      return;
    }
    final reducedTerm = firstOperation.apply(firstTerm, secondTerm);
    tempPercentage = _calculatePercentage(reducedTerm, secondOperation);
  }

  void removeSpareOperation() {
    if (tempPercentage != null) {
      tempPercentage = null;
    }
    if (secondOperation == null) {
      return;
    }
    secondOperation = null;
  }

  double preview({bool full = false}) {
    if (tempPercentage != null) {
      return tempPercentage;
    }
    if (secondTerm == null) {
      return firstTerm;
    }
    if (secondOperation == null && !full) {
      return secondTerm;
    }
    return firstOperation.apply(firstTerm, secondTerm);
  }

  double result() {
    if (secondTerm == null) {
      secondTerm = tempPercentage != null ? tempPercentage : firstTerm;
      tempPercentage = null;
      return firstOperation.apply(firstTerm, secondTerm);
    }
    if (secondOperation == null) {
      return firstOperation.apply(firstTerm, secondTerm);
    }
    _reduce();
    secondTerm = tempPercentage != null ? tempPercentage : firstTerm;
    tempPercentage = null;
    return firstOperation.apply(firstTerm, secondTerm);
  }

  void _reduce([double newTerm]) {
    firstTerm = firstOperation.apply(firstTerm, secondTerm);
    firstOperation = secondOperation;
    secondTerm = newTerm ?? firstTerm;
    secondOperation = null;
  }
}

double _calculatePercentage(double a, Operation op, [double b]) {
  assert(a != null && op != null);
  if (op.hasPriority) {
    return (b ?? a) / 100;
  } else {
    return a * ((b ?? a) / 100);
  }
}
