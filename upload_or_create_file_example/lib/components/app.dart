import "package:flutter/material.dart";
import "package:upload_or_create_file_example/components/setting_page.dart";


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
