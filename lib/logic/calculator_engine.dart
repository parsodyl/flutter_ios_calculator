import 'package:flutter_ios_calculator/logic/input_handler.dart';
import 'package:flutter_ios_calculator/logic/operation.dart';
import 'package:flutter_ios_calculator/logic/solver.dart';

enum CalculatorEngineState { idle, firstInput, otherInput, opHold, result }

class CalculatorEngine {
  CalculatorEngineState _currentState = CalculatorEngineState.idle;
  Solver _solver = Solver();
  InputHandler _inputHandler = InputHandler();
  bool _isClearAllEnabled = true;
  Operation _currentOperation;
  String _output = '0';

  bool get isClearAllEnabled => _isClearAllEnabled;

  Operation get currentOperation => _currentOperation;

  String get output => _output;

  bool get isThereAnOperationHeld =>
      _currentState == CalculatorEngineState.opHold;

  CalculatorEngine() {
    _attachInputToOutput();
  }

  void composeTerm(String char) {
    if (_currentState == CalculatorEngineState.idle && char == '0') {
      return;
    }
    _attachInputToOutput();
    _isClearAllEnabled = false;
    _addDigit(char);
    var nextState = _currentState;
    switch (_currentState) {
      case CalculatorEngineState.idle:
        nextState = CalculatorEngineState.firstInput;
        break;
      case CalculatorEngineState.opHold:
        nextState = CalculatorEngineState.otherInput;
        break;
      case CalculatorEngineState.result:
        nextState = CalculatorEngineState.firstInput;
        break;
      default:
        break;
    }
    _currentState = nextState;
  }

  void insertOperation(Operation operation) {
    _attachPreviewToOutput();
    _inputHandler.clear();
    _setOperation(operation);
    _currentState = CalculatorEngineState.opHold;
  }

  void swapSign() {
    _attachInputToOutput();
    var nextState = _currentState;
    switch (_currentState) {
      case CalculatorEngineState.idle:
        _inputHandler.addOrRemoveSign();
        nextState = CalculatorEngineState.firstInput;
        break;
      case CalculatorEngineState.firstInput:
        _inputHandler.addOrRemoveSign();
        break;
      case CalculatorEngineState.otherInput:
        _inputHandler.addOrRemoveSign();
        break;
      case CalculatorEngineState.opHold:
        _solver.changeSign();
        break;
      case CalculatorEngineState.result:
        _solver.changeSign();
        break;
    }
    _currentState = nextState;
  }

  void applyPercentage() {
    if (_currentState == CalculatorEngineState.idle) {
      return;
    }
    _attachPreviewToOutput();
    _solver.applyPercentage();
  }

  void clear() {
    if (_currentState == CalculatorEngineState.idle) {
      return;
    }
    _attachInputToOutput();
    _isClearAllEnabled = true;
    _clearTerm();
    var nextState = _currentState;
    switch (_currentState) {
      case CalculatorEngineState.otherInput:
        nextState = CalculatorEngineState.opHold;
        break;
      default:
        break;
    }
    _currentState = nextState;
  }

  void clearAll() {
    if (_currentState == CalculatorEngineState.idle) {
      return;
    }
    _attachPreviewToOutput();
    _currentOperation = null;
    _solver.clear();
    _currentState = CalculatorEngineState.idle;
  }

  void cancelDigit() {
    if (_currentState != CalculatorEngineState.firstInput &&
        _currentState != CalculatorEngineState.otherInput) {
      return;
    }
    _attachInputToOutput();
    _inputHandler.backCancel();
    _solver.addTerm(_inputHandler.toNumber);
  }

  void getResult() {
    _attachPreviewToOutput();
    _inputHandler.clear();
    _solver.getResult();
    _currentState = CalculatorEngineState.result;
  }

  void dispose() {
    _inputHandler.listenForInput(null);
    _solver.listenForPreview(null);
  }

  void _attachInputToOutput() {
    if (_inputHandler.hasInputListener) {
      return;
    }
    _solver.listenForPreview(null);
    _inputHandler.listenForInput((input) {
      _output = input;
    });
  }

  void _attachPreviewToOutput() {
    if (_solver.hasPreviewListener) {
      return;
    }
    _inputHandler.listenForInput(null);
    _solver.listenForPreview((preview) {
      _output = preview;
    });
  }

  void _addDigit(String char) {
    _inputHandler.addElement(char);
    _solver.addTerm(_inputHandler.toNumber);
  }

  void _setOperation(Operation operation) {
    _currentOperation = operation;
    _solver.addOperation(operation);
  }

  void _clearTerm() {
    _inputHandler.clear();
    _solver.addTerm(0);
  }
}
