import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class LoadingIndicator extends StatelessWidget {
  final double size;

  LoadingIndicator({this.size = 10});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Platform.isIOS
            ? Container(
                padding: EdgeInsets.all((size / 2)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(size),
                  color: Theme.of(context).accentColor.withOpacity(0.9),
                ),
                child:
                    CupertinoActivityIndicator(animating: true, radius: size),
              )
            : CircularProgressIndicator(
                backgroundColor: Colors.blueGrey,
              ),
      ),
    );
  }
}
