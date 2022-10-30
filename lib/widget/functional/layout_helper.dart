import 'package:flutter/widgets.dart';

class LayoutHelper extends InheritedWidget {
  final double buttonWidth;
  final double dividerWidth;

  LayoutHelper({
    Widget child,
    this.buttonWidth,
    this.dividerWidth,
  }) : super(child: child);

  @override
  bool updateShouldNotify(LayoutHelper oldWidget) {
    return oldWidget.buttonWidth != this.buttonWidth ||
        oldWidget.dividerWidth != this.dividerWidth;
  }

  static LayoutHelper of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<LayoutHelper>();
}
