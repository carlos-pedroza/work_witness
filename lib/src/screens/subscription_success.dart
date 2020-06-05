import 'package:flutter/material.dart';
import 'package:work_witness/src/screens/home.dart';

class SubscriptionSuccess extends StatefulWidget {
  @override
  _SubscriptionSuccessState createState() => _SubscriptionSuccessState();
}

class _SubscriptionSuccessState extends State<SubscriptionSuccess> {
  Future<bool> onBack() async {
    return Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => Home()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onBack(),
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColorDark.withOpacity(0.6),
          title: Text('Work Witness',
              style: TextStyle(color: Colors.white, fontSize: 22)),
          centerTitle: true,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(top:90),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: 20, left: 10, right: 10),
                    child: Text(
                      'Welcome to Work Witness!',
                      style: TextStyle(color: Colors.white, fontSize: 38),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 20, left: 10, right: 10),
                    child: Text(
                      'congratulation!',
                      style: TextStyle(color: Colors.green, fontSize: 30),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 20, left: 10, right: 10),
                    child: Text(
                      'we sended you an email verification',
                      style: Theme.of(context).textTheme.bodyText1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 20, left: 10, right: 10),
                    child: Text(
                      'please verify your account to continue with the service',
                      style: Theme.of(context).textTheme.bodyText1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 20, left: 10, right: 10),
                    child: Text(
                      'To use your service administration panel please visit:',
                      style: TextStyle(color: Colors.cyan[200], fontSize: 22),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 20, left: 10, right: 10),
                    child: Text(
                      'https://www.work-witness.app/panel',
                      style: TextStyle(color: Colors.cyan[200], fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 40),
                  RaisedButton(
                    color: Theme.of(context).primaryColorDark,
                    padding: EdgeInsets.all(20),
                    onPressed: onBack,
                    child: Text(
                      'back to login',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
