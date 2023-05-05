import 'package:flutter/material.dart';

import 'components/setting_page.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Upload or create file example",
        theme: ThemeData(
          primaryColor: Colors.blue,
        ),
        home:const SettingsPage());
  }
}
