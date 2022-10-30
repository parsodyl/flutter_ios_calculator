import 'package:flutter/cupertino.dart';
import 'package:flutter_ios_calculator/widget/functional/layout_helper.dart';

class KeyRow extends StatelessWidget {
  final List<Widget> children;

  const KeyRow({this.children});

  @override
  Widget build(BuildContext context) {
    final divider = SizedBox(width: LayoutHelper.of(context).dividerWidth);
    final elements = children.expand((child) {
      return (child != children.last) ? [child, divider] : [child];
    }).toList(growable: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: elements,
    );
  }
}
