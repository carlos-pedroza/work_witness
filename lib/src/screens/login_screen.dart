import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:work_witness/src/controller/utils.dart';
import 'package:work_witness/src/screens/projects.dart';
import 'package:work_witness/src/screens/subscribe_screen.dart';
import 'package:work_witness/src/widgets/button-circular.dart';
import '../controller/controller.dart';
import '../controller/models/subtoken.dart';
import 'package:connectivity/connectivity.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _firstStep = true;
  String _email;
  String _password;
  bool loading = false;

  showLoading() {
    loading = true;
  }

  hideLoading() {
    loading = false;
  }

  Widget subscribe() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 20),
          child: Text(
            'you don\'t have an account, \n subscribe it, it\'s free',
            style: TextStyle(
                color: Theme.of(context).primaryColorDark, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          padding: EdgeInsets.only(bottom: 4, left: 20, right: 20),
          child: OutlineButton(
            padding: EdgeInsets.all(20),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SubscribeScreen(),
                ),
              );
            },
            child: Text('subscribe',
                style: TextStyle(color: Colors.green[800], fontSize: 22)),
            textColor: Colors.green[800],
            color: Colors.green[800],
          ),
        )
      ],
    );
  }

  Widget logEmail(BuildContext context, String title) {
    return Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        padding: EdgeInsets.only(top: 10, bottom: 20),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            title != ''
                ? Container(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text(
                      title,
                      style: TextStyle(
                          color: Colors.blueGrey[800],
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                : Container(),
            Container(
              padding: EdgeInsets.all(10),
              color: Theme.of(context).primaryColorDark,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 8,
                    child: Container(
                      color: Colors.white60,
                      child: _firstStep
                          ? TextFormField(
                              key: UniqueKey(),
                              textCapitalization: TextCapitalization.none,
                              initialValue: _email,
                              obscureText: false,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                focusColor: Colors.white,
                                border: OutlineInputBorder(),
                                hintText: 'email',
                              ),
                              onChanged: (_value) {
                                _email = _value;
                              },
                            )
                          : TextFormField(
                              key: UniqueKey(),
                              initialValue: _password,
                              obscureText: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'password',
                              ),
                              onChanged: (_value) {
                                _password = _value;
                              },
                            ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: ButtonCircular(
                      loading: loading,
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      icon: Icons.navigate_next,
                      buttomSize: 40,
                      iconSize: 24,
                      loadingSize: 10,
                      tap: onLogin,
                    ),
                  ),
                ],
              ),
            ),
            _firstStep ? subscribe() : Container(),
          ],
        ));
  }

  Widget smallVertical() {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(),
            ),
            Expanded(
              flex: 3,
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).primaryColor,
                child: Image.asset(
                  'assets/images/logo_t.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Container(
              color: Theme.of(context).primaryColor,
              padding: EdgeInsets.all(6),
              child: Center(
                child: Text(
                  '1.2.1',
                  style: TextStyle(color: Colors.grey[800], fontSize: 12),
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: Container(
                color: Colors.white54,
                padding: EdgeInsets.only(top: 20),
                child: logEmail(context, 'Welcome!'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget smallHorizontal() {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.white54,
                padding:
                    EdgeInsets.only(top: 80, left: 20, right: 20, bottom: 0),
                child: logEmail(context, ''),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tablet() {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height - 80,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              flex: 6,
              child: Container(
                color: Theme.of(context).primaryColor,
                child: Image.asset(
                  'assets/images/logo_t.png',
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                width: 500,
                color: Colors.white54,
                padding: EdgeInsets.all(20),
                child: logEmail(context, 'Work Witness, welcome!'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void activeProblem(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Warning!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'You must activate your account email, if you want us to send you email validation again please visit: https://www.work-witness.app/panel'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  onLogin() {
    if (_firstStep == true) {
      if (_email.trim() != '') {
        setState(() {
          showLoading();
        });
        Controller.loginEmailEmployee(_email.toLowerCase())
            .then((Subtoken result) {
          setState(() {
            hideLoading();
            if (result != null) {
              if (result.isAccount && !result.active) {
                activeProblem(context);
              } else {
                Controller.setEmail(_email.toLowerCase());
                setState(() {
                  _firstStep = false;
                  _password = '';
                });
              }
            } else {
              Utils.showError(context, 'The email is not valid!');
            }
          });
        });
      }
    } else {
      if (_password.trim() != '') {
        setState(() {
          showLoading();
        });
        Controller.getSubtoken().then((Subtoken subtoken) {
          Controller.loginEmployee(subtoken, _password).then((bool result) {
            setState(() {
              hideLoading();
              if (result) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => Projects(),
                  ),
                );
              } else {
                Utils.showError(context, 'The password is not valid!');
              }
            });
          });
        });
      }
    }
  }

  Widget drawScreen() {
    if (MediaQuery.of(context).orientation == Orientation.portrait &&
        MediaQuery.of(context).size.width < 700.0) {
      return smallVertical();
    } else if (MediaQuery.of(context).orientation == Orientation.landscape &&
        MediaQuery.of(context).size.width < 800) {
      return smallHorizontal();
    } else {
      return tablet();
    }
  }

  void openDialogNoConnection() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Not Internet access'),
        content:
            Text('This application have to be able to connect to Internet'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Ok'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void openDialogNoConnectionCupertino() {
    showDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text('Not Internet access'),
        content:
            Text('This application have to be able to connect to Internet'),
        actions: <Widget>[
          CupertinoDialogAction(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void validConnection(BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      if (Platform.isIOS) {
        openDialogNoConnectionCupertino();
      } else {
        openDialogNoConnection();
      }
    }
  }

  @override
  void initState() {
    Controller.getEmail().then((String _emailPref) {
      setState(() {
        _email = _emailPref;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    validConnection(context);
    return drawScreen();
  }
}
