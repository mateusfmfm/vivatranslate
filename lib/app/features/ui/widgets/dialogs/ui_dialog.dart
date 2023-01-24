import 'package:flutter/material.dart';

class UIDialog extends StatefulWidget {
  const UIDialog({super.key, required this.content});

  final List<Widget> content;

  @override
  State<UIDialog> createState() => _UIDialogState();
}

class _UIDialogState extends State<UIDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).backgroundColor,
      contentPadding: EdgeInsets.all(24),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: widget.content,
      ),
    );
  }
}
