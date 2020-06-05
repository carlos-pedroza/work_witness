import 'package:flutter/material.dart';

class BackendScreen extends StatefulWidget {
  final Widget child;

  BackendScreen({
    @required this.child,
  });

  @override
  _BackendScreenState createState() => _BackendScreenState();
}

class _BackendScreenState extends State<BackendScreen> {
  bool backeendImage = false;

  @override
  void initState() {
    backeendImage = true;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (backeendImage) {
      return Container(
        color: Theme.of(context).primaryColorDark,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorDark,
            image: DecorationImage(
              image: AssetImage("assets/images/logo_t.png"),
              fit: BoxFit.none,
            ),
          ),
          child: widget.child,
        ),
      );
    } else {
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).primaryColorDark,
        child: widget.child,
      );
    }
  }
}
