import 'package:flutter/material.dart';

class HomeAndroidScreen extends StatefulWidget {
  final AppBar appBar;
  final Widget body;

  const HomeAndroidScreen({@required this.appBar, @required this.body});

  @override
  _HomeAndroidScreenState createState() => _HomeAndroidScreenState();
}

class _HomeAndroidScreenState extends State<HomeAndroidScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: widget.appBar,
        body: widget.body,
      ),
    );
  }
}
