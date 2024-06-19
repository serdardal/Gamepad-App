import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gamepad/app_menu.dart';
import 'package:gamepad/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'gamepad_button.dart';

class ButtonsPage extends StatefulWidget {
  const ButtonsPage({Key? key}) : super(key: key);

  @override
  State<ButtonsPage> createState() => _ButtonsPageState();
}

class _ButtonsPageState extends State<ButtonsPage> {
  WebSocketChannel? channel;
  var isConnecting = false;
  Future<void> _connect() async {
    setState(() {
      isConnecting = true;
    });

    if (channel != null) {
      channel?.sink.close();
    }

    var baseUrl = await _getBaseUrl();
    var connectionUrl = '$baseUrl/gamepad';

    final httpClient = HttpClient();
    httpClient.connectionTimeout = const Duration(seconds: 5);
    try {
      WebSocket.connect(connectionUrl, customClient: httpClient).then((ws) {
        var newChannel = IOWebSocketChannel(ws);
        newChannel.stream.listen((event) {}, onDone: () {
          setState(() {
            channel = null;
          });
        }, onError: (err) {
          setState(() {
            channel = null;
          });
        });

        setState(() {
          channel = newChannel;
          isConnecting = false;
        });
      }, onError: (err) {
        _cancelConnecting(err);
      });
    } catch (err) {
      _cancelConnecting(err);
    }
  }

  void _cancelConnecting(dynamic err) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(err.toString()),
    ));
    setState(() {
      isConnecting = false;
    });
  }

  Future<String> _getBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getString(sharedPrefBaseUrlKey) ?? "");
  }

  @override
  Widget build(BuildContext context) {
    var buttonEnabled = channel == null && !isConnecting;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Buttons'),
          backgroundColor: Colors.blue,
        ),
        drawer: const AppMenu(),
        body: Column(
          children: <Widget>[
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                GamepadButton(
                    channel: channel, name: '1', symbol: 'A', button: 1),
                GamepadButton(
                    channel: channel, name: '2', symbol: 'B', button: 2),
                GamepadButton(
                    channel: channel, name: '3', symbol: 'X', button: 3),
                GamepadButton(
                    channel: channel, name: '4', symbol: 'Y', button: 4)
              ],
            )),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                GamepadButton(
                    channel: channel, name: '5', symbol: 'Up', button: 5),
                GamepadButton(
                    channel: channel, name: '6', symbol: 'Down', button: 6),
                GamepadButton(
                    channel: channel, name: '7', symbol: 'Left', button: 7),
                GamepadButton(
                    channel: channel, name: '8', symbol: 'Right', button: 8)
              ],
            )),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                GamepadButton(
                    channel: channel, name: '9', symbol: 'Start', button: 9),
                GamepadButton(
                    channel: channel, name: '10', symbol: 'Back', button: 10),
                Expanded(
                    flex: 2,
                    child: SizedBox(
                        height: 70,
                        child: Column(children: [
                          OutlinedButton(
                              onPressed: buttonEnabled ? _connect : null,
                              style: ButtonStyle(
                                  textStyle: MaterialStateProperty.all(
                                      TextStyle(
                                          color: buttonEnabled
                                              ? Colors.blue
                                              : Colors.grey))),
                              child: Text(
                                isConnecting ? 'Connecting...' : 'Connect',
                              )),
                          Text(channel == null ? 'Not Connected' : 'Connected',
                              style: TextStyle(
                                  color: channel == null
                                      ? Colors.red
                                      : Colors.green))
                        ])))
              ],
            ))
          ],
        ));
  }
}
