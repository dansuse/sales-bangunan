import 'package:salbang/resources/colors.dart';
import 'package:flutter/material.dart';

class SnackbarBuilder {
  static Widget getSnackbar(String content, String actionLabel,
      {int duration = 3}) {
    return SnackBar(
      backgroundColor: colorAccent,
      content: new Text(content),
      action: new SnackBarAction(
        label: actionLabel,
        onPressed: () {},
      ),
      duration: new Duration(seconds: duration),
    );
  }
}
