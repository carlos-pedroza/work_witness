import 'package:flutter/material.dart';
import 'package:work_witness/src/controller/models/subscribe_info.dart';
import 'package:work_witness/src/controller/utils.dart';
import 'package:work_witness/src/screens/subscribe_accounts.dart';

class SubscribeFormularyScreen extends StatefulWidget {
  @override
  _SubscribeFormularyScreenState createState() =>
      _SubscribeFormularyScreenState();
}

class _SubscribeFormularyScreenState extends State<SubscribeFormularyScreen> {
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

  List<String> introduction = [
    'You are an individual or professional worker, you take you a long time to collect information and photos of your work done, you can reduce time and generate your reports automatically  to inform your clients using Work-Witness.',
    'You are a company that have a lot of employees, you can generate their reports and evidence of the work is not always an easy task, especially if they do their work in the clients\' offices, the supervision on time is very important and the control of the hours worked, schedules and absenteeism it is necessary. Work-witness provides you with the essential tools to take full control of the workers who perform their work in your clients\' offices remotely.',
    'You are a cooperative, being able to manage the work of different companies and their multiple employees without losing control is a challenge, for this reason, having technological tools to support you in this essential task is very important. Try Work-Witness and get support with this great tool to control your projects easily and efficiently.'
  ];

  String valid() {
    String result = '';

    setState(() {
      if (subscribeInfo.name.trim() == '') {
        result = 'the name is required';
        isNameError = true;
      } else {
        isNameError = false;
      }
      if (subscribeInfo.company.trim() == '') {
        result += (result != '' ? ', ' : '') + 'the company is required';
        isCompanyError = true;
      } else {
        isCompanyError = false;
      }
      subscribeInfo.email = subscribeInfo.email.toLowerCase().trim();
      bool emailValid = RegExp(
              r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
          .hasMatch(subscribeInfo.email);
      if (!emailValid) {
        result += (result != '' ? ', ' : '') + 'the email is invalid';
        isEmailError = true;
      } else {
        if (subscribeInfo.email == '') {
          result += (result != '' ? ', ' : '') + 'the email is required';
          isEmailError = true;
        } else {
          isEmailError = false;
        }
      }
      if (subscribeInfo.password.trim() == '') {
        result += (result != '' ? ', ' : '') + 'the password is required';
        isPasswordError = true;
      } else if (subscribeInfo.password != confirm) {
        result += (result != '' ? ', ' : '') +
            'the password and confirm must be equal';
        isPasswordError = true;
      } else {
        isPasswordError = false;
      }
    });

    return result;
  }

  @override
  Widget build(BuildContext context) {
    void goNext() {
      if (valid() == '') {
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
      extendBodyBehindAppBar: true,
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
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 80),
          height: MediaQuery.of(context).size.height - 80,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            image: DecorationImage(
              image: AssetImage("assets/images/logo_t.png"),
              fit: BoxFit.none,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: Card(
                margin: EdgeInsets.only(left: 0, right: 0),
                child: Container(
                  padding:
                      EdgeInsets.only(top: 20, bottom: 0, left: 20, right: 20),
                  child: SingleChildScrollView(
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
                            fillColor:
                                !isNameError ? Colors.white : Colors.red[100],
                            border: OutlineInputBorder(),
                            hintText: 'Name',
                          ),
                          onChanged: (String value) {
                            subscribeInfo.name = value;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: !isCompanyError
                                ? Colors.white
                                : Colors.red[100],
                            border: OutlineInputBorder(),
                            hintText: 'Company',
                          ),
                          onChanged: (String value) {
                            subscribeInfo.company = value;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor:
                                !isEmailError ? Colors.white : Colors.red[100],
                            border: OutlineInputBorder(),
                            hintText: 'Email',
                          ),
                          onChanged: (String value) {
                            subscribeInfo.email = value;
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
                          onChanged: (String value) {
                            subscribeInfo.password = value;
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
                          onChanged: (String value) {
                            confirm = value;
                          },
                        ),
                        SizedBox(height: 10),
                        Text(
                            'You can review our Privacy Policy in: https://www.work-witness.app',
                            style: TextStyle(color: Colors.black26)),
                        SizedBox(height: 200,),
                      ],
                    ),
                  ),
                ),
              )),
              Container(
                color: Theme.of(context).primaryColorDark,
                height: 80,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: RaisedButton(
                    color: Colors.green[800],
                    onPressed: goNext,
                    child: Text('continue',
                        style: Theme.of(context).textTheme.bodyText1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
