import 'package:flutter/material.dart';
import 'package:gamepad/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({super.key});

  @override
  State<StatefulWidget> createState() {
    return SettingsFormState();
  }
}

class SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getSavedUrl();
  }

  @override
  void dispose() {
    urlController.dispose();
    super.dispose();
  }

  Future<void> _getSavedUrl() async {
    final prefs = await SharedPreferences.getInstance();
    urlController.text = (prefs.getString(sharedPrefBaseUrlKey) ?? "");
  }

  Future<void> _saveUrl() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(sharedPrefBaseUrlKey, urlController.text);
  }

  void _onSavePressed() {
    if (_formKey.currentState!.validate()) {
      _saveUrl();

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Url saved."),
      ));

      // close the keyboard
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Base Url', hintText: 'ws://123.456.7.89:1234'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter url.';
                  }
                  return null;
                },
                controller: urlController,
                autocorrect: false,
              ),
              ElevatedButton(
                  onPressed: _onSavePressed, child: const Text('Save'))
            ],
          ),
        ));
  }
}
