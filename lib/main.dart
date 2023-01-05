import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock/wakelock.dart';

import 'pages/buttons_page/buttons_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // use app in landscape orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // prevent screen off with wakelock
    Wakelock.enable();

    return MaterialApp(
      title: 'Gamepad',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ButtonsPage(),
    );
  }
}
