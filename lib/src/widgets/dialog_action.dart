import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogAction {
  static open(BuildContext context, String title, String subtitle, Function pressYes ) {
    if (Platform.isIOS) {
      showDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(subtitle),
          actions: <Widget>[
            CupertinoDialogAction(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            CupertinoDialogAction(
              child: Text('Yes'),
              onPressed: () {
                pressYes();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        barrierDismissible: false,
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(title),
          content: Text(subtitle),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            FlatButton(
              onPressed: () {
                pressYes();
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    }
  }
}