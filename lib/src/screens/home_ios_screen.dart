import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeIOSScreen extends StatefulWidget {
  final Widget body;
  final Widget appBar;

  const HomeIOSScreen({@required this.appBar, @required this.body});

  @override
  _HomeIOSScreenState createState() => _HomeIOSScreenState();
}

class _HomeIOSScreenState extends State<HomeIOSScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: widget.appBar,
        backgroundColor: Colors.transparent,
        body: widget.body,
      ),
    );
  }
}
