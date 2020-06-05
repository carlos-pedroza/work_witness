import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Utils {
  static void showOk(BuildContext context, String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      backgroundColor: Colors.green,
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  static void showError(BuildContext context, String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      backgroundColor: Colors.red,
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  static void showAlertDialogBox(
    BuildContext context,
    String title,
    String content,
    String labelButton,
    Function callBack,
  ) {
    if (Platform.isIOS) {
      showDialog(
        context: context,
        builder: (BuildContext context) => new CupertinoAlertDialog(
          title: new Text(title),
          content: new Text(content),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: new Text(labelButton),
              onPressed: () {
                callBack();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => new AlertDialog(
          title: new Text(title),
          content: new Text(content),
          actions: [
            FlatButton(
              child: Text(labelButton),
              onPressed: () {
                callBack();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }
}
