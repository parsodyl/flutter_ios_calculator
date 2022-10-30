import 'package:flutter/widgets.dart';

class DecoratedCircle extends StatelessWidget {
  final double contentSize;
  final Color color;
  final bool centerChild;
  final Widget child;

  const DecoratedCircle({
    Key key,
    @required this.contentSize,
    @required this.child,
    this.color,
    this.centerChild = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sideSpace = (contentSize / 3);
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color,
        shape: StadiumBorder(),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SizedBox.square(dimension: contentSize),
          Positioned(
            left: !centerChild ? sideSpace : null,
            child: child,
          ),
        ],
      ),
    );
  }
}
