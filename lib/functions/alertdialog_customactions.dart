import 'package:flutter/material.dart';

Future<dynamic> showAlertDialog(BuildContext context, String content,
    List<String> actions, List<VoidCallback> actionCallbacks) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      elevation: 10,
      content: Text(
        content,
        style: const TextStyle(fontSize: 18),
      ),
      actions: List<Widget>.generate(
        actions.length,
        (int length) {
          return TextButton(
            onPressed: actionCallbacks[length],
            child: Text(actions[length], style: const TextStyle(fontSize: 16),),
          );
        },
      ),
    ),
  );
}
