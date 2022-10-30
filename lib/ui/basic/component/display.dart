import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_ios_calculator/style/text_styles.dart';
import 'package:flutter_ios_calculator/ui/basic/model/basic_view_model.dart';
import 'package:provider/provider.dart';

class Display extends StatefulWidget {
  @override
  _DisplayState createState() => _DisplayState();
}

class _DisplayState extends State<Display> {

  static const internalPadding = 10.0;

  bool _selected = false;
  bool _swiped = false;

  String _currentContent = '';

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      color: _selected ? CupertinoColors.darkBackgroundGray : null,
      borderRadius: BorderRadius.all(Radius.circular(12)),
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanUpdate: (details) {
        if (!_swiped && (details.delta.dx > 0 || details.delta.dx < 0)) {
          _swiped = true;
          context.read<BasicViewModel>().swipeToCancel();
        }
      },
      onPanEnd: (_) {
        if (_swiped) {
          _swiped = false;
        }
      },
      onLongPress: () {
        if (!_selected) {
          setState(() {
            _selected = true;
          });
        }
      },
      onTap: () {
        if (_selected) {
          setState(() {
            _selected = false;
          });
        }
      },
      child: Container(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: internalPadding),
          child: DecoratedBox(
            decoration: decoration,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: internalPadding),
              child: Selector<BasicViewModel, String>(
                selector: (context, model) => model.output,
                builder: (context, output, _) {
                  _currentContent = output;
                  return AutoSizeText(
                    _currentContent,
                    style: TS.base.display.copyWith(
                      fontSize: 96,
                      fontWeight: FontWeight.w100,
                    ),
                    maxLines: 1,
                    textAlign: TextAlign.right,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
