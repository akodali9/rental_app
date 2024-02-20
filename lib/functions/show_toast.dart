import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showToast(BuildContext context, String text) {
  // final snackBar = SnackBar(content: Text(text));
  // ScaffoldMessenger.of(context).showSnackBar(snackBar);
  Fluttertoast.showToast(msg: text, );
}

