import 'package:flutter/widgets.dart';
import 'package:touch_interceptor/touch_interceptor.dart';

typedef ColorBuilder = Widget Function(BuildContext context, Color value);

class AnimateColorOnTap extends StatefulWidget {
  final Color baseColor;
  final ColorBuilder builder;
  final GestureTapCallback onTap;

  const AnimateColorOnTap({
    @required this.baseColor,
    @required this.builder,
    this.onTap,
  });

  @override
  _AnimateColorOnTapState createState() => _AnimateColorOnTapState();
}

class _AnimateColorOnTapState extends State<AnimateColorOnTap>
    with SingleTickerProviderStateMixin {

  static const fadeInDuration = Duration(milliseconds: 20);
  static const fadeOutDuration = Duration(milliseconds: 480);

  final ColorTween _colorTween = ColorTween();

  AnimationController _controller;
  Animation<Color> _colorAnimation;

  bool _buttonHeldDown = false;

  @override
  void initState() {
    _controller = AnimationController(value: 0.0, vsync: this);
    _colorAnimation =
        _controller.drive(CurveTween(curve: Curves.easeOut)).drive(_colorTween);
    _setTween();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller = null;
    super.dispose();
  }

  @override
  void didUpdateWidget(AnimateColorOnTap old) {
    super.didUpdateWidget(old);
    _setTween();
  }

  void _setTween() {
    _colorTween.begin = widget.baseColor;
    _colorTween.end =
        HSLColor.fromColor(widget.baseColor).withLightness(0.75).toColor();
  }

  void _handleTapStart() {
    if (!_buttonHeldDown) {
      _buttonHeldDown = true;
      _animate();
    }
  }

  void _handleTapCancel() {
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
      _animate();
    }
  }

  void _animate() {
    if (_controller.isAnimating) {
      _controller.animateTo(0.0, duration: fadeInDuration);
      return;
    }
    final  wasHeldDown = _buttonHeldDown;
    final ticker = _buttonHeldDown
        ? _controller.animateTo(1.0, duration: fadeInDuration)
        : _controller.animateTo(0.0, duration: fadeOutDuration);
    ticker.then((_) {
      if (mounted && wasHeldDown != _buttonHeldDown) _animate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return TouchConsumer(
      onTouchDown: _handleTapStart,
      onTouchEnter: _handleTapStart,
      onTouchExit: _handleTapCancel,
      onTouchUp: () {
        _handleTapCancel();
        widget.onTap?.call();
      },
      child: AnimatedBuilder(
        animation: _colorAnimation,
        builder: (context, _) => widget.builder(
          context,
          _colorAnimation.value,
        ),
      ),
    );
  }
}

class ChangeColorOnTap extends StatefulWidget {
  final Color baseColor;
  final Color heldDownColor;
  final ColorBuilder builder;
  final GestureTapCallback onTap;

  const ChangeColorOnTap({
    Key key,
    @required this.baseColor,
    @required this.heldDownColor,
    @required this.builder,
    this.onTap,
  }) : super(key: key);

  @override
  _ChangeColorOnTapState createState() => _ChangeColorOnTapState();
}

class _ChangeColorOnTapState extends State<ChangeColorOnTap> {
  bool _buttonHeldDown = false;

  @override
  void initState() {
    super.initState();
  }

  void _handleTapStart() {
    if (!_buttonHeldDown) {
      setState(() => _buttonHeldDown = true);
    }
  }

  void _handleTapCancel() {
    if (_buttonHeldDown) {
      setState(() => _buttonHeldDown = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TouchConsumer(
      onTouchDown: _handleTapStart,
      onTouchEnter: _handleTapStart,
      onTouchExit: _handleTapCancel,
      onTouchUp: () {
        _handleTapCancel();
        widget.onTap?.call();
      },
      child: Builder(builder: (context) {
        final color = _buttonHeldDown ? widget.heldDownColor : widget.baseColor;
        return widget.builder(context, color);
      }),
    );
  }
}
