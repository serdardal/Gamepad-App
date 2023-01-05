import 'package:flutter/material.dart';
import 'package:gamepad/pages/settings_page/settings_form.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: const SingleChildScrollView(child: SettingsForm()));
  }
}
