import 'dart:collection';

import 'package:flutter_ios_calculator/util/format_util.dart';

typedef InputListener = void Function(String input);

class InputHandler {
  static String get _decimalDivider => CalculatorFormatter().decimalSeparator;

  Queue<String> _digitBuffer = Queue();
  InputListener _listener;

  bool get _isPointInserted =>
      _digitBuffer.toList(growable: false).contains(_decimalDivider);

  void addElement(final String e) {
    assert(e != null && e.length == 1);
    if (e == _decimalDivider) {
      _insertPoint();
    }
    if (e == '0') {
      _insertZero();
    }
    if (e != '0' && _isNumeric(e)) {
      _insert(e);
    }
    _updateInput();
  }

  void addOrRemoveSign() {
    if (_digitBuffer.isEmpty) {
      _insert('-');
    } else {
      _swapSign();
    }
    _updateInput();
  }

  void backCancel() {
    if (_digitBuffer.isNotEmpty) {
      _digitBuffer.removeLast();
    }
    _updateInput();
  }

  void clear() {
    _digitBuffer.clear();
    _updateInput();
  }

  void listenForInput(InputListener listener) {
    _listener = listener;
  }

  bool get hasInputListener => _listener != null;

  String get currentInput {
    if (_digitBuffer.length == 1 && _digitBuffer.first == '-') {
      return '-0';
    }
    if (_digitBuffer.isNotEmpty) {
      final chain = (StringBuffer()..writeAll(_digitBuffer)).toString();
      return CalculatorFormatter().formatInput(chain);
    }
    return '0';
  }

  double get toNumber =>
      CalculatorFormatter().parseFormattedInput(currentInput);

  void _updateInput() {
    _listener?.call(currentInput);
  }

  void _insert(String d) {
    final limit = _isPointInserted ? 10 : 9;
    if (_digitBuffer.length < limit) {
      _digitBuffer.add(d);
    }
  }

  void _insertPoint() {
    if (_digitBuffer.isEmpty) {
      _digitBuffer.add('0');
      _digitBuffer.add(_decimalDivider);
      return;
    }
    if (!_isPointInserted) {
      _insert(_decimalDivider);
      return;
    }
  }

  void _insertZero() {
    if (_digitBuffer.isNotEmpty) {
      _insert('0');
    }
  }

  void _swapSign() {
    if (_digitBuffer.first == '-') {
      _digitBuffer.removeFirst();
    } else {
      _digitBuffer.addFirst('-');
    }
  }

  bool _isNumeric(String str) => double.tryParse(str) != null;
}
