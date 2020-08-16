import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:work_witness/src/controller/utils.dart';
import 'package:work_witness/src/screens/projects.dart';
import 'package:work_witness/src/screens/subscribe_screen.dart';
import 'package:work_witness/src/widgets/button-circular.dart';
import 'package:work_witness/src/widgets/loading_Indicator.dart';
import '../controller/controller.dart';
import '../controller/models/subtoken.dart';
import 'package:connectivity/connectivity.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String appVersion = '1.4.3';
  
  final _formEmailKey = GlobalKey<FormState>();
  final _formPasswordKey = GlobalKey<FormState>();

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

  verifyEmail() {
    Controller.loginEmailEmployee(_email.toLowerCase())
        .then((Subtoken result) {
      if (result != null) {
        if (result.isAccount && !result.active) {
          setState(() {
            loading = false;
          });
          activeProblem(context);
        } else {
          Controller.setEmail(_email.toLowerCase());
          setState(() {
            _firstStep = false;
            _password = '';
            loading = false;
          });
        }
      } else {
        setState(() {
          loading = false;
        });
        Utils.showError(context, 'The email is not valid!');
      }
    });
  }

  onLogin() {
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

  Widget emailForm() {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Form(
        key: _formEmailKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Welcome!', style: TextStyle(color: Colors.black54, fontSize: 22)),
            SizedBox(height: 10),
            TextFormField(
              textCapitalization: TextCapitalization.none,
              initialValue: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                focusColor: Colors.white,
                border: OutlineInputBorder(),
                hintText: 'email',
              ),
              validator: (value) {
                if (value.trim()=='') {
                  return 'Please enter your email!';
                } 
                return null;
              },
              onSaved: (newValue) {
                _email = newValue;
              },
              textInputAction: TextInputAction.go,
              onFieldSubmitted: (value) {
                var valid = _formEmailKey.currentState.validate();
                if(valid) {
                  setState(() {
                    loading = true;
                  });
                  _formEmailKey.currentState.save();
                  verifyEmail();
                }  
              },
            ),
            SizedBox(height: 10),
            RaisedButton(
              padding: EdgeInsets.only(left: 20, right: 20),
              color: Colors.lightBlue[700],
              onPressed: () {
                var valid = _formEmailKey.currentState.validate();
                if(valid) {
                  setState(() {
                    loading = true;
                  });
                  _formEmailKey.currentState.save();
                  verifyEmail();
                }  
              },
              child: Text('Continue', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 20),
            OutlineButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SubscribeScreen(),
                  ),
                );
              },
              child: Text('new user?, register here!',
                  style: TextStyle(color: Colors.green[800])),
              textColor: Colors.green[800],
              color: Colors.green[800],
            ),
            Text(appVersion, style: TextStyle(color: Colors.black45, fontSize: 10),),
          ],
        )
      ),
    );
  }

  Widget passwordForm() {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Form(
        key: _formPasswordKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             Text('Welcome!', style: TextStyle(color: Colors.black54, fontSize: 22)),
            SizedBox(height: 20),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                focusColor: Colors.white,
                border: OutlineInputBorder(),
                hintText: 'password',
              ),
              validator: (value) {
                if (value.trim()=='') {
                  return 'Please enter your password!';
                } 
                return null;
              },
              onSaved: (newValue) {
                _password = newValue;
              },
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (value) {
                var valid = _formPasswordKey.currentState.validate();
                if(valid) {
                  setState(() {
                    loading = true;
                  });
                  _formPasswordKey.currentState.save();
                  onLogin();
                }  
              },
            ),
            SizedBox(height: 20),
            RaisedButton(
              padding: EdgeInsets.only(left: 20, right: 20),
              color: Colors.lightBlue[700],
              onPressed: () {
                var valid = _formPasswordKey.currentState.validate();
                if(valid) {
                  setState(() {
                    loading = true;
                  });
                  _formPasswordKey.currentState.save();
                  onLogin();
                }  
              },
              child: Text('Sign in', style: TextStyle(color: Colors.white)),
            )
          ],
        )
      ),
    );
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

  bool mediaLadscape() {
    return (MediaQuery.of(context).orientation == Orientation.landscape);
  }

  @override
  Widget build(BuildContext context) {
    validConnection(context);
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: !mediaLadscape() ? 40 : 16,
              child: !mediaLadscape() ? 
              Container(
                color: Theme.of(context).primaryColor,
                child: Image.asset(
                  'assets/images/logo_t.png',
                ),
              )
              : Center(
                child: Container(
                  padding: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
                  child: Row(children: [
                    Text('WORK WITNESS', style: TextStyle(color: Colors.white, fontSize: 20),),
                    Text('v1.4.3', style: TextStyle(color: Colors.black45, fontSize: 10),),
                  ],)
                ),
              ),
            ),
            Expanded(
              flex: !mediaLadscape() ? 60 : 84,
              child: Container(
                color: Colors.white70,
                child: Center(child:
                  SizedBox(
                    width: MediaQuery.of(context).size.width > 500 ? 500 : MediaQuery.of(context).size.width-20,
                    child: !loading ? (_firstStep ? emailForm() : passwordForm()) : LoadingIndicator(size: 40,),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
