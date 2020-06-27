import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:work_witness/src/controller/controlller_local.dart';
import 'package:work_witness/src/controller/enums/check_type_enum.dart';
import 'package:work_witness/src/controller/models/project.dart';
import 'package:work_witness/src/controller/models/project_report.dart';
import './login_screen.dart';
import 'package:flutter/cupertino.dart';
import '../controller/enums/pages_screens_enum.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLogin = false;
  bool loading = false;
  bool backButton = false;
  PagesScreensEnum navigateBack;
  Widget page;
  bool showBackImage = false;
  ControllerLocal controllerLocal;

  @override
  void initState() {
    getControllerLocal();
    super.initState();
  }

  Future<void> getControllerLocal() async {
    controllerLocal = await ControllerLocal.create();
  }

  Future<bool> onBack() {
      return onExit();
  }

  Future<bool> onExit() {
    return showDialog(
      context: context,
      builder: (context) => !Platform.isIOS
          ? AlertDialog(
              title: Text('warning!'),
              content: Text('Do you want exit?'),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text('No')),
                FlatButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text('Yes')),
              ],
            )
          : CupertinoAlertDialog(
              title: Text('warning!'),
              content: Text('Do you want exit?'),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: new Text('No'),
                  onPressed: () => Navigator.pop(context, false),
                ),
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: new Text('Yes'),
                  onPressed: () => Navigator.pop(context, true),
                ),
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBack,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Theme.of(context).primaryColorDark,
        body: LoginScreen(),
      ),
    );
  }
}
