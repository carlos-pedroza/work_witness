import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:work_witness/src/controller/models/subscribe_info.dart';
import 'package:work_witness/src/screens/subscribe_accounts.dart';

class SubscribeFormularyScreen extends StatefulWidget {
  @override
  _SubscribeFormularyScreenState createState() =>
      _SubscribeFormularyScreenState();
}

class _SubscribeFormularyScreenState extends State<SubscribeFormularyScreen> {
  final _formKey = GlobalKey<FormState>();
  SubscribeInfo subscribeInfo = SubscribeInfo(
      name: '',
      company: '',
      email: '',
      password: '',
      idSubscription: 0,
      days: 0);
  String confirm = '';
  bool isNameError = false;
  bool isCompanyError = false;
  bool isEmailError = false;
  bool isPasswordError = false;

  bool terms = false;

  List<String> introduction = [
    'You are an individual or professional worker, you take you a long time to collect information and photos of your work done, you can reduce time and generate your reports automatically  to inform your clients using Work-Witness.',
    'You are a company that have a lot of employees, you can generate their reports and evidence of the work is not always an easy task, especially if they do their work in the clients\' offices, the supervision on time is very important and the control of the hours worked, schedules and absenteeism it is necessary. Work-witness provides you with the essential tools to take full control of the workers who perform their work in your clients\' offices remotely.',
    'You are a cooperative, being able to manage the work of different companies and their multiple employees without losing control is a challenge, for this reason, having technological tools to support you in this essential task is very important. Try Work-Witness and get support with this great tool to control your projects easily and efficiently.'
  ];

  @override
  Widget build(BuildContext context) {

    void goNext() {
      var valid = _formKey.currentState.validate();
      if (valid == true) {
        _formKey.currentState.save();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                SubscribeAccountScreen(subscribeInfo: subscribeInfo),
          ),
        );
      } 
    }

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColorDark.withOpacity(0.6),
        title: Text('Work Witness',
            style: TextStyle(color: Colors.white, fontSize: 22)),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(
              Icons.navigate_before,
              color: Colors.white,
              size: 28,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: ListView(children: [
        Card( 
          margin: EdgeInsets.only(left: 0, right: 0),
          child: Container(
            padding: EdgeInsets.only(top: 20, bottom: 0, left: 20, right: 20),
            child: Form(
              key: _formKey,
              child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Please fill out the follow information!',
                    style: Theme.of(context).textTheme.subtitle1,
                    textAlign: TextAlign.center,
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    hintText: 'Name',
                  ),
                  validator: (value) {
                    if (value.trim() == '') {
                      return 'the name is required';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    subscribeInfo.name = newValue;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    hintText: 'Company',
                  ),
                  validator: (value) {
                    if (value.trim() == '') {
                      return 'the company is required';
                    } 
                    return null;
                  },
                  onSaved: (newValue) {
                    subscribeInfo.company = newValue;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    hintText: 'Email',
                  ),
                  validator: (value) {
                    if (value.trim() == '') {
                      return 'the email is required';
                    }
                    bool emailValid = RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                        .hasMatch(value);
                    if (!emailValid) {
                      return 'the email is invalid';
                    } 
                    return null;                
                  },
                  onSaved: (newValue) {
                    subscribeInfo.email = newValue;
                  },
                ),
                SizedBox(height: 30),
                TextFormField(
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: !isPasswordError
                        ? Colors.white
                        : Colors.red[100],
                    border: OutlineInputBorder(),
                    hintText: 'new password',
                  ),
                  validator: (value) {
                    if (value.trim() == '') {
                      return 'the password is required';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    subscribeInfo.password = value;
                  },
                  onSaved: (newValue) {
                    subscribeInfo.password = newValue;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: !isPasswordError
                        ? Colors.white
                        : Colors.red[100],
                    border: OutlineInputBorder(),
                    hintText: 'confirm password',
                  ),
                  validator: (value) {
                    if(value.trim() == '') {
                      return 'must confirm the password';
                    }
                    if (subscribeInfo.password != value) {
                      return 'the password, confirm must be equal';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    confirm = newValue;
                  },
                ),
                SizedBox(height: 10),
                Text(
                  'Privacy Policy and Terms and Conditions in: https://www.work-witness.app',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                  color: Colors.green[800],
                  padding: EdgeInsets.only(top: 20, left: 40, bottom: 20, right: 40),
                  onPressed: goNext,
                  child: Text('continue',
                      style: Theme.of(context).textTheme.bodyText1),
                ),
                SizedBox(
                  height: 300,
                ),
              ]),
            ),
          ),
        ),
      ],),
    );
  }
}
