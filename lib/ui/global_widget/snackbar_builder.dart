import 'package:flutter/material.dart';
import 'package:salbang/resources/colors.dart';

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
