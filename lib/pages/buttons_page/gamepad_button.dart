import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'models.dart';

class GamepadButton extends StatefulWidget {
  final WebSocketChannel? channel;
  final String name;
  final String symbol;
  final int button;
  const GamepadButton(
      {Key? key,
      required this.channel,
      required this.name,
      required this.symbol,
      required this.button})
      : super(key: key);

  @override
  State<GamepadButton> createState() => _GamepadButtonState();
}

class _GamepadButtonState extends State<GamepadButton> {
  void _onDown(TapDownDetails event) {
    widget.channel?.sink.add(jsonEncode(DataModel(widget.button, true)));
  }

  void _onUp(TapUpDetails event) {
    widget.channel?.sink.add(jsonEncode(DataModel(widget.button, false)));
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Expanded(
                  child: Material(
                    color: const Color.fromARGB(255, 255, 216, 157),
                    borderRadius:
                        const BorderRadiusDirectional.all(Radius.circular(10)),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadiusDirectional.all(
                                Radius.circular(10)),
                            border: Border.all()),
                        child: InkWell(
                          splashColor: const Color.fromARGB(255, 255, 190, 92),
                          borderRadius: BorderRadius.circular(10),
                          onTapDown: _onDown,
                          onTapUp: _onUp,
                          child: Column(children: [
                            Expanded(
                                flex: 3,
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Align(
                                            alignment: const Alignment(0, 0.4),
                                            child: Text(
                                              widget.name,
                                              style: const TextStyle(
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 25),
                                            )))
                                  ],
                                )),
                            Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Align(
                                            alignment:
                                                const Alignment(0.9, 0.9),
                                            child: Text(
                                              widget.symbol,
                                              style: const TextStyle(
                                                  color: Colors.purple,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            )))
                                  ],
                                ))
                          ]),
                        )),
                  ),
                )
              ],
            )));
  }
}
