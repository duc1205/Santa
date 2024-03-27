import 'dart:async';

import 'package:flutter/material.dart';

class DebounceTextfield extends StatefulWidget {
  final Function(String text) action;
  final VoidCallback? onTextfieldEmpty;
  final Duration duration;
  final double height;
  final Widget leadingWidget;
  final TextStyle textFieldStyle;
  final BoxDecoration textFieldDecoration;
  final InputDecoration inputDecoration;
  final TextDirection direction;
  final Widget clearButtonIcon;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final TextEditingController? controller;

  const DebounceTextfield({
    required this.action,
    this.controller,
    this.onTextfieldEmpty,
    this.duration = const Duration(milliseconds: 500),
    this.height = 40,
    this.leadingWidget = const SizedBox.shrink(),
    this.textFieldStyle = const TextStyle(fontSize: 13),
    this.textFieldDecoration = const BoxDecoration(color: Color(0xffE8E8E8)),
    this.inputDecoration = const InputDecoration.collapsed(
      hintText: 'Enter Your Text Here',
      hintStyle: TextStyle(fontSize: 13, color: Color(0xffaeaeae)),
    ),
    this.clearButtonIcon = const Icon(Icons.clear_rounded, color: Color(0xffaeaeae), size: 20),
    this.direction = TextDirection.ltr,
    this.margin = const EdgeInsets.fromLTRB(16, 8, 16, 8),
    this.padding = const EdgeInsets.fromLTRB(16, 8, 16, 8),
    Key? key,
  }) : super(key: key);

  @override
  State<DebounceTextfield> createState() => _DebounceTextfieldState();
}

class _DebounceTextfieldState extends State<DebounceTextfield> {
  late Function(String text) _action;
  late Duration _duration;
  late StreamController<bool> _btnClearController;
  late TextEditingController _inputController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _action = widget.action;
    _duration = widget.duration;
    _btnClearController = StreamController<bool>();
    _inputController = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    _btnClearController.close();
    _inputController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void runDebounce(String text) {
    _timer?.cancel();
    if (text.isNotEmpty) {
      _btnClearController.add(true);
      _timer = Timer(_duration, () => _action(text));
    } else {
      _btnClearController.add(false);
      if (widget.onTextfieldEmpty != null) {
        widget.onTextfieldEmpty!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.direction,
      child: TextFormField(
        controller: _inputController,
        onChanged: (value) => runDebounce(value),
        decoration: widget.inputDecoration,
        style: widget.textFieldStyle,
      ),
    );
  }
}
