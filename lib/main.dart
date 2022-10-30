import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ios_calculator/ui/basic/basic_view.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(CalculatorApp()));
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: CupertinoThemeData(
        brightness: Brightness.dark,
      ),
      home: BasicView(),
    );
  }
}
