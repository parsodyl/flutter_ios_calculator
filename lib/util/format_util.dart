import 'dart:io';

import 'package:intl/intl.dart';

class CalculatorFormatter {
  static CalculatorFormatter _instance;

  factory CalculatorFormatter() =>
      _instance ?? (_instance = CalculatorFormatter._(Platform.localeName));

  CalculatorFormatter._(this._localeName);

  final String _localeName;

  String get decimalSeparator => _getNumberFormat().format(0.1)[1];

  String formatPreview(num number) {
    if (!number.isFinite) {
      return 'Error';
    }
    final nf = _getNumberFormat();
    if (number.abs() >= 1000000000) {
      final exp = number.toDouble().toStringAsExponential(6);
      return _splitTransformFirstPartJoin(exp, 'e', (firstPart) {
        nf.maximumFractionDigits = 6;
        return nf.format(double.parse(firstPart));
      });
    } else if (number.abs() > 0 && number.abs() < 0.00000001) {
      final exp = number.toDouble().toStringAsExponential(5);
      return _splitTransformFirstPartJoin(exp, 'e', (firstPart) {
        nf.maximumFractionDigits = 5;
        return nf.format(double.parse(firstPart));
      });
    } else {
      final intDigits = number.truncate().toString().length;
      nf.maximumFractionDigits = 9 - intDigits;
      return nf.format(number);
    }
  }

  String formatInput(String input) {
    final nf = _getNumberFormat();
    return _splitTransformFirstPartJoin(input, decimalSeparator, (firstPart) {
      return nf.format(nf.parse(firstPart));
    });
  }

  double parseFormattedInput(String formattedInput) {
    final nf = _getNumberFormat();
    return nf.parse(formattedInput).toDouble();
  }

  NumberFormat _getNumberFormat() => NumberFormat.decimalPattern(_localeName);
}

String _splitTransformFirstPartJoin(
    String source, String splitter, String transform(String firstPart)) {
  return source.splitMapJoin(splitter, onNonMatch: (part) {
    if (part == source.split(splitter)[0]) {
      return transform(part);
    }
    return part;
  });
}
