import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:work_witness/src/controller/controller.dart';
import 'package:work_witness/src/controller/controlller_local.dart';
import 'package:work_witness/src/controller/enums/check_type_enum.dart';
import 'package:work_witness/src/controller/models/employee.dart';
import 'package:work_witness/src/controller/models/project.dart';
import 'package:work_witness/src/controller/models/send_check.dart';
import 'package:work_witness/src/controller/models/token.dart';
import 'package:work_witness/src/screens/check_in.dart';
import 'package:work_witness/src/screens/home.dart';
import 'package:work_witness/src/screens/project_reports.dart';
import 'package:work_witness/src/widgets/loading_Indicator.dart';
import 'package:work_witness/src/widgets/project_card.dart';

class Projects extends StatefulWidget {
  @override
  _ProjectsState createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  ControllerLocal _controllerLocal;
  final DateTime _now = DateTime.now();
  Token token;
  Employee employee;
  List<Project> projects;
  bool loading = false;
  bool loadingReports = false;

  Future<void> getControllerLocal() async {
    _controllerLocal = await ControllerLocal.create();
  }

  @override
  void initState() {
    loading = true;
    projects = List<Project>();
    getControllerLocal();
    getListProjects();
    super.initState();
  }

  void getListProjects() {
    Controller.getToken().then((Token _token) {
      token = _token;
      Controller.employee(_token).then((Employee _employee) {
        employee = _employee;
        Controller.listProjects(_employee.id).then((List<Project> _projects) {
          setState(() {
            projects = _projects;
            loading = false;
          });
        });
      });
    });
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

  bool checkInToday(SendCheck sendCheck) {
    var _now = DateTime.now();
    if (_now.day == sendCheck.value.day &&
        _now.month == sendCheck.value.month &&
        _now.year == sendCheck.value.year) {
      return true;
    } else {
      return false;
    }
  }

  isToday(DateTime checkDate) {
    DateTime _now = DateTime.now();
    return checkDate.year == _now.year &&
        checkDate.month == _now.month &&
        checkDate.day == _now.day;
  }

  bool anyProject() {
    return projects.length > 0;
  }

  Widget content() {
    return !loading
        ? Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorDark.withOpacity(0.6),
                  border: Border(
                    top: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 1.0,
                    ),
                    bottom: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 1.0,
                    ),
                  ),
                ),
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      employee.name,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(DateFormat.yMMMMd('en_US').format(new DateTime.now()),
                        style: Theme.of(context).textTheme.bodyText2),
                  ],
                ),
              ),
              Expanded(
                child: !loadingReports
                    ? Container(
                        padding: EdgeInsets.only(top: 20),
                        child: anyProject()
                            ? ListView.builder(
                                itemCount: projects.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    splashColor:
                                        Colors.white54, // inkwell color
                                    child: ProjectCard(
                                      context: context,
                                      employee: employee,
                                      project: projects[index],
                                      refreshProjects: getListProjects,
                                    ),
                                    onTap: () {
                                      loading = true;
                                      Controller.lastCheck(projects[index].id,
                                              projects[index].idEmployee)
                                          .then((SendCheck sendCheck) {
                                        if (sendCheck != null) {
                                          if (sendCheck.idCheckType ==
                                              CheckType.key(
                                                  CheckTypeEnum.CheckOut)) {
                                            Navigator.of(context)
                                                .pushReplacement(
                                              MaterialPageRoute(
                                                builder: (context) => CheckIn(
                                                    project: projects[index],
                                                    checkTypeEnum:
                                                        CheckTypeEnum.CheckIn),
                                              ),
                                            );
                                          } else {
                                            Navigator.of(context)
                                                .pushReplacement(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProjectReports(
                                                  project: projects[index],
                                                  isBreakTime: sendCheck
                                                          .idCheckType ==
                                                      CheckType.key(
                                                          CheckTypeEnum
                                                              .BreakTimeStart),
                                                ),
                                              ),
                                            );
                                          }
                                        } else {
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) => CheckIn(
                                                  project: projects[index],
                                                  checkTypeEnum:
                                                      CheckTypeEnum.CheckIn),
                                            ),
                                          );
                                        }
                                      });
                                    },
                                  );
                                },
                              )
                            : Center(
                                child: Container(
                                  margin: EdgeInsets.all(30),
                                  padding: EdgeInsets.all(30),
                                    color: Theme.of(context).primaryColorDark.withOpacity(0.8),
                                  child: Text(
                                      'You have not been assigned a project yet',
                                      textAlign: TextAlign.center,
                                      style:
                                          Theme.of(context).textTheme.bodyText1),
                                )),
                      )
                    : LoadingIndicator(
                        size: 80,
                      ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(10),
                height: 90,
                color: Theme.of(context).primaryColorDark,
                child: Column(
                  children: <Widget>[
                    Text('support: support@work-witness.app',
                        style: TextStyle(color: Colors.white54, fontSize: 12)),
                    Text('Terms: https://www.work-witness.app/terms',
                        style: TextStyle(color: Colors.white54, fontSize: 12)),
                    Text('Privacy: https://www.work-witness.app/privacy_policy',
                        style: TextStyle(color: Colors.white54, fontSize: 12)),
                  ],
                ),
              ),
            ],
          )
        : LoadingIndicator(size: 40);
  }

  void logout() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => Home(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onExit,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColorDark,
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).primaryColorDark,
            title: Text('Work Witness',
                style: TextStyle(color: Colors.white, fontSize: 22)),
            centerTitle: true,
            leading: Container(),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: logout,
              ),
            ]),
        body: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            image: DecorationImage(
              image: AssetImage("assets/images/logo_t.png"),
              fit: BoxFit.none,
            ),
          ),
          child: content(),
        ),
      ),
    );
  }
}
